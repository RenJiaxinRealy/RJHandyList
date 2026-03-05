//
//  ViewController.swift
//  RJHandyListDemo
//
//  Created by Jin Rookie on 2026/3/4.
//

import UIKit


class CustomTableIMP: RJHandyTableIMP {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 实现额外的代理方法
        print("will display cell at \(indexPath)")
    }
}

class ViewController: UIViewController {
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.orange
        tableView.rjht_tableIMP = RJHandyTableIMP()
        return tableView
    }()

    
    private var dataIndex: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "RJHandyList Demo"

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

    private func setupData() {
        var configs: [RJHTableCellConfig] = []
        for i in 1...20 {
            let cellData = "Cell \(i)"
            let config = RJHTableCellConfig(
                cellClass: DemoTableCell.self,
                model: cellData,
                defaultHeight: 50
            )
            configs.append(config)
        }

        // 添加配置到 rowArray
        
        tableView.rjht_rowArray = configs
        
        tableView.reloadData()
    }

    private func setupTableView() {
        // RJHandyList 会自动设置 delegate 和 dataSource
    }
}

// MARK: - Demo Cell

class DemoTableCell: UITableViewCell, RJHTableCellProtocol,RJHTableCellHeightProtocol {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var rjht_reloadTableView: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.green
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func rjht_setCellConfig(_ config: RJHTableCellConfigProtocol, indexPath: IndexPath, commonInfo: RJHTCommonInfo) {
        if let data = config.model as? String {
            titleLabel.text = data
        }
    }
    static func rjht_heightForCell(with config: any RJHTableCellConfigProtocol, reuseIdentifier: String?, indexPath: IndexPath, commonInfo: RJHTCommonInfo) -> CGFloat {
        return 200
    }
    func rjht_didSelected(indexPath: IndexPath) {
        print("Did select cell at \(indexPath)")
    }
    
}

