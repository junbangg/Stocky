//
//  DateSelectionTableViewCell.swift
//  Stocky
//
//  Created by Jun Bang on 2022/04/22.
//

import Foundation
import UIKit

final class DateSelectionTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    // MARK: - Configuration Methods
    
    func configure(
        with monthData: MonthData,
        with index: Int,
        isSelected: Bool
    ) {
        monthLabel.text = monthData.date.MMYYFormat
        accessoryType = isSelected ? .checkmark : .none
        if index == 1 {
            monthsAgoLabel.text = "\(MonthsAgoString.oneMonth)"
        } else if index > 1{
            monthsAgoLabel.text = "\(index) \(MonthsAgoString.nMonths)"
        } else {
            monthsAgoLabel.text = "\(MonthsAgoString.recent)"
        }
    }
}

// MARK: - [Namespace] MonthsAgoString

extension DateSelectionTableViewCell {
    private enum MonthsAgoString: String, CustomStringConvertible {
        case oneMonth = "1 개월 전"
        case nMonths = "개월 전"
        case recent = "방금 투자"
        
        var description: String {
            return rawValue
        }
    }
}

// MARK: - IdentifiableView

extension DateSelectionTableViewCell: IdentifiableView {}
