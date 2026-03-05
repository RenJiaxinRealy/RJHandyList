# RJHandyList 发布指南

本指南将帮助你把 RJHandyList 发布到 GitHub 并通过 CocoaPods 供他人使用。

## 第一步：准备 GitHub 仓库

### 1.1 创建 GitHub 仓库

1. 访问 https://github.com
2. 点击右上角 "+" → "New repository"
3. 填写仓库名称（例如：`RJHandyList`）
4. 选择公开（Public）
5. **不要** 勾选 "Initialize this repository with a README"
6. 点击 "Create repository"

### 1.2 修改配置文件

打开以下文件并替换占位符为你的信息：

**RJHandyList.podspec** (第 25-28 行):
```ruby
# 修改为你的 GitHub 仓库地址
s.homepage         = 'https://github.com/YOUR_USERNAME/RJHandyList'

# 修改为你的邮箱
s.author           = { 'Jin Rookie' => 'your.email@example.com' }

# 修改为你的 GitHub 仓库地址
s.source           = { :git => 'https://github.com/YOUR_USERNAME/RJHandyList.git', :tag => s.version.to_s }
```

### 1.3 初始化 Git 仓库并推送

在项目根目录执行：

```bash
cd /Users/jinrookie/Documents/公司项目/RJHandyListDemo

# 初始化 git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit of RJHandyList"

# 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/YOUR_USERNAME/RJHandyList.git

# 推送主分支
git branch -M main
git push -u origin main
```

### 1.4 创建第一个版本标签

```bash
# 创建标签
git tag 0.1.0

# 推送标签
git push origin 0.1.0
```

---

## 第二步：验证 Podspec

### 2.1 安装 CocoaPods（如果未安装）

```bash
sudo gem install cocoapods
```

### 2.2 更新 CocoaPods

```bash
pod setup
```

### 2.3 验证 Podspec

在项目根目录执行：

```bash
#  lint 验证（不推送）
pod lib lint RJHandyList.podspec --allow-warnings

# 如果有警告但想通过
pod lib lint RJHandyList.podspec --allow-warnings --verbose
```

**常见错误及解决方法：**

| 错误 | 解决方法 |
|------|----------|
| `source_files` 找不到 | 检查路径是否正确 |
| `swift_version` 错误 | 确保 Swift 版本格式正确 |
| `deployment_target` 错误 | 确保版本号格式正确 |

---

## 第三步：发布到 CocoaPods

### 3.1 注册 CocoaPods 账号（首次）

```bash
pod trunk register your.email@example.com 'Your Name'
```

然后检查邮箱，点击验证链接。

### 3.2 查看账号信息

```bash
pod trunk me
```

### 3.3 推送 Podspec

```bash
# 推送到 CocoaPods trunk
pod trunk push RJHandyList.podspec --allow-warnings
```

### 3.4 验证发布

等待几分钟后，访问：
```
https://cocoapods.org/pods/RJHandyList
```

---

## 第四步：后续版本更新

### 4.1 更新版本号

修改 **RJHandyList.podspec**:
```ruby
s.version = '0.2.0'  # 更新版本号
```

### 4.2 提交更改并创建新标签

```bash
git add RJHandyList.podspec
git commit -m "Release version 0.2.0"
git tag 0.2.0
git push origin main
git push origin 0.2.0
```

### 4.3 推送到 CocoaPods

```bash
pod trunk push RJHandyList.podspec --allow-warnings
```

---

## 版本规范

遵循 [语义化版本](https://semver.org/)：

- **MAJOR.MINOR.PATCH** (例如：1.0.0)
- **MAJOR**: 不兼容的 API 更改
- **MINOR**: 向后兼容的功能添加
- **PATCH**: 向后兼容的问题修复

---

## 检查清单

在发布前确认：

- [ ] README.md 已填写完整
- [ ] LICENSE 文件存在
- [ ] .gitignore 已配置
- [ ] podspec 中的仓库地址已修改
- [ ] podspec 中的邮箱已修改
- [ ] 代码已通过 `pod lib lint` 验证
- [ ] 已创建 git 标签
- [ ] 标签已推送到 GitHub

---

## 常见问题

### Q: `pod trunk push` 失败怎么办？

A: 先运行 `pod lib lint` 查看具体错误，常见原因：
- podspec 语法错误
- 源文件路径错误
- 缺少 LICENSE 文件

### Q: 如何删除已发布的 Pod？

A: CocoaPods 不允许删除已发布的版本。如有严重问题，联系 support@cocoapods.org

### Q: 如何添加截图到 CocoaPods 页面？

A: 在 podspec 中添加：
```ruby
s.screenshots = [
  'https://example.com/screenshot1.png',
  'https://example.com/screenshot2.png'
]
```

---

## 参考链接

- [CocoaPods 官方指南](https://guides.cocoapods.org/)
- [Podspec 语法参考](https://guides.cocoapods.org/syntax/podspec.html)
- [发布 Pod 库](https://guides.cocoapods.org/making/making-a-cocoapod.html)
- [语义化版本](https://semver.org/)
