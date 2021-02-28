//
//  DCAService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//

import Foundation

struct DCAService {
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
    func getInvestmentAmount(initialInvestmentAmount: Double,
                                     monthlyDollarCostAveragingAmount: Double,
                                     initialDateOfInvestmentIndex: Int) -> Double{
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dollarCostAveragingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmount
        return totalAmount
    }
    
    private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvestmentIndex: Int) -> Double {
        let rate = currentValue / investmentAmount
        let years = (initialDateOfInvestmentIndex.doubleValue + 1) / 12
        let result = pow(rate, 1/years) - 1
        return result
    }
    
    private func getCurrentValue(numberOfShares : Double, latestSharePrice : Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getLatestSharedPrice(asset : Asset) -> Double {
        return asset.timeSeries.getMonthData().first?.adjustedClose ?? 0
    }
    
    private func getNumberOfShares(asset: Asset,
                                   initialInvestmentAmount: Double,
                                   monthlyDollarCostAveragingAmount: Double,
                                   initialDateOfInvestmentIndex: Int) -> Double {
        
        var totalShares = Double()
        let initialInvestmentOpenPrice = asset.timeSeries.getMonthData()[initialDateOfInvestmentIndex].adjustedOpen
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        asset.timeSeries.getMonthData().prefix(initialDateOfInvestmentIndex).forEach { (monthInfo) in
            let dcaInvestmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        return totalShares
    }
    
}


struct DCAResult {
    let currentValue : Double
    let investmentAmount : Double
    let gain : Double
    let yield : Double
    let annualReturn : Double
    let isProtiable : Bool

}
