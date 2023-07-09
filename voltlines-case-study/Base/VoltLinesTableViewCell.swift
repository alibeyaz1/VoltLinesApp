//
//  VoltLinesTableViewCell.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

class VoltLinesTableViewCell: UITableViewCell {

    class var reuseIdentifier: String {
        return "\(self)"
    }

    class var nibInstance: UINib {
        return .init(nibName: "\(self)", bundle: nil)
    }

    class var defaultHeight: CGFloat {
        return UITableView.automaticDimension
    }
}

protocol ConfigurableCell where Self: VoltLinesTableViewCell {
    associatedtype DataType
    func configure(data: DataType)
}

class MTGenericDataSource<T, Cell>: NSObject, UITableViewDelegate, UITableViewDataSource
where Cell: ConfigurableCell, T == Cell.DataType {

    var items: [T] = []

    var didSelectListener: ((T, IndexPath) -> Void)?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(Cell.self, indexPath: indexPath)
        cell.configure(data: items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectListener?(items[indexPath.row], indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
