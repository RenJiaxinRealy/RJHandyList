//
//  RJHTableCellProtocol.swift
//  
//
//  Created by A on 2026/3/4.
//  Copyright © 2026 RJHandyListDemo. All rights reserved.
//

import UIKit

// MARK: - 高度计算协议 (用于类方法替代方案)

/// Cell 高度计算协议
public protocol RJHTableCellHeightProtocol: AnyObject {
    static func rjht_heightForCell(with config: RJHTableCellConfigProtocol, reuseIdentifier: String?, indexPath: IndexPath, commonInfo: RJHTCommonInfo) -> CGFloat
}

/// Header/Footer 高度计算协议
public protocol RJHTableHeaderFooterHeightProtocol: AnyObject {
    static func rjht_heightForHeaderFooter(with config: RJHTableHeaderFooterConfigProtocol, reuseIdentifier: String?, section: Int, commonInfo: RJHTCommonInfo) -> CGFloat
}

// MARK: - Cell 配置协议

/// Cell 配置协议
public protocol RJHTableCellConfigProtocol {
    /// cell 的类类型
    var cellClass: UITableViewCell.Type { get }
    /// cell 对应的数据模型
    var model: Any? { get }
    /// cell 的默认高度 (优先级低于 RJHTableCellProtocol 代理方法返回的高度)
    var defaultHeight: CGFloat { get }
    /// cell 的复用标识
    var cellReuseIdentifier: String? { get }
}

// MARK: - Cell 协议

/// Cell 协议
public protocol RJHTableCellProtocol: AnyObject {
    /// 传递数据给 cell (根据配置对象拿到数据更新 UI)
    /// - Parameters:
    ///   - config: 配置对象
    ///   - indexPath: indexPath
    ///   - commonInfo: 公共信息
    func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol, indexPath: IndexPath, commonInfo: RJHTCommonInfo)

    /// 传递数据给 cell (简化版)
    /// - Parameter config: 配置对象
    func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol)

    /// 当前 cell 被选中
    /// - Parameter indexPath: indexPath
    func rjht_didSelected(indexPath: IndexPath)

    /// 刷新 UITableView
    var rjht_reloadTableView: (() -> Void)? { get set }
}

// MARK: - Default Implementations

public extension RJHTableCellProtocol {
    func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol, indexPath: IndexPath, commonInfo: RJHTCommonInfo) {
        // Default implementation does nothing
    }

    func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol) {
        // Default implementation does nothing
    }

    func rjht_didSelected(indexPath: IndexPath) {
        // Default implementation does nothing
    }
}

// MARK: - Cell 配置默认实现类

/// Cell 配置默认实现类
open class RJHTableCellConfigImpl: RJHTableCellConfigProtocol {
    /// cell 的类类型
    open var cellClass: UITableViewCell.Type = UITableViewCell.self
    /// cell 对应的数据模型
    open var model: Any?
    /// cell 的默认高度
    open var defaultHeight: CGFloat = -1
    /// cell 的复用标识
    open var cellReuseIdentifier: String?

    public init(cellClass: UITableViewCell.Type = UITableViewCell.self,
                model: Any? = nil,
                defaultHeight: CGFloat = -1,
                cellReuseIdentifier: String? = nil) {
        self.cellClass = cellClass
        self.model = model
        self.defaultHeight = defaultHeight
        self.cellReuseIdentifier = cellReuseIdentifier
    }
}

// 类型别名，兼容旧代码
public typealias RJHTableCellConfig = RJHTableCellConfigImpl
