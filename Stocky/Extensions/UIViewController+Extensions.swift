//
//  UIViewController+Extensions.swift
//  Stocky
//
//  Created by Jun Bang on 2022/01/27.
//

import UIKit.UIViewController

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
