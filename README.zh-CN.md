# Chrome CDP Consent Guard

一个 macOS 小守护脚本：当 Chrome 弹出“要允许远程调试吗？”这类 CDP / DevTools 用户同意窗口时，自动点击允许，避免本地 AI Agent / Playwright / Chrome DevTools Protocol 工作流被卡住。

它不是通用弹窗破解器。脚本会先确认弹窗文本里包含远程调试 / DevTools / CDP 相关关键词，再点击允许类按钮。

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

## 权限

脚本通过 macOS Accessibility 调用 `System Events`。如果系统提示授权，请到：

```text
系统设置 -> 隐私与安全性 -> 辅助功能
```

给运行它的应用授权，例如 Terminal、iTerm、Codex，或者安装后的 LaunchAgent 运行路径。

## 卸载

```bash
~/.local/bin/chrome-cdp-consent-guard uninstall
rm -f ~/.local/bin/chrome-cdp-consent-guard
```

## 作者

向阳乔木 / Joe

- GitHub: https://github.com/joeseesun
- X: https://x.com/vista8
- 个人站: https://qiaomu.ai
- 博客: https://blog.qiaomu.ai

## License

MIT
