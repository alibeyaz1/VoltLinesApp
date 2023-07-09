//
//  ListLineCell.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation
import UIKit

class ListLineCell: VoltLinesTableViewCell {
    
    let vwLine: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        selectionStyle = .none
        contentView.addViews(views: [
            vwLine
        ])
        
        vwLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1.0)
        }
    }
}

extension ListLineCell {
    static func createCell(_ data: LinesListSection, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath, cell: ListLineCell.self)
        return cell
    }
}



