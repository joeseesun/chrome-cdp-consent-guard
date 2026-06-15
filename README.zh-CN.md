# Chrome CDP Consent Guard

一个 macOS 小守护脚本：当 Chrome 弹出「要允许远程调试吗？」这类 CDP / DevTools 用户同意窗口时，自动点击允许，避免本地 AI Agent / Playwright / Chrome DevTools Protocol 工作流被卡住。

它不是通用弹窗破解器。脚本会先确认弹窗文本里包含远程调试 / DevTools / CDP 相关关键词，再点击允许类按钮。

[![CI](https://github.com/joeseesun/chrome-cdp-consent-guard/actions/workflows/ci.yml/badge.svg)](https://github.com/joeseesun/chrome-cdp-consent-guard/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 一行安装

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

## 实测验证

发布前已验证：

- `bash -n bin/chrome-cdp-consent-guard`
- `bash -n scripts/install.sh`
- `bin/chrome-cdp-consent-guard --help`
- 远端 raw 脚本可通过 `bash -n` 语法检查
- macOS 中文 Chrome 弹窗「要允许远程调试吗？」可被识别为 `AXSheet` 并由 watch 模式接管

dry-run 匹配时会输出类似：

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

守护脚本只在以下条件同时满足时动作：

1. 支持的浏览器进程正在运行。
2. 当前浏览器窗口存在 sheet / dialog 类容器。
3. 弹窗文本匹配 Chrome DevTools / remote debugging 相关关键词。
4. 找到允许类按钮，或弹窗文本已确认是远程调试且按钮组结构符合 Chrome 的同意窗口。

它适合你信任本地发起 CDP 连接的开发工具或 AI Agent 时使用。不要把它用于绕过不可信应用的权限提示。

## 排错

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
