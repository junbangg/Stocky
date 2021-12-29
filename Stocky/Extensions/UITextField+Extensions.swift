//
//  UITextField+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/04.
//

/**
 # Reference
    https://tdcian.tistory.com/157
 */
import UIKit

extension UITextField {
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar: UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolBar.barStyle = .default
        let flexBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard ))
        let items = [flexBarButtonItem, doneBarButtonItem]
        
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    
    @objc
    private func dismissKeyboard() {
        resignFirstResponder()
    }
}
