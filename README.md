# Chrome CDP Consent Guard

> 当 Chrome CDP / DevTools 远程调试同意弹窗出现时，只在确认弹窗文本匹配后自动点击允许。
> Automatically accepts Chrome's remote-debugging consent dialog for trusted local automation on macOS.

[![CI](https://github.com/joeseesun/chrome-cdp-consent-guard/actions/workflows/ci.yml/badge.svg)](https://github.com/joeseesun/chrome-cdp-consent-guard/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**中文** | [English](#english)

Chrome 现在可能会在外部应用通过 Chrome DevTools Protocol 控制浏览器前弹出用户同意窗口，例如中文界面的「要允许远程调试吗？」。这个提示本身是合理的安全边界，但会卡住你已经信任的本地 AI Agent、Playwright、浏览器自动化或调试工作流。

这个守护脚本只监听特定浏览器的 CDP / DevTools 同意弹窗，并且先确认弹窗文本包含远程调试相关关键词，再点击允许按钮。它不是通用弹窗破解器。

## 为什么值得用

- 让本地 AI Agent / Codex / Playwright / CDP 调试流程不再被 Chrome 同意弹窗打断。
- 通过 LaunchAgent 常驻后台，登录后自动工作。
- 匹配弹窗内容后才点击，避免误点普通浏览器弹窗。
- 只依赖 macOS 自带工具：`bash`、`osascript`、`launchctl`。

## 核心能力

- 支持 Google Chrome、Chrome Beta、Chrome Canary、Chromium、Microsoft Edge、Brave Browser。
- 支持英文和中文 Chrome UI 文案。
- 提供 `watch`、`once`、`status`、`install`、`uninstall`、`logs` 命令。
- 支持自定义轮询间隔、AppleScript 超时、浏览器进程名、按钮词和弹窗关键词。

## 快速开始

先查看安装脚本：

```bash
curl -fsSL https://raw.githubusercontent.com/joeseesun/chrome-cdp-consent-guard/main/scripts/install.sh
```

安装并启动 LaunchAgent：

```bash
curl -fsSL https://raw.githubusercontent.com/joeseesun/chrome-cdp-consent-guard/main/scripts/install.sh | bash
```

查看状态：

```bash
~/.local/bin/chrome-cdp-consent-guard status
launchctl print gui/$(id -u)/com.qiaomu.chrome-cdp-consent-guard
```

## 手动使用

```bash
git clone https://github.com/joeseesun/chrome-cdp-consent-guard.git
cd chrome-cdp-consent-guard

bin/chrome-cdp-consent-guard status
bin/chrome-cdp-consent-guard once --dry-run
bin/chrome-cdp-consent-guard install
bin/chrome-cdp-consent-guard logs
```

## 命令

```text
chrome-cdp-consent-guard [watch] [options]
chrome-cdp-consent-guard once [options]
chrome-cdp-consent-guard status
chrome-cdp-consent-guard install [options]
chrome-cdp-consent-guard uninstall
chrome-cdp-consent-guard logs
```

常用参数：

```text
--interval SECONDS   watch/install 轮询间隔，默认 0.5
--timeout SECONDS    单次 AppleScript 扫描最大秒数，默认 8
--apps LIST          浏览器进程名，用 "|" 分隔
--buttons LIST       允许类按钮名，用 "|" 分隔
--keywords LIST      弹窗关键词，用 "|" 分隔
--dry-run            只报告匹配结果，不点击
```

## 实测验证

发布前已验证：

- `bash -n bin/chrome-cdp-consent-guard`
- `bash -n scripts/install.sh`
- `bin/chrome-cdp-consent-guard --help`
- 远端 raw 脚本可通过 `bash -n` 语法检查
- macOS 中文 Chrome 弹窗「要允许远程调试吗？」可被识别为 `AXSheet` 并由 watch 模式接管

当弹窗存在且使用 dry-run 时，预期输出类似：

```text
[YYYY-MM-DD HH:MM:SS] DRY_RUN MATCHED Google Chrome last dialog button
```

## 权限

脚本通过 macOS Accessibility 调用 `System Events`。如果系统提示授权，请到：

```text
系统设置 -> 隐私与安全性 -> 辅助功能
```

给运行它的应用授权，例如 Terminal、iTerm、Codex，或者安装后的 LaunchAgent 运行路径。

## 安全边界

守护脚本只会在以下条件同时满足时动作：

1. 支持的浏览器进程正在运行。
2. 当前浏览器窗口存在 sheet / dialog 类容器。
3. 弹窗文本匹配 Chrome DevTools / remote debugging 相关关键词。
4. 找到允许类按钮，或弹窗文本已确认是远程调试且按钮组结构符合 Chrome 的同意窗口。

它适合你信任本地发起 CDP 连接的开发工具或 AI Agent 时使用。不要把它用于绕过不可信应用的权限提示。

## Troubleshooting

- `status` 显示 Accessibility disabled：给运行脚本的应用授予辅助功能权限。
- LaunchAgent 没有运行：执行 `~/.local/bin/chrome-cdp-consent-guard install` 后再查 `launchctl print gui/$(id -u)/com.qiaomu.chrome-cdp-consent-guard`。
- 弹窗没被点击：用 `once --dry-run --timeout 8` 看是否匹配；如浏览器不是默认列表里的进程名，用 `--apps` 或 `CHROME_CDP_GUARD_APPS` 扩展。
- 误触风险：先用 `--dry-run` 观察输出，再启用 `watch` 或 `install`。

## 卸载

```bash
~/.local/bin/chrome-cdp-consent-guard uninstall
rm -f ~/.local/bin/chrome-cdp-consent-guard
```

## 关于向阳乔木

Created by 向阳乔木 / 乔向阳 / Joe.

- 个人站: https://qiaomu.ai
- 博客: https://blog.qiaomu.ai
- 乔木推荐: https://tuijian.qiaomu.ai
- GitHub: https://github.com/joeseesun
- X: https://x.com/vista8
- 微信公众号: 向阳乔木推荐看

## License

MIT

---

<a name="english"></a>

# English

Chrome CDP Consent Guard is a small macOS watchdog for the Chrome DevTools Protocol remote-debugging consent dialog. It keeps trusted local automation workflows moving while preserving a narrow safety boundary: match the dialog text first, then click the allow-style button.

## Why Use It

- Prevents trusted local agent, Playwright, and CDP workflows from being blocked by Chrome's remote-debugging consent dialog.
- Runs as a per-user LaunchAgent after installation.
- Checks dialog text before clicking, so it is not a generic browser dialog clicker.
- Uses only built-in macOS tools.

## Install

Inspect the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/joeseesun/chrome-cdp-consent-guard/main/scripts/install.sh
```

Install and start:

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

## Limits

This tool is intended for local developer and AI-agent workflows where you trust the app requesting CDP access. It should not be used to bypass permission prompts for untrusted applications.

## Author

Created by 向阳乔木 / 乔向阳 / Joe.

- Website: https://qiaomu.ai
- Blog: https://blog.qiaomu.ai
- Qiaomu Recommendations: https://tuijian.qiaomu.ai
- GitHub: https://github.com/joeseesun
- X: https://x.com/vista8
- WeChat public account: 向阳乔木推荐看
