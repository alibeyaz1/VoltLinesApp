//
//  VoltLinesTableViewCell.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

// Define a custom UITableViewCell subclass called VoltLinesTableViewCell
class VoltLinesTableViewCell: UITableViewCell {

    // Return a unique string identifier for reusing cells
    class var reuseIdentifier: String {
        return "\(self)"
    }

    // Return a UINib instance for loading the cell from a nib file
    class var nibInstance: UINib {
        return .init(nibName: "\(self)", bundle: nil)
    }

    // Return the default height for the cell
    class var defaultHeight: CGFloat {
        return UITableView.automaticDimension
    }
}

// Define a protocol called ConfigurableCell which can be adopted by VoltLinesTableViewCell
protocol ConfigurableCell where Self: VoltLinesTableViewCell {
    associatedtype DataType
    func configure(data: DataType)
}

// Define a generic data source class for UITableView
class MTGenericDataSource<T, Cell>: NSObject, UITableViewDelegate, UITableViewDataSource
where Cell: ConfigurableCell, T == Cell.DataType {

    // Array to hold the data items
    var items: [T] = []

    // Closure to be called when a cell is selected
    var didSelectListener: ((T, IndexPath) -> Void)?

    // Return the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // Create and configure a cell for a given index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(Cell.self, indexPath: indexPath)
        cell.configure(data: items[indexPath.row])
        return cell
    }

    // Handle the selection of a cell at a given index path
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectListener?(items[indexPath.row], indexPath)
    }

    // Return the height for a cell at a given index path
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
