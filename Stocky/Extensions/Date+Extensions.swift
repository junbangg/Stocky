//
//  Date+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/05.
//

/**
 Extensions for "Date" Type
 
 # Purpose
    - Code Readibility
    - Reusability
 
 # Components
    - MMYYFormat
 */

import Foundation

extension Date {
    /**
     Converts String to Month / Year Format
     # Usage
     Used for reformatting Date String to a "March 2021" format
     # Code Example
     ```
     let monthData = monthDatas[index]
     let dateString = monthData.date.MMYYFormat
     ```
     */
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
