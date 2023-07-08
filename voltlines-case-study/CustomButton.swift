//
//  CustomButton.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

class CustomButton: UIButton {
        private let title: String?
        
        init(title: String?) {
            self.title = title
            super.init(frame: .zero)
            self.setupUI()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        
        func setupUI() {
            self.setTitle(self.title, for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.backgroundColor = .clrBlue
            self.layer.cornerRadius = 16
        }
        
        
    }

