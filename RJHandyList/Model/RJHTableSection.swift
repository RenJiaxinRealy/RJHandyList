//
//  RJHTableSection.swift
//  
//
//  Created by A on 2026/3/4.
//  Copyright © 2026 RJHandyListDemo. All rights reserved.
//

import UIKit

/// Section 模型
open class RJHTableSection {
    /// UITableView 的 header 配置
    open var header: RJHTableHeaderFooterConfigProtocol?
    /// UITableView 的 footer 配置
    open var footer: RJHTableHeaderFooterConfigProtocol?
    /// UITableView 的 cell 配置数组
    open var rowArray: [RJHTableCellConfigProtocol] = []

    public init(header: RJHTableHeaderFooterConfigProtocol? = nil,
                footer: RJHTableHeaderFooterConfigProtocol? = nil,
                rowArray: [RJHTableCellConfigProtocol] = []) {
        self.header = header
        self.footer = footer
        self.rowArray = rowArray
    }
}
