//
//  DCAService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//

import Foundation

struct DCAService {
    func calculate(initialInvestmentAmount: Double,
                   monthlyDollarCostAveragingAmount: Double,
                   initialDateOfInvestmentIndex: Int) -> DCAResult{
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,              monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        return .init(currentValue: 0,
                     investmentAmount: investmentAmount,
                     gain: 0,
                     yield: 0,
                     annualReturn: 0)
    }
    private func getInvestmentAmount(initialInvestmentAmount: Double,
                                     monthlyDollarCostAveragingAmount: Double,
                                     initialDateOfInvestmentIndex: Int) -> Double{
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dollarCostAveragingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmount
        return totalAmount
    }
}


struct DCAResult {
    let currentValue : Double
    let investmentAmount : Double
    let gain : Double
    let yield : Double
    let annualReturn : Double
}
