//
//  DCAService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//

import Foundation

protocol DCAServicable {
    func calculateDCA(
        _ asset: Asset,
        _ initialInvestmentAmount: Double,
        _ monthlyDollarCostAveragingAmount: Double,
        _ initialDateOfInvestmentIndex: Int
    ) -> DCAResult
    
    func getInvestmentAmount(
        _ initialInvestmentAmount: Double,
        _ monthlyDollarCostAveragingAmount: Double,
        _ initialDateOfInvestmentIndex: Int
    ) -> Double
}

extension DCAServicable {
    func calculateDCA(
        _ asset: Asset,
        _ initialInvestmentAmount: Double,
        _ monthlyDollarCostAveragingAmount: Double,
        _ initialDateOfInvestmentIndex: Int
    ) -> DCAResult {
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount, monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex)
        let latestSharePrice = getLatestSharedPrice(of: asset)
        let numberOfShares = getNumberOfShares(asset, initialInvestmentAmount, monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex)
        let currentInvestmentValue = getCurrentInvestmentValue(numberOfShares, latestSharePrice)
        let isProfitable = currentInvestmentValue > investmentAmount
        let gain = currentInvestmentValue - investmentAmount
        let yield = gain / investmentAmount
        let annualReturn = getAnnualReturn(
            currentInvestmentValue,
            investmentAmount,
            initialDateOfInvestmentIndex
        )
        
        return .init(
            currentValue: currentInvestmentValue,
            investmentAmount: investmentAmount,
            gain: gain,
            yield: yield,
            annualReturn: annualReturn,
            isProtiable: isProfitable
        )
    }
    
    func getInvestmentAmount(
        _ initialInvestmentAmount: Double,
        _ monthlyDollarCostAveragingAmount: Double,
        _ initialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dollarCostAveragingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmount
        
        return totalAmount
    }
    
    private func getAnnualReturn(
        _ currentInvestmentValue: Double,
        _ investmentAmount: Double,
        _ initialDateOfInvestmentIndex: Int
    ) -> Double {
        let rate = currentInvestmentValue / investmentAmount
        let years = (initialDateOfInvestmentIndex.doubleValue + 1) / 12
        let result = pow(rate, 1/years) - 1
        
        return result
    }
    
    private func getCurrentInvestmentValue(
        _ numberOfShares: Double,
        _ latestSharePrice: Double
    ) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getLatestSharedPrice(of asset: Asset) -> Double {
        return asset.timeSeries
            .getMonthData(isReversed: true)
            .first?
            .adjustedClose ?? 0
    }
    
    private func getNumberOfShares(
        _ asset: Asset,
        _ initialInvestmentAmount: Double,
        _ monthlyDollarCostAveragingAmount: Double,
        _ initialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalShares = Double()
        let initialInvestmentOpenPrice = asset.timeSeries
            .getMonthData(isReversed: true)[initialDateOfInvestmentIndex]
            .adjustedOpen
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        asset.timeSeries
            .getMonthData(isReversed: true)
            .prefix(initialDateOfInvestmentIndex)
            .forEach { monthInfo in
                let dcaInvestmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjustedOpen
                totalShares += dcaInvestmentShares
            }
        
        return totalShares
    }
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    let isProtiable: Bool
}
