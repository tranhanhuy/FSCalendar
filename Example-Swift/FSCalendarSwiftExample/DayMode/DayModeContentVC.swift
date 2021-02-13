//
//  DayModeContentVC.swift
//  FSCalendarSwiftExample
//
//  Created by Tran Han Huy on 2/13/21.
//  Copyright © 2021 wenchao. All rights reserved.
//

import Foundation

final class DayModeContentVC: UIViewController {
    
    private var tableView = UITableView()
    var date: Date?
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        view.backgroundColor = .blue
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: -95, left: 0, bottom: 900, right: 0)
        view.addSubview(tableView)
        if #available(iOS 9.0, *) {
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK:- UITableViewDataSource
extension DayModeContentVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        cell.imageView?.image = UIImage(named: "icon_cat")
        cell.textLabel?.text = "\(indexPath.row + 1)/ Lorem ipsum dolor sit er elit lamet"
        if let date = date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        return cell
    }
}

// MARK:- UITableViewDelegate
extension DayModeContentVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let date = date {
            let label = UILabel()
            label.text = "    📅  \(dateFormatter.string(from: date))"
            label.textColor = .white
            label.backgroundColor = .lightGray
            return label
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}
