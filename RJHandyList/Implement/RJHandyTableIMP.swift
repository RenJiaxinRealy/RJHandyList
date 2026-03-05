//
//  RJHandyTableIMP.swift
//  
//
//  Created by A on 2026/3/4.
//  Copyright © 2026 RJHandyListDemo. All rights reserved.
//

import UIKit

/// 代理实现类，可以直接抽出来作为 UITableView 的 delegate 和 dataSource
/// 若想实现更多的代理方法，继承于该类在子类中拓展就行了
open class RJHandyTableIMP: NSObject {
    /// 数据源
    open var sectionArray: [RJHTableSection] = []
    /// 公共信息对象，将会下发到 Cell/Header/Footer
    open var commonInfo: RJHTCommonInfo = RJHTCommonInfo()

    /// 弱引用的 TableView，用于 reloadData 等操作
    open weak var tableView: UITableView?
}

// MARK: - UITableViewDataSource

extension RJHandyTableIMP: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionArray.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionArray[section].rowArray.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let htSection = self.sectionArray[indexPath.section]
        let config = htSection.rowArray[indexPath.row]

        let cellClass = validClass(for: config)
        let identifier = reuseIdentifier(for: config)

        // 注册 Cell - 直接注册，重复注册无害
        // 检查是否有 nib 文件
        let nibName = String(describing: cellClass)
        let nibPath = Bundle.main.path(forResource: nibName, ofType: "nib")
        if nibPath != nil {
            tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier)
        } else {
            tableView.register(cellClass, forCellReuseIdentifier: identifier)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        // 传递数据 - 使用 weak 避免循环引用
        if var cellProtocol = cell as? RJHTableCellProtocol {
            // 设置 reloadData 回调 - 使用 [weak cell] 避免循环引用
            // 捕获当前 indexPath 的 section 和 row，避免闭包执行时使用过时的 indexPath
            let section = indexPath.section
            let row = indexPath.row
            cellProtocol.rjht_reloadTableView = { [weak tableView, weak cell] in
                guard let tableView = tableView, let cell = cell else { return }
                // 动态获取 cell 当前的 indexPath，确保刷新正确的行
                if let currentIndexPath = tableView.indexPath(for: cell) {
                    tableView.reloadRows(at: [currentIndexPath], with: .none)
                }
            }

            // 调用完整版本的配置方法（如果开发者实现了该方法）
            // 注意：协议扩展中该方法是空实现，所以如果开发者没有实现也不会有副作用
            cellProtocol.rjht_setCellConfig(config, indexPath: indexPath, commonInfo: self.commonInfo)
            // 调用简化版本的配置方法（如果开发者实现了该方法）
            // 这样设计是为了兼容只想实现简化版本的开发者
            cellProtocol.rjht_setCellConfig(config)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension RJHandyTableIMP: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let htSection = self.sectionArray[indexPath.section]
        let config = htSection.rowArray[indexPath.row]

        let cellClass = validClass(for: config)
        let reuseIdentifier = self.reuseIdentifier(for: config)

        // 使用类型检查方式调用静态方法（替代可选链）
        let height = getHeightForCell(
            cellClass: cellClass,
            config: config,
            reuseIdentifier: reuseIdentifier,
            indexPath: indexPath
        )

        if height >= 0 {
            return height
        }

        // 使用配置的默认高度
        if config.defaultHeight >= 0 {
            return config.defaultHeight
        }

        return UITableView.automaticDimension
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let htSection = self.sectionArray[section]
        let config = htSection.header
        return heightForHeaderFooter(tableView: tableView, config: config, section: section)
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let htSection = self.sectionArray[section]
        let config = htSection.footer
        return heightForHeaderFooter(tableView: tableView, config: config, section: section)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let htSection = self.sectionArray[section]
        let config = htSection.header
        return viewForHeaderFooter(tableView: tableView, config: config, section: section)
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let htSection = self.sectionArray[section]
        let config = htSection.footer
        return viewForHeaderFooter(tableView: tableView, config: config, section: section)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RJHTableCellProtocol else { return }
        cell.rjht_didSelected(indexPath: indexPath)
    }
}

// MARK: - 高度计算方法

