//
//  UIPresentable.swift
//  Stocky
//
//  Created by Jun Bang on 2021/11/30.
//

import Foundation

protocol UIPresentable {
    func getPresentation(result: DCAResult) -> CalculatorUIPresentation
}
