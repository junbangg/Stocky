//
//  Int+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/18.
//

import Foundation

/**
 Int Extensions
 
 # Purpose
    - Code Readibility
    - Reusability
 
 # Components
    - var floatValue : Float
    - var doubleValue : Double
 */

extension Int {
    
    /// Converts an Int value to Float type
    var floatValue : Float {
        return Float(self)
    }
    
    /// Converts Int value to Double type
    var doubleValue : Double {
        return Double(self)
    }
}
