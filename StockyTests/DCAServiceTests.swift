//
//  StockyTests.swift
//  StockyTests
//
//  Created by Jun Bang on 2021/02/28.
//

//Testing new branch

import XCTest
@testable import Stocky

///Unit Tests for DCA Service
class DCAServiceTests: XCTestCase {
    
    //MARK: - Setup code
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
    
    /**
     
     Test Cases
     - 1. asset = winning | dca = true => positive gains
     - 2. asset = winning | dca = false => positive gains
     - 3. asset = losing | dca = true => negative gains
     - 4. asset = losing | dca = false => negative gains
     
     Convention for test function name
     - What _ Given  _ Expected
     
     Format for test function
     - Given
     - When
     - Then?
     
     - When DCA is not used: value is set to 0
     */
    
    
    //MARK: - Tests for DCA calculation
    /// GIven: Profitable Asset with DCA applied
    /// Expected: Positive gains
    func testResult_givenProfitableAssetAndDCAIsUsed_expectPositiveGains() {
        //given
        let initialInvestmentAmount : Double = 5000
        let monthlyDollarCostAveragingAmount : Double = 1500
        let initialDateOfInvestmentIndex : Int = 5
        let asset = buildProfitableAsset()
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
    /// GIven: Profitable Asset without DCA applied
    /// Expected: Positive gains
    func testResult_givenProfitableAssetAndDCAIsNotUsed_expectPositiveGains() {
        //given
        let initialInvestmentAmount : Double = 5000
        let monthlyDollarCostAveragingAmount : Double = 0
        let initialDateOfInvestmentIndex : Int = 3
        let asset = buildProfitableAsset()
        //when
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialInvestmentAmount,
                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        //then
        // Initial Investment : $5000
        // DCA : $0 x 3 = $0
        // total : $5000 + $0 = $5000
        //
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertTrue(result.isProtiable)
        
        /// Current Value Formula
        // Mar: $5000 / 120 = 41.6666 shares
        // April: $0 / 130 = 0 shares
        // May: $1500 / 140 = 0 shares
        // June: $1500 / 150 = 0 shares
        // Total Shares = 41.6666 shares
        // Total current value = 41.6666 * 160 (latest month closing price) = $6666.666
        
        /// Gain Formula
        //Gain = Current Value - Initial Investment = 6666.666 - 5000 = 1666.666
        
        /// Yield Formula
        // Yield = Gain / Investment Amount = 1666.666 / 5000
        XCTAssertEqual(result.currentValue, 6666.666, accuracy: 0.1)
        XCTAssertEqual(result.gain, 1666.666, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3333, accuracy: 0.0001)
        
    }
    /// GIven: Non-profitable Asset with DCA applied
    /// Expected: Negative gains
    func testResult_givenNonprofitableAssetAndDCAIsUsed_expectNegativeGains() {
        //given
        let initialInvestmentAmount : Double = 5000
        let monthlyDollarCostAveragingAmount : Double = 1500
        let initialDateOfInvestmentIndex : Int = 5
        let asset = buildNonProfitableAsset()
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
        XCTAssertFalse(result.isProtiable)
        /// Current Value Formula
        // Jan: $5000 / 170 = 29.4117 shares
        // Feb: $1500 / 160 = 9.375 shares
        // Mar: $1500 / 150 = 10 shares
        // April: $1500 / 140 = 10.7142 shares
        // May: $1500 / 140 = 11.5384 shares
        // June: $1500 / 120 = 12.5 shares
        // Total Shares = 83.5393 shares
        // Total current value = 83.5393 * 110 (latest month closing price) = $9189.323
        /// Gain Formula
        // Gains = current value - invesment amount = 9189.323 - 12500 = -3310.677
        /// Yield Formula
        // Yield = gains / investment amount : -3310.677 / 12500 = -0.2648
        
        
        XCTAssertEqual(result.currentValue, 9189.323, accuracy: 0.1)
        XCTAssertEqual(result.gain, -3310.677, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.2648, accuracy: 0.0001)
    }
    /// GIven: Non-profitable Asset without DCA applied
    /// Expected: Negative gains
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegative() {
        //given
        let initialInvestmentAmount : Double = 5000
        let monthlyDollarCostAveragingAmount : Double = 0
        let initialDateOfInvestmentIndex : Int = 3
        let asset = buildNonProfitableAsset()
        //when
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialInvestmentAmount,
                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        //then
        // Initial Investment : $5000
        // DCA : $0 x 3 = $0
        // total : $5000 + $0 = $5000
        //
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertFalse(result.isProtiable)
        /// Current Value Formula
        // Mar: $5000 / 150 = 33.3333 shares
        // April: $0 / 140 = 0 shares
        // May: $0 / 130 = 0 shares
        // June: $0 / 120 = 0 shares
        // Total Shares = 33.3333 shares
        // Total current value = 33.3333 * $110 (latest month closing price) = $3666.6666
        /// Gain Formula
        // Gains = current value - invesment amount = $3666.6666 - 5000 = -1333.333
        /// Yield Formula
        // Yield = gains / investment amount : -1333.333 / 5000 = -0.26666
        
        
        XCTAssertEqual(result.currentValue, 3666.666, accuracy: 0.1)
        XCTAssertEqual(result.gain, -1333.333, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.26666, accuracy: 0.0001)
    }
    //MARK: - Methods for building test data
    /// Method for building Test Asset (Profitable)
    private func buildProfitableAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries : [String : TSData] = ["2008-01-29": TSData(open: "100", close: "110", adjustedClose: "110"),
                                              "2008-02-29": TSData(open: "110", close: "120", adjustedClose: "120"),
                                              "2008-03-29": TSData(open: "120", close: "130", adjustedClose: "130"),
                                              "2008-04-29": TSData(open: "130", close: "140", adjustedClose: "140"),
                                              "2008-05-29": TSData(open: "140", close: "150", adjustedClose: "150"),
                                              "2008-06-29": TSData(open: "150", close: "160", adjustedClose: "160")]
        
        let timeSeriesMonthlyAdjusted  = TimeSeries(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeries: timeSeriesMonthlyAdjusted)
    }
    /// Method for building Test Asset (Non-profitable)
    private func buildNonProfitableAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries : [String : TSData] = ["2021-01-25": TSData(open: "170", close: "160", adjustedClose: "160"),
                                              "2021-02-25": TSData(open: "160", close: "150", adjustedClose: "150"),
                                              "2021-03-25": TSData(open: "150", close: "140", adjustedClose: "140"),
                                              "2021-04-25": TSData(open: "140", close: "130", adjustedClose: "130"),
                                              "2021-05-25": TSData(open: "130", close: "120", adjustedClose: "120"),
                                              "2021-06-25": TSData(open: "120", close: "110", adjustedClose: "110")]
        
        let timeSeriesMonthlyAdjusted  = TimeSeries(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeries: timeSeriesMonthlyAdjusted)
    }
    /// Method for building Test SearchResult
    private func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "XYZ", name: "XYZCompany", type: "ETF", currency: "USD")
    }
    /// Method for build Test Meta symbol
    private func buildMeta() -> Meta {
        return Meta(symbol: "XYZ")
    }
    //MARK: - Tests for investment amount
    
    /// Test to check investment amount when DCA is used
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
    /// Test to check investment amount when DCA is not used
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
