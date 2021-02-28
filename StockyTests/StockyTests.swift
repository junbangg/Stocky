//
//  StockyTests.swift
//  StockyTests
//
//  Created by Jun Bang on 2021/02/28.
//

import XCTest
@testable import Stocky

class StockyTests: XCTestCase {

    var sut: DCAService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        sut = nil
    }
    
    //Format for test function name
    //What
    //Given
    //Expected
    func testDCAResult_givenDCAIsUsed_expecteResult() {
        
    }
    
    func testDCAResult_givenDCAIsNotUsed_expectResult() {
        
    }
    
    func testInvestmentAmount_whenDCAIsUsed_expectResult() {
        // given
        let initialInvestmentAmount : Double = 500
        let monthlyDollarCostAveragingAmount : Double  = 300
        let initialDateOfInvestmentIndex : Int = 4 // 5 months ago
        // when
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        // expected
        XCTAssertEqual(investmentAmount, 1700)
        
        // Initial Amount : $ 500
        // DCA: 4 x $300 = $1200
        // total: $400 + $500 = $1700
        
    }
    
    func testInvestmentAmount_whenDCAIsNotUsed_expectResult() {
        // given
        let initialInvestmentAmount : Double = 500
        let monthlyDollarCostAveragingAmount : Double  = 0
        let initialDateOfInvestmentIndex : Int = 4 // 5 months ago
        // when
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        // expected
        XCTAssertEqual(investmentAmount, 500)
        
        // Initial Amount : $ 500
        // DCA: 4 x $0 = $0
        // total: $0 + $500 = $500
        
    }

}
