//
//  CalculatorPresenter.swift
//  Stocky
//
//  Created by Jun Bang on 2021/03/01.
//

import UIKit

struct CalculatorPresenter {
    func getPresentation(result : DCAResult) -> CalculatorPresentation {
        
        let isProfitable = result.isProtiable == true
        let gainSymbol = isProfitable ? "+" : ""
        
        return .init( currentValueLabelBackgroundColor: isProfitable ? .themeGreenShade : .themeRedShade,
                      currentValue: result.currentValue.currencyFormatter,
                     investmentAmount: result.investmentAmount.toCurrencyFormat(hasDecimalPlaces: false),
                     gain: result.gain.toCurrencyFormat(hasDollarSymbol: true, hasDecimalPlaces: false).prefix(withText: gainSymbol),
                     yield: result.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets(),
                     yieldLabelTextColor: isProfitable ? .systemGreen : .systemRed,
                     annualReturn: result.annualReturn.percentageFormat,
                     annualReturnLabelTextColor: isProfitable ? .systemGreen : .systemRed)
        
    }
}

struct CalculatorPresentation {
    let currentValueLabelBackgroundColor : UIColor
    let currentValue : String
    let investmentAmount : String
    let gain : String
    let yield : String
    let yieldLabelTextColor : UIColor
    let annualReturn : String
    let annualReturnLabelTextColor : UIColor
}
