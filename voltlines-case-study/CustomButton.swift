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
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            self.backgroundColor = .clrBlue
            self.layer.cornerRadius = 30
        }
    
    func showButton() {
        UIView.animate(withDuration: 1.5, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.layer.cornerRadius = 8
        })
    }
    
    func hideButton() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform.identity
            self.layer.cornerRadius = self.bounds.height / 2
        })
    }
        
        
    }

