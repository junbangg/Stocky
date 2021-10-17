//
//  Double+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//

/**
 Double Extensions
 
 # Purpose
    - Code Readibility
    - Reusability
 
 # Components
    - var twoDecimalFormatString : String
    - var currencyFormatter : String
    - var percentageFormat : String
    - func toCurrencyFormat(hasDollarSymbol: Bool, hasDecimalPlaces: Bool ) -> String
 */

import Foundation

extension Double {
    /**
     Slices String decimal to the second place
        => "10.22"
     # Usage
     Used as default values for Date Strings
     */
    private var twoDecimalFormatString: String {
        return String(format: "%.2f", self)
    }
    /**
     Converts String to a Currency Format String
        => "$2300"
     # Usage
     Used to easily convert a String to Currency Format while maintaining readability
     # Code Example
     ```
     let result = result.currentValue.currencyFormatter
     ```
     */
    var currencyFormat: String {
        /// NumberFormatter() is used to change String to "Currency" format
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
    /**
     Converts a String to a Percentage Format String
        => "%50"
     # Usage
     Used to easily convert a String to Percentage Format while maintaining readability
     # Code Example
     ```
     let result = result.annualReturn.percentageFormat
     ```
     */
    var percentageFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
    /**
     Converts a String to a Percentage Format String
        => "%50"
     # Usage
     Used to convert strings with different use cases to Percentage format
        - Strings with / without $ Symbol
        - Strings with with / without Decimal Places
     # Code Example
     ```
     let result = result.annualReturn.percentageFormat
     ```
     */
    func convertToCurrencyFormat(hasDollarSymbol: Bool = true, hasDecimalPlaces: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if !hasDollarSymbol {
            formatter.currencySymbol = ""
        }
        if hasDollarSymbol {
            formatter.currencySymbol = "$"
        }
        if !hasDecimalPlaces {
            formatter.maximumFractionDigits = 0
        }
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
}
