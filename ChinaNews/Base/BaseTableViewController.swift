//
//  BaseTableViewController.swift
//  Swifter
//
//  Created by 汤军 on 2019/4/29.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit
import SnapKit

class BaseTableViewController: BaseViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    open func numberOfSections() -> Int {
        return 1
    }

    open func numberOfRowsInSection(_ section: Int) -> Int {
        return 0
    }

    open func cellForRowAt(_ indexPath: IndexPath) -> UITableViewCell? {
        return UITableViewCell()
    }
}

extension BaseTableViewController {
    open func registCellFromNib(_ nibName: String) {
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    open func registCell(_ cellClass: AnyClass, reuseIdentifier: String) {
        tableView.register(cellClass.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension BaseTableViewController: UITableViewDelegate { }

extension BaseTableViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection(section)
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cellForRowAt(indexPath) else {
            fatalError("cell could not be nil")
        }
        return cell
    }
}
