//
//  LinesListSpacingCell.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

class LinesListSpacingCell: VoltLinesTableViewCell {
    
    let spacing = UIView()
    
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
        contentView.addSubview(spacing)
        selectionStyle = .none
        
        spacing.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func setData(_ height: Int) {
        spacing.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

extension LinesListSpacingCell {
    static func createCell(_ data: LinesListSection, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath, cell: LinesListSpacingCell.self)
        
        if let spacing = data.items?[indexPath.row] as? Int {
            cell.setData(spacing)
        }
        return cell
    }
}

