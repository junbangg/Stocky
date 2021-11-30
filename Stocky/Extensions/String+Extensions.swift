//
//  String+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//
import Foundation

extension String {
    func addParentheses() -> String {
        return "(\(self))"
    }
    
    func convertToDouble() -> Double? {
        return Double(self)
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
}
