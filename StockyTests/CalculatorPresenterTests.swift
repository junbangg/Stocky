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
    /**
     
     Test Cases
     
     Convention for test function name
     - Testing _ Given  _ Expected
     
     Format for test function
     - Given
     - When
     - Then?
    
     */
    //MARK: - Test for Annual Return Label
    /// Testing: Annual Return Label Text Color
    /// Given : profitable result
    /// Expected:  system green color
    func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        //Given
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: true)
        //When
        let presentation = sut.getPresentation(result: mockResult)
        
        // Then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemGreen)
        
    }
    /// Testing: Annual Return Label Text Color
    /// Given : non-profitable result
    /// Expected:  system red color
    func testAnnualReturnLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        //Given
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: false)
        //When
        let presentation = sut.getPresentation(result: mockResult)
        
        // Then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemRed)
    }
    //MARK: - Test for Yield Label
    /// Testing: Yield Label Text Color
    /// Given : profitable result
    /// Expected:  system green color
    func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        //Given
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: true)
        //When
        let presentation = sut.getPresentation(result: mockResult)
        
        // Then
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemGreen)
    }
    /// Testing: Yield Label Text Color
    /// Given : non-profitable result
    /// Expected:  system red color
    func testYieldLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        //Given
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: false)
        //When
        let presentation = sut.getPresentation(result: mockResult)
        // Then
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemRed)
    }
    //MARK: - Test for Yield Label
    /// Testing: Yield Label Text
    /// Given : text
    /// Expected:  brackets
    func testYieldLabel_expectBrackets() throws {
        let first: Character = "("
        let last: Character = ")"
        //Given
        let mockResult = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0.25,
                                    annualReturn: 0,
                                    isProtiable: false)
        // When
        let presentation = sut.getPresentation(result: mockResult)
        //Then
        XCTAssertEqual(presentation.yield.first, first)
        XCTAssertEqual(presentation.yield.last, last)
    }
}
