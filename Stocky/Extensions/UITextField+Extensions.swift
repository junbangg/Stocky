//
//  UITextField+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/04.
//

import UIKit

/// UITextField extensions to add simple functionality to UIView

extension UITextField {
    
    /// => adds a "Done" button to keypad
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar : UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolBar.barStyle = .default
        let flexBarButtonItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem : UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard ))
        let items = [flexBarButtonItem, doneBarButtonItem]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    
    /// => private function to improve readibility
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}
