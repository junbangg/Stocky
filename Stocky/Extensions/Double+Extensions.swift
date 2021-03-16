//
//  Double+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//

import Foundation

/// Double Extensions

extension Double {
    
    var stringValue : String {
        return String(describing: self)
    }
    
    var twoDecimalFormatString : String {
        return String(format: "%.2f", self)
    }
    
    var currencyFormatter : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
    
    var percentageFormat : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
    func toCurrencyFormat(hasDollarSymbol : Bool = true, hasDecimalPlaces : Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if hasDollarSymbol == false {
            formatter.currencySymbol = ""
        }
        if hasDollarSymbol == true {
            formatter.currencySymbol = "$"
        }
        if hasDecimalPlaces == false {
            formatter.maximumFractionDigits = 0
        }
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
    
}
