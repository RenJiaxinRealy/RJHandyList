//
//  RJHTableHeaderFooterProtocol.swift
//  
//
//  Created by A on 2026/3/4.
//  Copyright © 2026 RJHandyListDemo. All rights reserved.
//

import UIKit

// MARK: - Header/Footer 配置协议

/// Header/Footer 配置协议
public protocol RJHTableHeaderFooterConfigProtocol {
    /// headerFooter 的类类型
    var headerFooterClass: UIView.Type { get }
    /// headerFooter 对应的数据模型
    var model: Any? { get }
    /// headerFooter 的默认高度
    var defaultHeight: CGFloat { get }
    /// headerFooter 的复用标识
    var headerFooterReuseIdentifier: String? { get }
}

// MARK: - Header/Footer 协议

/// Header/Footer 协议
public protocol RJHTableHeaderFooterProtocol: AnyObject {
    /// 传递数据给 header/footer
    /// - Parameters:
    ///   - config: 配置对象
    ///   - section: section
    ///   - commonInfo: 公共信息
    func rjht_setHeaderFooterConfig(_ config: RJHTableHeaderFooterConfigProtocol, section: Int, commonInfo: RJHTCommonInfo)

    /// 传递数据给 header/footer (简化版)
    /// - Parameter config: 配置对象
    func rjht_setHeaderFooterConfig(_ config: RJHTableHeaderFooterConfigProtocol)

    /// 刷新 tableView
    var rjht_reloadTableView: (() -> Void)? { get set }
}

// MARK: - Default Implementations

public extension RJHTableHeaderFooterProtocol {
    func rjht_setHeaderFooterConfig(_ config: RJHTableHeaderFooterConfigProtocol, section: Int, commonInfo: RJHTCommonInfo) {
        // Default implementation does nothing
    }

    func rjht_setHeaderFooterConfig(_ config: RJHTableHeaderFooterConfigProtocol) {
        // Default implementation does nothing
    }
}

// MARK: - Header/Footer 配置默认实现类

/// Header/Footer 配置默认实现类
open class RJHTableHeaderFooterConfigImpl: RJHTableHeaderFooterConfigProtocol {
    /// headerFooter 的类类型
    open var headerFooterClass: UIView.Type = UIView.self
    /// headerFooter 对应的数据模型
    open var model: Any?
    /// headerFooter 的默认高度
    open var defaultHeight: CGFloat = -1
    /// headerFooter 的复用标识
    open var headerFooterReuseIdentifier: String?

    public init(headerFooterClass: UIView.Type = UIView.self,
                model: Any? = nil,
                defaultHeight: CGFloat = -1,
                headerFooterReuseIdentifier: String? = nil) {
        self.headerFooterClass = headerFooterClass
        self.model = model
        self.defaultHeight = defaultHeight
        self.headerFooterReuseIdentifier = headerFooterReuseIdentifier
    }
}

// 类型别名，兼容旧代码
public typealias RJHTableHeaderFooterConfig = RJHTableHeaderFooterConfigImpl
