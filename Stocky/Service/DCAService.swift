//
//  DCAService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//

import Foundation
/**
 Struct used to calculate Dollar Cost Averaging
 
 # Components
 - func calculate(asset: Asset, initialInvestmentAmount: Double, monthlyDollarCostAveragingAmount : Double, initialDateOfInvestment) -> DCAResult
 - func getInvestmentAmount(initialInvestmentAmount: Double, monthlyDollarCostAveragingAmount: Double, initialDateOfInvestmentIndex: Int) -> Double
 - private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvestmentIndex: Int) -> Double
 - private func getCurrentValue(numberOfShares : Double, latestSharePrice : Double) -> Double
 - private func getLatestSharedPrice(asset : Asset) -> Double
 - private func getLatestSharedPrice(asset : Asset) -> Double
 - private func getNumberOfShares(asset: Asset, initialInvestmentAmount: Double, monthlyDollarCostAveragingAmount: Double, initialDateOfInvestmentIndex: Int) -> Double
 */
struct DCAService {
    /// Function to calculate the DCA
    /// - Parameters:
    ///   - asset: Asset that holds the data needed for calculation
    ///   - initialInvestmentAmount: initial investment provided by user
    ///   - monthlyDollarCostAveragingAmount: monthly dollar cost averaging  provided by user
    ///   - initialDateOfInvestmentIndex: initial date of investment provided by user converted to index
    /// - Returns: DCAResult with data to present in view
    func calculate(asset: Asset,
                   initialInvestmentAmount: Double,
                   monthlyDollarCostAveragingAmount: Double,
                   initialDateOfInvestmentIndex: Int) -> DCAResult{
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,              monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        let latestSharePrice = getLatestSharedPrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(asset: asset, initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let isProfitable = currentValue > investmentAmount
        
        let gain = currentValue - investmentAmount
        let yield = gain / investmentAmount
        
        let annualReturn = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: gain,
                     yield: yield,
                     annualReturn: annualReturn,
                     isProtiable: isProfitable)
    }
    
    /// Function to calculate investment amount
    /// - Parameters:
    ///   - initialInvestmentAmount: initial investment provided by user
    ///   - monthlyDollarCostAveragingAmount: monthly dollar cost averaging  provided by user
    ///   - initialDateOfInvestmentIndex: initial date of investment provided by user converted to index
    /// - Returns: Investment amount
    func getInvestmentAmount(initialInvestmentAmount: Double,
                                     monthlyDollarCostAveragingAmount: Double,
                                     initialDateOfInvestmentIndex: Int) -> Double {
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dollarCostAveragingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmount
        return totalAmount
    }
    
    /// Function to calculate annual return
    /// - Parameters:
    ///   - currentValue: current value of investment
    ///   - investmentAmount: result of getInvestmentAmount()
    ///   - initialDateOfInvestmentIndex: initial date of investment provided by user converted to index
    /// - Returns: Annual return
    private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvestmentIndex: Int) -> Double {
        let rate = currentValue / investmentAmount
        let years = (initialDateOfInvestmentIndex.doubleValue + 1) / 12
        let result = pow(rate, 1/years) - 1
        return result
    }
    
    /// Function to calculate current value of investment
    /// - Parameters:
    ///   - numberOfShares: number of shares
    ///   - latestSharePrice: lastest share price
    /// - Returns: Current Value of investment
    private func getCurrentValue(numberOfShares : Double, latestSharePrice : Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    /// Function to calculate latest shared price
    /// - Parameter asset: Asset that holds all data required for calculation
    /// - Returns: Extracts latest shared price data
    private func getLatestSharedPrice(asset : Asset) -> Double {
        return asset.timeSeries.getMonthData(dateReverseSort: true).first?.adjustedClose ?? 0
    }
    
    /// Function to extract number of shares
    /// - Parameters:
    ///   - asset: Asset that holds all data required for calculation
    ///   - initialInvestmentAmount: initial investment provided by user
    ///   - monthlyDollarCostAveragingAmount: monthly dollar cost averaging  provided by user
    ///   - initialDateOfInvestmentIndex: initial date of investment provided by user converted to index
    /// - Returns: Total amount of shares
    private func getNumberOfShares(asset: Asset,
                                   initialInvestmentAmount: Double,
                                   monthlyDollarCostAveragingAmount: Double,
                                   initialDateOfInvestmentIndex: Int) -> Double {
        
        var totalShares = Double()
        let initialInvestmentOpenPrice = asset.timeSeries.getMonthData(dateReverseSort: true)[initialDateOfInvestmentIndex].adjustedOpen
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        asset.timeSeries.getMonthData(dateReverseSort: true).prefix(initialDateOfInvestmentIndex).forEach { (monthInfo) in
            let dcaInvestmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        return totalShares
    }
    
}


/// Result type of Dollar Cost Averaging 
struct DCAResult {
    let currentValue : Double
    let investmentAmount : Double
    let gain : Double
    let yield : Double
    let annualReturn : Double
    let isProtiable : Bool

}
