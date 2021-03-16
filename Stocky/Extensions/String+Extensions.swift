//
//  String+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//

import Foundation


/// String extensions to improve code readibility

extension String {
    /// => returns a string surrounded by a pair of brackets
    func addBrackets() -> String {
        return "(\(self))"
    }
    /// => returns String(self + parameter)
    func prefix(withText text : String) -> String {
        return text + self
    }
    
    /// => returns stirng converted to Double(optional)
    func convertToDouble() -> Double? {
        return Double(self)
    }
    
    
}
