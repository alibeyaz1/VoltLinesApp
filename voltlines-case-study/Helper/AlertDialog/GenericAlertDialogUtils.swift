//
//  GenericAlertDialogUtils.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

class GenericAlertDialogUtils {
    
    static let shared = GenericAlertDialogUtils()
    let vwAlert = GenericAlertDialogView()
    
    func showAlert() {
        DispatchQueue.main.async {
            self.vwAlert.showAlert()
        }
    }
}
