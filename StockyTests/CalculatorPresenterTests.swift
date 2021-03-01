//
//  CalculatorPresenterTests.swift
//  StockyTests
//
//  Created by Jun Bang on 2021/03/01.
//

import XCTest
@testable import Stocky

class CalculatorPresenterTests: XCTestCase {
    
    var sut : CalculatorPresenter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CalculatorPresenter()
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    /// Naming Convention
    // Test_Given_Expect
    
    /// Testi Format
    // Given -> When -> Then
     
    func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        //Given
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: true)
        //When
        let presentation = sut.getPresentation(result: result)
        
        // Then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemGreen)
        
    }
    
    func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen() throws {
        //Given
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: true)
        //When
        let presentation = sut.getPresentation(result: result)
        
        // Then
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemGreen)
        
    }
    
    func testAnnualReturnLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        //Given
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: false)
        //When
        let presentation = sut.getPresentation(result: result)
        
        // Then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemRed)
        
    }
    
    func testYieldLabelTextColor_givenResultIsNonProfitable_expectSystemRed() throws {
        //Given
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0,
                                    annualReturn: 0,
                                    isProtiable: false)
        //When
        let presentation = sut.getPresentation(result: result)
        
        // Then
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemRed)
        
    }
    
    func testYieldLabel_expectBrackets() throws {
        let first : Character = "("
        let last : Character = ")"
        //Given
        let result = DCAResult.init(currentValue: 0,
                                    investmentAmount: 0,
                                    gain: 0,
                                    yield: 0.25,
                                    annualReturn: 0,
                                    isProtiable: false)
        // When
        let presentation = sut.getPresentation(result: result)
        
        //Then
        XCTAssertEqual(presentation.yield.first, first)
        XCTAssertEqual(presentation.yield.last, last)
    }
    
    

}
