#!/usr/bin/env python3
"""Generates shields.io endpoint badges for the README downloads table.

Reads a release of this repository through the GitHub API (the latest
non-pre-release by default), its ``release-info.json`` asset written by the
release workflow from the built files (minimum OS versions, signing
certificate) and the download count of every asset. Writes one JSON file per
badge into the output directory, in the shields.io endpoint format
(https://shields.io/badges/endpoint-badge).

The badges workflow publishes these files on the ``badges`` branch, and
README.md renders them through ``https://img.shields.io/endpoint?url=...``.

Usage:
    update_badges.py OUTPUT_DIR [--tag TAG]

Environment:
    GITHUB_REPOSITORY  ``owner/name`` of the repository (set by GitHub Actions).
    GH_TOKEN           Optional token; raises the GitHub API rate limit.

Writes nothing and exits successfully when there is no release yet.
"""

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

API = "https://api.github.com"

# Android API level -> marketing version, for the "Android 7.0+" badge.
ANDROID_VERSIONS = {
    21: "5.0", 22: "5.1", 23: "6.0", 24: "7.0", 25: "7.1", 26: "8.0",
    27: "8.1", 28: "9", 29: "10", 30: "11", 31: "12", 32: "12L",
    33: "13", 34: "14", 35: "15", 36: "16", 37: "17",
}


def android_minimum(meta: dict) -> str:
    """Formats the minimum Android version from the APK's ``min_api``."""
    api = meta.get("min_api")
    if api is None:
        return "unknown"
    return f"{ANDROID_VERSIONS.get(api, '?')}+ (API {api})"


def apple_minimum(meta: dict) -> str:
    """Formats the minimum iOS/macOS version from the app's Info.plist."""
    version = meta.get("min_os")
    if not version:
        return "unknown"
    return f"{version}+"


def fixed(text: str) -> Callable[[dict], str]:
    """Returns a formatter for platforms whose builds carry no minimum."""
    return lambda _meta: text


@dataclass(frozen=True)
class Platform:
    """One row of the downloads table."""

    target: str  # build target and asset suffix key, e.g. "android"
    name: str  # badge label
    logo: str  # simple-icons name used by shields.io
    color: str  # badge message color
    asset_suffix: str  # file name after "<repo>-"
    button: str  # file type shown on the download button
    minimum: Callable[[dict], str]  # builds the minimum-version text


PLATFORMS = [
    Platform("android", "Android", "android", "3DDC84", "android.apk", "APK", android_minimum),
    Platform("windows", "Windows", "windows", "0078D4", "windows.zip", "ZIP", fixed("10 / 11 x64")),
    Platform("macos", "macOS", "apple", "000000", "macos.zip", "ZIP", apple_minimum),
    Platform("linux", "Linux", "linux", "E95420", "linux.tar.gz", "tar.gz", fixed("x64 · GTK 3")),
    Platform("ios", "iOS", "apple", "000000", "ios-unsigned.ipa", "IPA", apple_minimum),
    Platform("web", "Web", "googlechrome", "4285F4", "web.zip", "ZIP", fixed("WebGL")),
]


def badge(label: str, message: str, color: str, logo: str | None = None) -> dict:
    """Builds a shields.io endpoint badge object."""
    data = {"schemaVersion": 1, "label": label, "message": message, "color": color}
    if logo:
        data["namedLogo"] = logo
        data["logoColor"] = "white"
    return data


def fetch_json(url: str, token: str | None) -> dict | None:
    """GETs ``url`` as JSON; returns ``None`` on HTTP 404."""
    headers = {"Accept": "application/vnd.github+json", "User-Agent": "update-badges"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    try:
        with urllib.request.urlopen(urllib.request.Request(url, headers=headers)) as response:
            return json.load(response)
    except urllib.error.HTTPError as error:
        if error.code == 404:
            return None
        raise


def load_release(repo: str, tag: str | None, token: str | None) -> dict | None:
    """Returns the requested release, or the latest non-pre-release."""
    path = f"releases/tags/{tag}" if tag else "releases/latest"
    return fetch_json(f"{API}/repos/{repo}/{path}", token)


def load_release_info(assets: dict) -> dict:
    """Downloads ``release-info.json`` from the release, if it has one."""
    asset = assets.get("release-info.json")
    if asset is None:
        return {}
    # Public download URL: no auth header, which the CDN redirect rejects.
    with urllib.request.urlopen(asset["browser_download_url"]) as response:
        return json.load(response)


def size_text(size: int) -> str:
    """Formats a byte count in megabytes (SI)."""
    return f"{size / 1_000_000:.1f} MB"


def signing_badge(android: dict) -> dict:
    """Describes who signed the Android APK; flags debug-signed builds."""
    signer = android.get("signer")
    if not signer:
        return badge("signed", "unknown", "lightgrey")
    if signer == "Android Debug":
        return badge("signed", "debug key", "red")
    return badge("signed", f"CN={signer}", "6f42c1")


def build_badges(repo: str, release: dict, info: dict) -> dict[str, dict]:
    """Maps badge file names to badge objects for ``release``."""
    repo_name = repo.split("/", 1)[1]
    assets = {asset["name"]: asset for asset in release["assets"]}
    badges = {
        "release": badge("release", release["tag_name"], "orange"),
        "released": badge("released", release["published_at"][:10], "brightgreen"),
        "signed": signing_badge(info.get("android", {})),
    }

    for platform in PLATFORMS:
        meta = info.get(platform.target, {})
        badges[platform.target] = badge(
            platform.name, platform.minimum(meta), platform.color, platform.logo
        )
        asset = assets.get(f"{repo_name}-{platform.asset_suffix}")
        if asset is None:
            badges[f"{platform.target}-size"] = badge("size", "n/a", "lightgrey")
            badges[f"{platform.target}-downloads"] = badge(
                f"download {platform.button}", "n/a", "lightgrey", "github"
            )
            continue
        badges[f"{platform.target}-size"] = badge("size", size_text(asset["size"]), "informational")
        badges[f"{platform.target}-downloads"] = badge(
            f"download {platform.button}", str(asset["download_count"]), "2ea44f", "github"
        )

    return badges


def main() -> int:
    """Entry point; see the module docstring."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("output", type=Path, help="directory for the badge JSON files")
    parser.add_argument("--tag", help="release tag (default: latest non-pre-release)")
    args = parser.parse_args()

    repo = os.environ.get("GITHUB_REPOSITORY")
    if not repo:
        print("GITHUB_REPOSITORY is not set (expected owner/name).", file=sys.stderr)
        return 2
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")

    release = load_release(repo, args.tag, token)
    if release is None:
        print("No published release yet; nothing to do.")
        return 0

    info = load_release_info({asset["name"]: asset for asset in release["assets"]})
    badges = build_badges(repo, release, info)

    args.output.mkdir(parents=True, exist_ok=True)
    for name, data in badges.items():
        (args.output / f"{name}.json").write_text(json.dumps(data, ensure_ascii=False) + "\n")
    print(f"Wrote {len(badges)} badges for {release['tag_name']} to {args.output}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
