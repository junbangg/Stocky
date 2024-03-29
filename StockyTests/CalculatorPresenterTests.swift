//
//  CalculatorPresenterTests.swift
//  StockyTests
//
//  Created by Jun Bang on 2021/03/01.
//
import XCTest
@testable import Stocky

final class CalculatorPresenterTests: XCTestCase {
    var sut: CalculatorUIPresentable!

    override func setUpWithError() throws {
        sut = MockCalculatorUIPresenter()
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test for Annual Return Label
    
    private func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProfitable: true)
        let presentation = sut.getPresentation(result: result)
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemGreen)
    }
    
    private func testAnnualReturnLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProfitable: false)
        let presentation = sut.getPresentation(result: result)
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemRed)
    }
    
    //MARK: - Test for Yield Label
    
    private func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProfitable: true)
        let presentation = sut.getPresentation(result: result)
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemGreen)
    }
    
    private func testYieldLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProfitable: false)
        let presentation = sut.getPresentation(result: result)
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemRed)
    }
    
    //MARK: - Test for Yield Label
    
    private func testYieldLabel_expectBrackets() throws {
        let first: Character = "("
        let last: Character = ")"
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0.25,
                                    annualReturn: 0,
                                    isProfitable: false)
        let presentation = sut.getPresentation(result: result)
        XCTAssertEqual(presentation.yield.first, first)
        XCTAssertEqual(presentation.yield.last, last)
    }
}
