//
//  ListTripTableViewCell.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit
import SnapKit

class ListTripTableViewCell : UITableViewCell{
    
        let busNameLabel = UILabel()
        let timeLabel = UILabel()
        let bookButton = UIButton()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
                
            busNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            busNameLabel.textAlignment = .left
            addSubview(busNameLabel)
            busNameLabel.snp.makeConstraints { make in
                make.left.equalTo(safeAreaLayoutGuide).offset(24)
                make.centerY.equalToSuperview()
            }
        
            bookButton.backgroundColor = .clrBlue
            bookButton.setTitleColor(UIColor.white, for: .normal)
            bookButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            bookButton.layer.cornerRadius = self.frame.height/2.2
            bookButton.clipsToBounds = true

            
            addSubview(bookButton)
            bookButton.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(40)
                make.right.equalTo(safeAreaLayoutGuide).offset(-24)
                make.centerY.equalToSuperview()
            }
            timeLabel.font = UIFont.boldSystemFont(ofSize: 18)
            addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(bookButton.snp.left).offset(-16)
            }
            
         
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
