# WordPicker

macOS 划词翻译应用 - 选中英文单词自动弹出中文翻译。

## 功能

- 划词翻译：选中英文单词后自动弹出翻译
- 本地词典：离线使用，无需联网
- 菜单栏常驻：不占用 Dock 位置
- 快捷键：Cmd+Shift+T 开关翻译

## 下载安装

从 [Releases](../../releases) 页面下载最新的 `WordPicker.zip`，解压后将 `WordPicker.app` 拖入 Applications 文件夹。

首次运行需要授权：
1. 系统偏好设置 → 隐私与安全性 → 辅助功能
2. 添加 WordPicker 到允许列表

## 本地构建

需要 Xcode 15+ 和 xcodegen：

```bash
# 安装 xcodegen
brew install xcodegen

# 生成项目
xcodegen generate

# 用 Xcode 打开
open WordPicker.xcodeproj
```

按 `Cmd+R` 运行即可。

## 添加更多词典

编辑 `prepare_dict.py` 添加更多单词，或下载完整 ECDICT 词典：

```bash
python3 prepare_dict.py
```
