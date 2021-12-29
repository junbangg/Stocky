//
//  DateSelectionTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/04.
//

import UIKit

final class DateSelectionTableViewController: UITableViewController {
    //MARK: -  Properties
    
    var timeSeries: TimeSeries?
    var selectedIndex: Int?
    private var monthDatas: [MonthData] = []
    var didSelectDate: ((Int) -> Void)?
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
}

//MARK: - UI Methods

extension DateSelectionTableViewController {
    private func setupNavigationBar() {
        title = "Select Date"
    }
    
    private func setupTableView() {
        monthDatas = timeSeries?.getMonthData(isReversed: true) ?? []
    }
}

//MARK: - TableView Methods
extension DateSelectionTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! DateSelectionTableViewCell
        let monthData = monthDatas[indexPath.item]
        let index = indexPath.item
        let isSelected = index == selectedIndex
        cell.configure(with: monthData, with: index, isSelected: isSelected)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Custom TableViewCell Class
class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    private enum MonthsAgoString: String, CustomStringConvertible {
        case oneMonth = "1 개월 전"
        case nMonths = "개월 전"
        case recent = "방금 투자"
        
        var description: String {
            return rawValue
        }
    }
    
    func configure(with monthData: MonthData, with index: Int, isSelected: Bool) {
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
