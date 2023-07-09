//
//  Extensions.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

extension UITableView {
    func dequeue<T>(_ indexPath: IndexPath, cell: T.Type) -> T where T:UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: cell.self), for: indexPath) as! T
        return cell
    }
    
    func registerCellWithoutNib<T: VoltLinesTableViewCell>(_ instance: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func generateReusableCell<T: VoltLinesTableViewCell>(_ instance: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: instance.reuseIdentifier, for: indexPath) as! T
    }
}

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

extension UIView {
    func addViews(views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
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

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension String {
    func determineCoordinates(_ coordinate: String) -> [String] {
        if coordinate.count > 0 {
            let coordinates = coordinate.components(separatedBy: ",")
            return coordinates
        }else {
            return [String]()
        }
    }
}
