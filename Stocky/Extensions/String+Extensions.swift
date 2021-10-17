//
//  String+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//

/**
 String Extensions
 # Purpose
    - Code Readibility
    - Reusability
 
 # Functions
    - func addParentheses() -> String
    - func prefix() -> String
    - func convertToDouble(text: String) -> Double?
 */

import Foundation

extension String {
    /**
    Function that wraps a text with parentheses
     - Returns: String
     */
    func addParentheses() -> String {
        return "(\(self))"
    }
    /**
       Function that converts String to Double format
        - Returns: Double?
     */
    func convertToDouble() -> Double? {
        return Double(self)
    }
    /**
    Function that adds text to the beginning of a String Object
      - Parameter text: [text to add to beginning of String]
      - Returns: String(text+self)
      - Code Example
        ```
        let amount = 500
        let newText = amount.prefix(withText: "$")
        ```
     */
    func prefix(withText text: String) -> String {
        return text + self
    }
}