extension RJHandyTableIMP {
    /// 获取 Cell 高度
    open func getHeightForCell(cellClass: UITableViewCell.Type, config: RJHTableCellConfigProtocol, reuseIdentifier: String, indexPath: IndexPath) -> CGFloat {
        // 通过类型转换检查是否实现了高度协议
        // 方式 1: 检查是否遵循 RJHTableCellHeightProtocol
        if let heightProtocol = cellClass.self as? RJHTableCellHeightProtocol.Type {
            // 优先调用完整版本
            let height = heightProtocol.rjht_heightForCell(with: config, reuseIdentifier: reuseIdentifier, indexPath: indexPath, commonInfo: self.commonInfo)
            if height >= 0 {
                return height
            }
        }

        // 方式 2: 检查是否有静态方法实现 (通过类型检查)
        // 由于 Swift 限制，这里使用反射方式不太方便，改用配置优先策略

        return -1 // 返回 -1 表示未找到
    }

    /// 获取 Header/Footer 高度
    open func getHeightForHeaderFooter(headerFooterClass: UIView.Type, config: RJHTableHeaderFooterConfigProtocol, reuseIdentifier: String, section: Int) -> CGFloat {
        // 通过类型转换检查是否实现了高度协议
        if let heightProtocol = headerFooterClass.self as? RJHTableHeaderFooterHeightProtocol.Type {
            let height = heightProtocol.rjht_heightForHeaderFooter(with: config, reuseIdentifier: reuseIdentifier, section: section, commonInfo: self.commonInfo)
            if height >= 0 {
                return height
            }
        }

        return -1
    }
}

// MARK: - Private Methods

extension RJHandyTableIMP {
    /// 获取有效的 Cell 类
    func validClass(for config: RJHTableCellConfigProtocol) -> UITableViewCell.Type {
        return config.cellClass
    }

    /// 获取有效的 Header/Footer 类
    func validClass(for config: RJHTableHeaderFooterConfigProtocol?) -> UIView.Type {
        return config?.headerFooterClass ?? UIView.self
    }

    /// 获取 Cell 的复用标识
    func reuseIdentifier(for config: RJHTableCellConfigProtocol) -> String {
        if let identifier = config.cellReuseIdentifier {
            return identifier
        }
        return String(describing: validClass(for: config))
    }

    /// 获取 Header/Footer 的复用标识
    func reuseIdentifier(for config: RJHTableHeaderFooterConfigProtocol?) -> String {
        guard let config = config else { return "" }
        if let identifier = config.headerFooterReuseIdentifier {
            return identifier
        }
        return String(describing: validClass(for: config))
    }

    /// 获取 Header/Footer 的高度
    func heightForHeaderFooter(tableView: UITableView, config: RJHTableHeaderFooterConfigProtocol?, section: Int) -> CGFloat {
        guard let config = config else {
            return tableView.style == .plain ? 0 : CGFloat.leastNormalMagnitude
        }

        let headerFooterClass = validClass(for: config)
        let reuseIdentifier = self.reuseIdentifier(for: config)

        // 获取高度
        let height = getHeightForHeaderFooter(
            headerFooterClass: headerFooterClass,
            config: config,
            reuseIdentifier: reuseIdentifier,
            section: section
        )

        if height >= 0 {
            return height
        }

        // 使用配置的默认高度
        if config.defaultHeight >= 0 {
            return config.defaultHeight
        }

        return tableView.style == .plain ? 0 : CGFloat.leastNormalMagnitude
    }

    /// 获取 Header/Footer 的视图
    func viewForHeaderFooter(tableView: UITableView, config: RJHTableHeaderFooterConfigProtocol?, section: Int) -> UIView? {
        guard let config = config else { return nil }

        let headerFooterClass = validClass(for: config)
        let identifier = reuseIdentifier(for: config)

        var view: UIView? = nil

        // 检查是否是 UITableViewHeaderFooterView 类型
        if headerFooterClass is UITableViewHeaderFooterView.Type {
            view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            if view == nil {
                // 检查是否有 nib 文件
                let nibName = String(describing: headerFooterClass)
                let nibPath = Bundle.main.path(forResource: nibName, ofType: "nib")
                if nibPath != nil {
                    tableView.register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
                } else {
                    tableView.register(headerFooterClass, forHeaderFooterViewReuseIdentifier: identifier)
                }
                view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            }
        } else {
            view = headerFooterClass.init()
        }

        // 传递数据 - 使用 weak 避免循环引用
        if var headerFooterProtocol = view as? RJHTableHeaderFooterProtocol {
            // 设置 reloadData 回调
            headerFooterProtocol.rjht_reloadTableView = { [weak tableView] in
                tableView?.reloadData()
            }

            // 调用完整版本的配置方法（如果开发者实现了该方法）
            headerFooterProtocol.rjht_setHeaderFooterConfig(config, section: section, commonInfo: self.commonInfo)
            // 调用简化版本的配置方法（如果开发者实现了该方法）
            headerFooterProtocol.rjht_setHeaderFooterConfig(config)
        }

        return view
    }
}
