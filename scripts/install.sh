#!/usr/bin/env bash
set -euo pipefail

REPO_RAW_URL="${CHROME_CDP_GUARD_RAW_URL:-https://raw.githubusercontent.com/joeseesun/chrome-cdp-consent-guard/main}"
INSTALL_DIR="${CHROME_CDP_GUARD_INSTALL_DIR:-${HOME}/.local/bin}"
TARGET="${INSTALL_DIR}/chrome-cdp-consent-guard"

need_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "chrome-cdp-consent-guard is intended for macOS." >&2
    exit 1
  fi
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

main() {
  need_macos
  need_command curl
  need_command launchctl

  mkdir -p "$INSTALL_DIR"
  curl -fsSL "${REPO_RAW_URL}/bin/chrome-cdp-consent-guard" -o "$TARGET"
  chmod +x "$TARGET"

  "$TARGET" install

  echo
  echo "Installed: $TARGET"
  echo "Status:    $TARGET status"
  echo "Logs:      $TARGET logs"
}

main "$@"
