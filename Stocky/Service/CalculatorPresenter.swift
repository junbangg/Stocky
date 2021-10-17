//
//  CalculatorPresenter.swift
//  Stocky
//
//  Created by Jun Bang on 2021/03/01.
//

import UIKit
/// More elegant way for updating data presented in CalculatorTableViewController
struct CalculatorPresenter {
    /// Function to convert DCAResult data to data presentable in CalculatorTableViewController
    /// - Parameter result: DCAResult with data prepared for presentation
    /// - Returns: CalculatorPresentation
    func getPresentation(result: DCAResult) -> CalculatorPresentation {
        
        let isProfitable = result.isProtiable == true
        let gainSymbol = isProfitable ? "+" : ""
        
        return .init( currentValueLabelBackgroundColor: isProfitable ? .themeGreenShade : .themeRedShade,
                      currentValue: result.currentValue.currencyFormatter,
                     investmentAmount: result.investmentAmount.convertToCurrencyFormat(hasDecimalPlaces: false),
                     gain: result.gain.convertToCurrencyFormat(hasDollarSymbol: true, hasDecimalPlaces: false).prefix(withText: gainSymbol),
                     yield: result.yield.percentageFormat.prefix(withText: gainSymbol).addParentheses(),
                     yieldLabelTextColor: isProfitable ? .systemGreen : .systemRed,
                     annualReturn: result.annualReturn.percentageFormat,
                     annualReturnLabelTextColor: isProfitable ? .systemGreen : .systemRed)
    }
}

/// Final object before presentation
struct CalculatorPresentation {
    let currentValueLabelBackgroundColor: UIColor
    let currentValue: String
    let investmentAmount: String
    let gain: String
    let yield: String
    let yieldLabelTextColor: UIColor
    let annualReturn: String
    let annualReturnLabelTextColor: UIColor
}
