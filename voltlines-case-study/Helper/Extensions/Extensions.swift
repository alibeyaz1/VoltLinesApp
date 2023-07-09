//
//  Extensions.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

// Extension added to UITableView
extension UITableView {
    
    // Function that dequeues the cell at the specified index
    func dequeue<T>(_ indexPath: IndexPath, cell: T.Type) -> T where T: UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: cell.self), for: indexPath) as! T
        return cell
    }
    
    // Function that registers a cell without nib
    func registerCellWithoutNib<T: VoltLinesTableViewCell>(_ instance: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    // Function that generates a reusable cell
    func generateReusableCell<T: VoltLinesTableViewCell>(_ instance: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: instance.reuseIdentifier, for: indexPath) as! T
    }
}

// Function that creates a label
func createLabel(text: String? = nil, color: UIColor, font: UIFont, textAlign: NSTextAlignment, numberOfLines: Int = 0) -> UILabel {
    let label: UILabel = {
        let l = UILabel()
        l.text = text ?? ""
        l.textColor = color
        l.font = font
        l.textAlignment = textAlign
        l.numberOfLines = numberOfLines
        l.backgroundColor = .clear
        return l
    }()
    return label
}

// Extension added to UIView
extension UIView {
    
    // Function that adds multiple views to self
    func addViews(views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    // Function that attaches the view to a window
    func attachWindow() {
        if let window = WindowHelper.getWindow() {
            DispatchQueue.main.async {
                window.addSubview(self)
                self.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
}

// Extension added to LosslessStringConvertible
extension LosslessStringConvertible {
    
    // Computed property that converts LosslessStringConvertible to String
    var string: String { .init(self) }
}

// Extension added to String
extension String {
    
    // Function that determines coordinates from a coordinate string
    func determineCoordinates(_ coordinate: String) -> [String] {
        if coordinate.count > 0 {
            let coordinates = coordinate.components(separatedBy: ",")
            return coordinates
        } else {
            return [String]()
        }
    }
}
