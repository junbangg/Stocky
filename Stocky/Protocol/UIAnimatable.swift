//
//  UIAnimatable.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/18.
//
import Foundation
import MBProgressHUD
/// Protocol
protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func dismissLoadingAnimation()
}

extension UIAnimatable {
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func dismissLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

