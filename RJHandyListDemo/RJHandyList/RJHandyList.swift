//
//  RJHandyList.swift
//
//
//  Created by A on 2026/3/4.
//  Copyright © 2026 RJHandyListDemo. All rights reserved.
//

//
//  RJHandyList - Swift 版本
//  
//
//  核心类：
//  1. RJHTableCellProtocol - Cell 协议
//  2. RJHTableHeaderFooterProtocol - Header/Footer 协议
//  3. RJHTableCellConfig - Cell 配置类
//  4. RJHTableHeaderFooterConfig - Header/Footer 配置类
//  5. RJHTableSection - Section 模型
//  6. RJHTCommonInfo - 公共信息对象
//  7. RJHandyTableIMP - 代理实现类
//  8. UITableView+RJHandyList - UITableView 扩展
//

// MARK: - 便捷使用示例

/*

 // ==========================================
 // 1. 简单使用 - 单 Section
 // ==========================================
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
         self.tableView.rjht_rowArray.append(contentsOf: [config1, config2])
         self.tableView.reloadData()
     }
 }

 // ==========================================
 // 2. Cell 实现协议
 // ==========================================
 class TestTableCell: UITableViewCell, RJHTableCellProtocol {
     @IBOutlet weak var titleLabel: UILabel!

     var rjht_reloadTableView: (() -> Void)?

     func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol, indexPath: IndexPath, commonInfo: RJHTCommonInfo) {
         // 根据 config 对象拿到数据做业务处理
         self.titleLabel.text = config.model as? String
     }

     func rjht_didSelected(indexPath: IndexPath) {
         // cell 被选中时的处理
         print("Cell selected at \(indexPath)")
     }
 }

 // ==========================================
 // 3. 自定义高度
 // ==========================================
 class CustomCell: UITableViewCell, RJHTableCellProtocol {
     @IBOutlet weak var contentLabel: UILabel!

     var rjht_reloadTableView: (() -> Void)?

     func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol, indexPath: IndexPath, commonInfo: RJHTCommonInfo) {
         self.contentLabel.text = config.model as? String
     }
 }

 // 实现高度计算（通过扩展遵循高度协议）
 extension CustomCell: RJHTableCellHeightProtocol {
     static func rjht_heightForCell(with config: RJHTableCellConfigProtocol, reuseIdentifier: String?, indexPath: IndexPath, commonInfo: RJHTCommonInfo) -> CGFloat {
         // 根据内容计算高度
         let text = config.model as? String ?? ""
         let height = text.boundingRect(
             with: CGSize(width: UIScreen.main.bounds.width - 40, height: .greatestFiniteMagnitude),
             options: .usesLineFragmentOrigin,
             attributes: [.font: UIFont.systemFont(ofSize: 16)],
             context: nil
         ).height
         return height + 20 // 上下 padding
     }
 }

 // ==========================================
 // 4. 多 Section
 // ==========================================
 func setupSections() {
     let section1 = RJHTableSection()
     section1.header = RJHTableHeaderFooterConfig(headerFooterClass: TestHeaderView.self, defaultHeight: 40)
     section1.rowArray = [RJHTableCellConfig(cellClass: TestTableCell.self, model: "Section1-Cell1")]

     let section2 = RJHTableSection()
     section2.footer = RJHTableHeaderFooterConfig(headerFooterClass: UIView.self, defaultHeight: 20)
     section2.rowArray = [RJHTableCellConfig(cellClass: TestTableCell.self, model: "Section2-Cell1")]

     self.tableView.rjht_sectionArray = [section1, section2]
     self.tableView.reloadData()
 }

 // ==========================================
 // 5. 自定义 Config (用于 MVVM 架构)
 // ==========================================
 class CustomCellConfig: RJHTableCellConfigImpl {
     var title: String
     var image: UIImage?
     weak var delegate: CustomCellDelegate?

     init(title: String, image: UIImage?, cellClass: UITableViewCell.Type = CustomTableViewCell.self) {
         self.title = title
         self.image = image
         super.init(cellClass: cellClass, model: nil)
     }
 }

 protocol CustomCellDelegate: AnyObject {
     func didTapButton(at indexPath: IndexPath)
 }

 // ==========================================
 // 6. 自定义 IMP 实现更多代理方法
 // ==========================================
 class CustomTableIMP: RJHandyTableIMP {
     override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         // 实现额外的代理方法
         print("will display cell at \(indexPath)")
     }
 }

 // 使用自定义 IMP
 // self.tableView.rjht_tableIMP = CustomTableIMP()

 // ==========================================
 // 7. Header/Footer 实现示例
 // ==========================================
 class TestHeaderView: UIView, RJHTableHeaderFooterProtocol {
     private let label: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.boldSystemFont(ofSize: 18)
         return lbl
     }()

     var rjht_reloadTableView: (() -> Void)?

     override init(frame: CGRect) {
         super.init(frame: frame)
         setupUI()
     }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setupUI()
     }

     private func setupUI() {
         addSubview(label)
         label.snp.makeConstraints { make in
             make.edges.equalToSuperview()
         }
     }

     func rjht_setHeaderFooterConfig(_ config: RJHTableHeaderFooterConfigProtocol, section: Int, commonInfo: RJHTCommonInfo) {
         label.text = "Section \(section)"
     }
 }

 // 实现 Header 高度计算
 extension TestHeaderView: RJHTableHeaderFooterHeightProtocol {
     static func rjht_heightForHeaderFooter(with config: RJHTableHeaderFooterConfigProtocol, reuseIdentifier: String?, section: Int, commonInfo: RJHTCommonInfo) -> CGFloat {
         return config.defaultHeight >= 0 ? config.defaultHeight : 40
     }
 }

 */
