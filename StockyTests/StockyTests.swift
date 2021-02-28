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
    
    /// Test Cases
    //    1. asset = winning | dca = true => positive gains
    //    2. asset = winning | dca = false => positive gains
    //    3. asset = losing | dca = true => negative gains
    //    4. asset = losing | dca = false => negative gains
    
    
    /// Format for test function name
    //  What
    //  Given
    //  Expected
    
    /// Format for test function
    //  Given
    //  When
    //  Then
    
    func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        //given
        let initialInvestmentAmount : Double = 5000
        let monthlyDollarCostAveragingAmount : Double = 1500
        let initialDateOfInvestmentIndex : Int = 5
        let asset = buildWinningAsset()
        //when
        let result = sut.calculate(asset: asset,
                                 initialInvestmentAmount: initialInvestmentAmount,
                                 monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                 initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        //then
        // Initial Investment : $5000
        // DCA : $1500 x 5 = $7500
        // total : $5000 + $7500 = $125000
        //
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertTrue(result.isProtiable)
        // Jan: $5000 / 100 = 50 shares
        // Feb: $1500 / 110 = 13.6363 shares
        // Mar: $1500 / 120 = 12.5 shares
        // April: $1500 / 130 = 11.5384 shares
        // May: $1500 / 140 = 10.7142 shares
        // June: $1500 / 150 = 10 shares
        // Total Shares = 108.3889 shares
        // Total current value = 108.3889 * 160 (latest month closing price) = $17,342.224
        
        XCTAssertEqual(result.currentValue, 17342.224, accuracy: 0.1)
        XCTAssertEqual(result.gain, 4842.224, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3873, accuracy: 0.0001)
        
        
    }
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        
    }
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        
    }
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegative() {
        
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries : [String : TSData] = ["2008-02-29": TSData(open: "100", close: "110", adjustedClose: "110"),
                                            "2008-03-29": TSData(open: "110", close: "120", adjustedClose: "120"),
                                            "2008-04-29": TSData(open: "120", close: "130", adjustedClose: "130"),
                                            "2008-05-29": TSData(open: "130", close: "140", adjustedClose: "140"),
                                            "2008-06-29": TSData(open: "140", close: "150", adjustedClose: "150"),
                                            "2008-07-29": TSData(open: "150", close: "160", adjustedClose: "160")]
       
        let timeSeriesMonthlyAdjusted  = TimeSeries(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeries: timeSeriesMonthlyAdjusted)
    }
    
    private func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "XYZ", name: "XYZCompany", type: "ETF", currency: "USD")
    }
    
    private func buildMeta() -> Meta {
        return Meta(symbol: "XYZ")
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