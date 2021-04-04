//
//  String+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//

import Foundation

/**
 String Extensions
 # Purpose
    - Code Readibility
    - Reusability
 
 # Functions
    - func addBrackets() -> String
    - func prefix() -> String
    - func convertToDouble(text: String) -> Double?
 */

extension String {
    /**
    Function that wraps a text with parentheses
     - Returns: String
     */
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    /**
    Function that adds text to the beginning of a String Object
      - Parameter text: [text to add to beginning of String]
      - Returns: String(text+self)
      - Code
        ```
        let amount = 500
        let newText = amount.prefix(withText: "$")
        ```
     */
    func prefix(withText text : String) -> String {
        return text + self
    }
    /**
       Function that converts String to Double format
        - Returns: Double?
     */
    func convertToDouble() -> Double? {
        return Double(self)
    }
    
    
}
