//
//  UIAnimatable.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/18.
//

/**
UIAnimatable Extensions
 
 # Purpose
    - Implements usage for loading animation
 
 # Components
    - func showLoadingAnimation()
    - func dismissLoadingAnimation()
 */

import Foundation
import MBProgressHUD


/// Protocol
protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func dismissLoadingAnimation()
}

extension UIAnimatable {

    /**
     Shows loading animation
     # Code Example
     ```
     .sink { [unowned self] (searchQuery) in
         showLoadingAnimation()
         ...
     }.store(in: &subscribers)
     ```
     */
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    /**
     Hides loading animation
     # Code Example
     ```
     apiService.fetchTimeSeries(key: symbol).sink { [weak self] (completion) in
         self?.dismissLoadingAnimation()
         switch completion{
         case .failure(let error):
             print(error)
         case .finished:
             break
         }
     }
     ```
     */
    func dismissLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

