//
//  CalculatorPresenterTests.swift
//  StockyTests
//
//  Created by Jun Bang on 2021/03/01.
//
import XCTest
@testable import Stocky
/// Unit Tests for CalculatorPresenter
class CalculatorPresenterTests: XCTestCase {
    
    //MARK: - Setup code
    var sut: UIPresentable!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CalculatorUIPresenter()
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    //MARK: - Test for Annual Return Label
    func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: true)
        let presentation = sut.getPresentation(result: mockResult)
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemGreen)
    }
    func testAnnualReturnLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: false)
        let presentation = sut.getPresentation(result: mockResult)
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemRed)
    }
    //MARK: - Test for Yield Label
    func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: true)
        let presentation = sut.getPresentation(result: mockResult)
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemGreen)
    }
    func testYieldLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: false)
        let presentation = sut.getPresentation(result: mockResult)
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemRed)
    }
    //MARK: - Test for Yield Label
    func testYieldLabel_expectBrackets() throws {
        let first: Character = "("
        let last: Character = ")"
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0.25,
                                    annualReturn: 0,
                                    isProtiable: false)
        let presentation = sut.getPresentation(result: mockResult)
        XCTAssertEqual(presentation.yield.first, first)
        XCTAssertEqual(presentation.yield.last, last)
    }
}
