//
//  UIAnimatable.swift
//  Stocky
//
//  Created by Jun suk Bang on 2022/02/18.
//
import UIKit

protocol LoadingAnimatable where Self: UIViewController {
    func showLoadingAnimation(with loadingIndicator: UIActivityIndicatorView)
    func dismissLoadingAnimation(of loadingIndicator: UIActivityIndicatorView)
}

extension LoadingAnimatable {
    func showLoadingAnimation(with loadingIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            loadingIndicator.startAnimating()
        }
    }
    
    func dismissLoadingAnimation(of loadingIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            loadingIndicator.stopAnimating()
        }
    }
}

