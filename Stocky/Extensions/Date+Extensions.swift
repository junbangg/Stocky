//
//  Date+Extensions.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/05.
//
import Foundation

extension Date {
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
