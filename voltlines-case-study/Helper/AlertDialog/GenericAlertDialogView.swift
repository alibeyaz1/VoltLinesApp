//
//  GenericAlertDialogView.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

class GenericAlertDialogView: UIView {
    
    let vwContainer = UIView()
    let vwAlert = UIView()
    
    lazy var lblTitle = createLabel(text: "The trip you selected is full.", color: .mainBottomColor, font: UIFont(name: "Helvetica Neue", size: 16.0) ?? UIFont(), textAlign: .left, numberOfLines: 0)
    
    lazy var lblDes = createLabel(text: "Please selected another one.", color: .mainBottomColor, font: UIFont(name: "Helvetica Neue", size: 16.0) ?? UIFont(), textAlign: .left, numberOfLines: 0)
    
    let btnBook: UIButton = {
        let btn = UIButton()
        btn.setTitle("Select a Trip", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12.0)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addViews(views: [vwContainer])
        
        vwContainer.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        vwContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vwContainer.addViews(views: [
            vwAlert
        ])
        
        vwAlert.backgroundColor = .white
        vwAlert.layer.cornerRadius = 8
        vwAlert.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        vwAlert.addViews(views: [
            lblTitle,
            lblDes,
            btnBook
        ])
        
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        lblDes.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        btnBook.snp.makeConstraints { make in
            make.top.equalTo(lblDes.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(42)
            make.bottom.equalTo(-8)
        }
        
        btnBook.addTarget(self, action: #selector(didTappedBtnBook), for: .touchUpInside)
    }
    
    @objc func didTappedBtnBook() {
        self.removeFromSuperview()
    }
    
    public func showAlert() {
        self.attachWindow()
    }
}
