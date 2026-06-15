# Chrome CDP Consent Guard

Automatically accepts Chrome's macOS remote-debugging consent dialog when a trusted local automation tool connects through CDP.

Chrome may show a modal titled "Allow remote debugging?" / "要允许远程调试吗？" before allowing DevTools Protocol control. That is a good safety prompt, but it can block local agent workflows that repeatedly attach to a browser you already trust. This guard watches for that specific dialog and accepts it only when the dialog text clearly matches Chrome DevTools / remote debugging.

## Features

- macOS LaunchAgent watchdog for Chrome CDP consent prompts.
- Matches dialog content before clicking; it does not blindly click every Chrome dialog.
- Supports Google Chrome, Chrome Beta, Chrome Canary, Chromium, Microsoft Edge, and Brave Browser.
- Handles English and Chinese Chrome UI text.
- No runtime dependencies beyond macOS system tools.
- Provides `watch`, `once`, `status`, `install`, `uninstall`, and `logs` commands.

## Quick Install

Inspect the installer first if you want to see exactly what it changes:

```bash
curl -fsSL https://raw.githubusercontent.com/joeseesun/chrome-cdp-consent-guard/main/scripts/install.sh
```

Install and start the LaunchAgent:

```bash
curl -fsSL https://raw.githubusercontent.com/joeseesun/chrome-cdp-consent-guard/main/scripts/install.sh | bash
```

Check status:

```bash
~/.local/bin/chrome-cdp-consent-guard status
launchctl print gui/$(id -u)/com.qiaomu.chrome-cdp-consent-guard
```

## Manual Usage

```bash
git clone https://github.com/joeseesun/chrome-cdp-consent-guard.git
cd chrome-cdp-consent-guard

bin/chrome-cdp-consent-guard status
bin/chrome-cdp-consent-guard once --dry-run
bin/chrome-cdp-consent-guard install
bin/chrome-cdp-consent-guard logs
```

## Commands

```text
chrome-cdp-consent-guard [watch] [options]
chrome-cdp-consent-guard once [options]
chrome-cdp-consent-guard status
chrome-cdp-consent-guard install [options]
chrome-cdp-consent-guard uninstall
chrome-cdp-consent-guard logs
```

Useful options:

```text
--interval SECONDS   Poll interval for watch/install. Default: 0.5
--timeout SECONDS    Max seconds for one AppleScript scan. Default: 8
--apps LIST          Browser process names separated by "|"
--buttons LIST       Accept button names separated by "|"
--keywords LIST      Dialog keywords separated by "|"
--dry-run            Report the matching button without clicking
```

## Permissions

This tool uses macOS Accessibility through `System Events`. If macOS asks, grant Accessibility permission to the app that runs it:

- Terminal, iTerm, or your agent app for manual runs.
- The LaunchAgent process path if macOS prompts after installation.

Open:

```text
System Settings -> Privacy & Security -> Accessibility
```

## Safety Boundary

The guard only acts when:

1. A supported browser process is running.
2. The active browser window has a sheet/dialog-like container.
3. The dialog text matches Chrome DevTools / remote debugging keywords.
4. A matching allow-style button is found, or the dialog matches remote-debugging text and exposes a button group where the last action button is the allow button.

It is intended for local developer and AI-agent workflows where you trust the application requesting CDP access. Do not use it to bypass prompts for untrusted applications.

## Uninstall

```bash
~/.local/bin/chrome-cdp-consent-guard uninstall
rm -f ~/.local/bin/chrome-cdp-consent-guard
```

## Author

Created by 向阳乔木 / Joe.

- GitHub: https://github.com/joeseesun
- X: https://x.com/vista8
- Website: https://qiaomu.ai
- Blog: https://blog.qiaomu.ai

## License

MIT
