//
// CustomButton.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

protocol CustomButtonDelegate: AnyObject {
    func didTappedCustomButton()
}

import UIKit

class CustomButton: UIView {
    
    let bgView =  UIView()
    

    
    lazy var lblList = createLabel(text: "List Trips", color: .white, font: UIFont(name: "Helvetica Neue", size: 16.0) ?? UIFont(), textAlign: .center, numberOfLines: 0)
    let btnList = UIButton()
    weak var delegate:CustomButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 8
        
        addSubview(bgView)
        bgView.backgroundColor = .clrBlue
        bgView.layer.cornerRadius = 8
       
        
        bgView.snp.makeConstraints { make in
            make.left.equalTo(safeAreaLayoutGuide).offset(24)
            make.right.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        bgView.addSubview(lblList)
        lblList.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        bgView.addSubview(btnList)

        btnList.backgroundColor = .clear
        btnList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btnList.addTarget(self, action: #selector(didTappedCustomButton), for: .touchUpInside)
    }
    
    @objc func didTappedCustomButton() {
        delegate?.didTappedCustomButton()
    }

    func showButton() {
        UIView.animate(withDuration: 1.0, animations: {
            self.bgView.alpha = 1
            self.bgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.bgView.layer.cornerRadius = 8
        })
    }
    
    func hideButton() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.alpha = 0
            self.bgView.transform = CGAffineTransform.identity
            self.bgView.layer.cornerRadius = self.bgView.bounds.height / 2
        })
    }
}
