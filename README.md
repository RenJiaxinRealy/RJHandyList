# RJHandyList

[![Version](https://img.shields.io/cocoapods/v/RJHandyList.svg?style=flat)](https://cocoapods.org/pods/RJHandyList)
[![Platform](https://img.shields.io/cocoapods/p/RJHandyList.svg?style=flat)](https://cocoapods.org/pods/RJHandyList)

RJHandyList 是一个 Swift 编写的 UITableView 工具库，让列表开发更加简单优雅。支持动态列表、模块化开发、MVVM 架构。

## 功能特点

- ✅ 简洁的 API 设计
- ✅ 支持单 Section 和多 Section
- ✅ 支持 Cell 高度自动计算
- ✅ 支持 Header/Footer
- ✅ 支持 Xib 和纯代码创建 Cell
- ✅ 遵循 MVVM 架构
- ✅ 支持自定义 Config 和 IMP

## 安装

### CocoaPods

在 Podfile 中添加：

```ruby
pod 'RJHandyList'
```

然后运行：

```bash
pod install
```

### 手动安装

将 `RJHandyList` 文件夹中的所有文件拖入你的项目即可。

## 快速开始

### 1. 基础使用（单 Section）

```swift
class TestTableController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 配置数据
        let config1 = RJHTableCellConfig(
            cellClass: TestTableCell.self,
            model: "数据模型 1",
            defaultHeight: 50
        )
        let config2 = RJHTableCellConfig(
            cellClass: TestTableCell.self,
            model: "数据模型 2",
            defaultHeight: 50
        )

        // 赋值并刷新
        tableView.rjht_rowArray = [config1, config2]
        tableView.reloadData()
    }
}
```

### 2. 实现 Cell 协议

```swift
class TestTableCell: UITableViewCell, RJHTableCellProtocol {
    @IBOutlet weak var titleLabel: UILabel!

    var rjht_reloadTableView: (() -> Void)?

    func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol,
                            indexPath: IndexPath,
                            commonInfo: RJHTCommonInfo) {
        // 根据 config 对象拿到数据做业务处理
        titleLabel.text = config.model as? String
    }

    func rjht_didSelected(indexPath: IndexPath) {
        // cell 被选中时的处理
        print("Cell selected at \(indexPath)")
    }
}
```

### 3. 自定义 Cell 高度

```swift
extension TestTableCell: RJHTableCellHeightProtocol {
    static func rjht_heightForCell(with config: RJHTableCellConfigProtocol,
                                   reuseIdentifier: String?,
                                   indexPath: IndexPath,
                                   commonInfo: RJHTCommonInfo) -> CGFloat {
        // 根据内容计算高度
        let text = config.model as? String ?? ""
        let height = text.boundingRect(
            with: CGSize(width: UIScreen.main.bounds.width - 40,
                        height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        ).height
        return height + 20 // 上下 padding
    }
}
```

### 4. 多 Section 支持

```swift
func setupSections() {
    let section1 = RJHTableSection()
    section1.header = RJHTableHeaderFooterConfig(
        headerFooterClass: TestHeaderView.self,
        defaultHeight: 40
    )
    section1.rowArray = [
        RJHTableCellConfig(
            cellClass: TestTableCell.self,
            model: "Section1-Cell1"
        )
    ]

    let section2 = RJHTableSection()
    section2.footer = RJHTableHeaderFooterConfig(
        headerFooterClass: UIView.self,
        defaultHeight: 20
    )
    section2.rowArray = [
        RJHTableCellConfig(
            cellClass: TestTableCell.self,
            model: "Section2-Cell1"
        )
    ]

    tableView.rjht_sectionArray = [section1, section2]
    tableView.reloadData()
}
```

### 5. 自定义 Config（MVVM 架构）

```swift
class CustomCellConfig: RJHTableCellConfigImpl {
    var title: String
    var image: UIImage?
    weak var delegate: CustomCellDelegate?

    init(title: String, image: UIImage?,
         cellClass: UITableViewCell.Type = CustomTableViewCell.self) {
        self.title = title
        self.image = image
        super.init(cellClass: cellClass, model: nil)
    }
}

protocol CustomCellDelegate: AnyObject {
    func didTapButton(at indexPath: IndexPath)
}
```

### 6. 自定义 IMP（实现更多代理方法）

```swift
class CustomTableIMP: RJHandyTableIMP {
    override func tableView(_ tableView: UITableView,
                           willDisplay cell: UITableViewCell,
                           forRowAt indexPath: IndexPath) {
        // 实现额外的代理方法
        print("will display cell at \(indexPath)")
    }
}

// 使用自定义 IMP
tableView.rjht_tableIMP = CustomTableIMP()
```

## 核心类说明

| 类/协议 | 说明 |
|--------|------|
| `RJHTableCellProtocol` | Cell 必须遵循的协议 |
| `RJHTableHeaderFooterProtocol` | Header/Footer 必须遵循的协议 |
| `RJHTableCellConfigProtocol` | Cell 配置协议 |
| `RJHTableHeaderFooterConfigProtocol` | Header/Footer 配置协议 |
| `RJHTableCellConfigImpl` | Cell 配置默认实现类 |
| `RJHTableHeaderFooterConfigImpl` | Header/Footer 配置默认实现类 |
| `RJHTableSection` | Section 模型 |
| `RJHTCommonInfo` | 公共信息对象 |
| `RJHandyTableIMP` | 代理实现类 |
| `RJHTableCellHeightProtocol` | Cell 高度计算协议 |
| `RJHTableHeaderFooterHeightProtocol` | Header/Footer 高度计算协议 |

## 便捷属性

| 属性 | 说明 |
|------|------|
| `tableView.rjht_rowArray` | 单 Section 的 Cell 配置数组 |
| `tableView.rjht_sectionArray` | 多 Section 的配置数组 |
| `tableView.rjht_header` | 单 Section 的 Header 配置 |
| `tableView.rjht_footer` | 单 Section 的 Footer 配置 |
| `tableView.rjht_tableIMP` | 代理实现类 |
| `tableView.rjht_commonInfo` | 公共信息对象 |

## 要求

- iOS 12.0+
- Swift 5.0+

## 示例

查看项目中的 `RJHandyListDemo` 获取完整示例代码。

## 作者

RenJiaxinRealy

tag 0.1.0

## License

RJHandyList is available under the MIT license. See the LICENSE file for more info.
