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
        return .init(currentValue: 0,
                     investmentAmount: 0,
                     gain: 0,
                     yield: 0,
                     annualReturn: 0)
    }
}


struct DCAResult {
    let currentValue : Double
    let investmentAmount : Double
    let gain : Double
    let yield : Double
    let annualReturn : Double
}
