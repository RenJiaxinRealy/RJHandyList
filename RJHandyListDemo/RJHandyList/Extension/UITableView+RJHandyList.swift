//
//  UITableView+RJHandyList.swift
//  
//
//  Created by A on 2026/3/4.
//  Copyright © 2026 RJHandyListDemo. All rights reserved.
//

import UIKit

// MARK: - Associated Objects Keys

private var rjht_sectionArrayKey: UInt8 = 0
private var rjht_tableIMPKey: UInt8 = 0

// MARK: - 包装类 (解决值类型问题)

/// Section 数组包装类 - 用于关联对象存储 (解决 Swift Array 值类型问题)
private class RJHTableSectionArrayWrapper {
    var sections: [RJHTableSection] = []

    init() {}
}

// MARK: - UITableView Extension

public extension UITableView {

    // MARK: - 语法糖属性 (单 Section 便捷访问)

    /// 一个 section，cell 配置数组 (单 section 便捷访问)
    var rjht_rowArray: [RJHTableCellConfigProtocol] {
        get {
            return self.rjht_firstSection.rowArray
        }
        set {
            self.rjht_firstSection.rowArray = newValue
        }
    }

    /// 一个 section，header 配置 (单 section 便捷访问)
    var rjht_header: RJHTableHeaderFooterConfigProtocol? {
        get {
            return self.rjht_firstSection.header
        }
        set {
            self.rjht_firstSection.header = newValue
        }
    }

    /// 一个 section，footer 配置 (单 section 便捷访问)
    var rjht_footer: RJHTableHeaderFooterConfigProtocol? {
        get {
            return self.rjht_firstSection.footer
        }
        set {
            self.rjht_firstSection.footer = newValue
        }
    }

    // MARK: - 核心属性

    /// 多个 section
    var rjht_sectionArray: [RJHTableSection] {
        get {
            if let wrapper = objc_getAssociatedObject(self, &rjht_sectionArrayKey) as? RJHTableSectionArrayWrapper {
                return wrapper.sections
            }
            let wrapper = RJHTableSectionArrayWrapper()
            objc_setAssociatedObject(self, &rjht_sectionArrayKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return wrapper.sections
        }
        set {
            if let wrapper = objc_getAssociatedObject(self, &rjht_sectionArrayKey) as? RJHTableSectionArrayWrapper {
                wrapper.sections = newValue
            } else {
                let wrapper = RJHTableSectionArrayWrapper()
                wrapper.sections = newValue
                objc_setAssociatedObject(self, &rjht_sectionArrayKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            // 同步到 rjht_tableIMP（如果已经设置）
            if let imp = objc_getAssociatedObject(self, &rjht_tableIMPKey) as? RJHandyTableIMP {
                imp.sectionArray = newValue
            }
        }
    }

    /// 代理实现者，将数组内容转换为列表代理方法的核心类
    /// （需要实现额外的 UITableView 代理方法，可以自定义继承 RJHandyTableIMP 的类并赋值该属性）
    var rjht_tableIMP: RJHandyTableIMP {
        get {
            if let imp = objc_getAssociatedObject(self, &rjht_tableIMPKey) as? RJHandyTableIMP {
                return imp
            }
            let imp = RJHandyTableIMP()
            imp.sectionArray = self.rjht_sectionArray
            imp.tableView = self
            self.delegate = imp
            self.dataSource = imp
            objc_setAssociatedObject(self, &rjht_tableIMPKey, imp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return imp
        }
        set {
            newValue.sectionArray = self.rjht_sectionArray
            newValue.tableView = self
            self.delegate = newValue
            self.dataSource = newValue
            objc_setAssociatedObject(self, &rjht_tableIMPKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 公共信息对象，将会下发到 Cell/Header/Footer
    var rjht_commonInfo: RJHTCommonInfo {
        get {
            return self.rjht_tableIMP.commonInfo
        }
        set {
            self.rjht_tableIMP.commonInfo = newValue
        }
    }

    // MARK: - 私有方法

    /// 获取第一个 section，如果不存在则创建
    internal var rjht_firstSection: RJHTableSection {
        get {
            if self.rjht_sectionArray.count > 0 {
                return self.rjht_sectionArray[0]
            }
            let section = RJHTableSection()
            var array = self.rjht_sectionArray
            array.append(section)
            self.rjht_sectionArray = array
            return section
        }
    }
}
