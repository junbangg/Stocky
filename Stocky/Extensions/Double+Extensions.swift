//
//  Double+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//
import Foundation

extension Double {
    private var twoDecimalFormatString: String {
        return String(format: "%.2f", self)
    }
    
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
    
    var percentageFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: self as NSNumber) ?? twoDecimalFormatString
    }
    
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
