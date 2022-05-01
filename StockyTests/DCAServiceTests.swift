//
//  StockyTests.swift
//  StockyTests
//
//  Created by Jun Bang on 2021/02/28.
//

//Testing new branch

import XCTest
@testable import Stocky

final class DCAServiceTests: XCTestCase {
    private var sut: DCAServicable!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockDCAService()
    }
    
    override func tearDownWithError() throws {
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
    
    private func testResult_givenProfitableAssetAndDCAIsUsed_expectPositiveGains() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateOfInvestmentIndex: Int = 5
        let asset = createProfitableAsset()
        let result = sut.calculateDCAResult(asset,
                                      initialInvestmentAmount,
                                      monthlyDollarCostAveragingAmount,
                                      initialDateOfInvestmentIndex)
        //then
        // Initial Investment : $5000
        // DCA : $1500 x 5 = $7500
        // total : $5000 + $7500 = $125000
        //
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertTrue(result.isProfitable)
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
    
    private func testResult_givenProfitableAssetAndDCAIsNotUsed_expectPositiveGains() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateOfInvestmentIndex: Int = 3
        let asset = createProfitableAsset()
        let result = sut.calculateDCAResult(asset,
                                      initialInvestmentAmount,
                                      monthlyDollarCostAveragingAmount,
                                      initialDateOfInvestmentIndex)
        // Initial Investment : $5000
        // DCA : $0 x 3 = $0
        // total : $5000 + $0 = $5000
        //
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertTrue(result.isProfitable)
        
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
    
    private func testResult_givenNonprofitableAssetAndDCAIsUsed_expectNegativeGains() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateOfInvestmentIndex: Int = 5
        let asset = createNonProfitableAsset()
        let result = sut.calculateDCAResult(asset,
                                      initialInvestmentAmount,
                                      monthlyDollarCostAveragingAmount,
                                      initialDateOfInvestmentIndex)
        // Initial Investment : $5000
        // DCA : $1500 x 5 = $7500
        // total : $5000 + $7500 = $125000
        //
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertFalse(result.isProfitable)
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
    
    private func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegative() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateOfInvestmentIndex: Int = 3
        let asset = createNonProfitableAsset()
        let result = sut.calculateDCAResult(asset,
                                      initialInvestmentAmount,
                                      monthlyDollarCostAveragingAmount,
                                      initialDateOfInvestmentIndex)
        //then
        // Initial Investment : $5000
        // DCA : $0 x 3 = $0
        // total : $5000 + $0 = $5000
        //
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertFalse(result.isProfitable)
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
    
    //MARK: - Tests for investment amount
    
    private func testInvestmentAmount_whenDCAIsUsed_expectResult() {
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double  = 300
        let initialDateOfInvestmentIndex: Int = 4 // 5 months ago
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount,
                                    monthlyDollarCostAveragingAmount,
                                    initialDateOfInvestmentIndex)
        // expected
        XCTAssertEqual(investmentAmount, 1700)
        // Initial Amount : $ 500
        // DCA: 4 x $300 = $1200
        // total: $400 + $500 = $1700
    }
    
    private func testInvestmentAmount_whenDCAIsNotUsed_expectResult() {
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double  = 0
        let initialDateOfInvestmentIndex: Int = 4 // 5 months ago
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount,
                                    monthlyDollarCostAveragingAmount,
                                    initialDateOfInvestmentIndex)
        
        XCTAssertEqual(investmentAmount, 500)
        // Initial Amount : $ 500
        // DCA: 4 x $0 = $0
        // total: $0 + $500 = $500
    }
    
    //MARK: - Methods for building test data
    
    private func createProfitableAsset() -> Asset {
        let searchResult = createSearchResult()
        let meta = createMeta()
        let timeSeries: [String: TimeSeriesData] = ["2008-01-29": TimeSeriesData(open: "100", close: "110", adjustedClose: "110"),
                                                    "2008-02-29": TimeSeriesData(open: "110", close: "120", adjustedClose: "120"),
                                                    "2008-03-29": TimeSeriesData(open: "120", close: "130", adjustedClose: "130"),
                                                    "2008-04-29": TimeSeriesData(open: "130", close: "140", adjustedClose: "140"),
                                                    "2008-05-29": TimeSeriesData(open: "140", close: "150", adjustedClose: "150"),
                                                    "2008-06-29": TimeSeriesData(open: "150", close: "160", adjustedClose: "160")]
        let timeSeriesMonthlyAdjusted = TimeSeries(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeries: timeSeriesMonthlyAdjusted)
    }
    
    private func createNonProfitableAsset() -> Asset {
        let searchResult = createSearchResult()
        let meta = createMeta()
        let timeSeries: [String: TimeSeriesData] = ["2021-01-25": TimeSeriesData(open: "170", close: "160", adjustedClose: "160"),
                                                    "2021-02-25": TimeSeriesData(open: "160", close: "150", adjustedClose: "150"),
                                                    "2021-03-25": TimeSeriesData(open: "150", close: "140", adjustedClose: "140"),
                                                    "2021-04-25": TimeSeriesData(open: "140", close: "130", adjustedClose: "130"),
                                                    "2021-05-25": TimeSeriesData(open: "130", close: "120", adjustedClose: "120"),
                                                    "2021-06-25": TimeSeriesData(open: "120", close: "110", adjustedClose: "110")]
        let timeSeriesMonthlyAdjusted = TimeSeries(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeries: timeSeriesMonthlyAdjusted)
    }
    
    private func createSearchResult() -> SearchResult {
        return SearchResult(
            symbol: "XYZ",
            name: "XYZCompany",
            type: "ETF",
            currency: "USD"
        )
    }
    
    private func createMeta() -> Meta {
        return Meta(symbol: "XYZ")
    }
}
