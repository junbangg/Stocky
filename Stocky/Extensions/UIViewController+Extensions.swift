//
//  UIViewController+Extensions.swift
//  Stocky
//
//  Created by Jun Bang on 2022/01/27.
//

import UIKit.UIViewController

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    var loadingIndicator: UIActivityIndicatorView {
//        let loadingIndicator = UIActivityIndicatorView(style: .large)
//        loadingIndicator.isHidden = false
//
//        self.view.addSubview(loadingIndicator)
//        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
//        loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        
//        return loadingIndicator
//    }
}
