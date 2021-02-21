//
//  Double+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/19.
//

import Foundation

extension Double {
    
    var stringValue : String {
        return String(describing: self)
    }
    
    var twoDecimalFormatString : String {
        return String(format: "%.2f", self)
    }
}
