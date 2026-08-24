# 2048 小游戏 - TrollStore IPA

一个使用 HTML5 开发的 2048 数字合并游戏，打包为无签名 IPA，通过 TrollStore 安装到 iPhone。

## 游戏特性

- 经典 2048 玩法，滑动合并相同数字
- 深色渐变主题，流畅动画
- 触摸滑动操控，适配 iPhone 全面屏
- 本地保存最高分
- 合成音效 (Web Audio API)

## 项目结构

```
├── Sources/                  # Swift 源码 (WKWebView 壳)
│   ├── AppDelegate.swift
│   └── ViewController.swift
├── Resources/
│   └── web/
│       └── index.html        # HTML5 游戏主体
├── SupportingFiles/
│   └── Info.plist
├── Assets.xcassets/          # 应用图标
├── project.yml               # XcodeGen 工程配置
├── scripts/
│   └── build_ipa.sh          # 本地构建脚本
└── .github/workflows/
    └── build-ipa.yml         # GitHub Actions CI
```

## 构建方法

### 方法一：GitHub Actions（推荐，无需 Mac）

1. 将本项目推送到 GitHub 仓库
2. 进入仓库 **Actions** 页面，点击 **Build IPA** 工作流
3. 点击 **Run workflow** 手动触发，或直接 push 代码自动触发
4. 等待构建完成（约 3-5 分钟）
5. 在构建结果中下载 **Game2048-IPA** artifact
6. 解压得到 `Game2048.ipa`

### 方法二：本地 Mac 构建

需要安装 Xcode 和 [XcodeGen](https://github.com/yonaskolb/XcodeGen)：

```bash
# 安装 XcodeGen
brew install xcodegen

# 运行构建脚本
cd /path/to/this/project
bash scripts/build_ipa.sh
```

构建完成后，`Game2048.ipa` 在项目根目录。

## 安装到 iPhone

1. 将 `Game2048.ipa` 传到 iPhone（AirDrop / Safari 下载 / 文件共享均可）
2. 在 **TrollStore** 中点击右上角 **+** 或 **Install IPA**
3. 选择 `Game2048.ipa` 进行安装
4. 安装完成后，桌面出现 **2048** 图标
5. 打开即可游玩

## 玩法

- **上下左右滑动** 移动所有方块
- 相同数字的方块碰撞时合并为两倍值
- 达到 **2048** 即可获胜，也可继续挑战更高分数
- 方块无法移动时游戏结束

## 技术说明

- 游戏逻辑：纯 HTML5 + CSS3 + JavaScript（单文件，无外部依赖）
- iOS 壳：Swift + UIKit + WKWebView，加载本地 HTML
- 编译时关闭代码签名（`CODE_SIGNING_ALLOWED=NO`），TrollStore 利用 CoreTrust 漏洞直接安装
- 最低支持 iOS 14.0
