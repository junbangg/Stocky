//
//  DateSelectionTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/04.
//

import UIKit

/// UITableViewController for date selection

class DateSelectionTableViewController: UITableViewController {
    //MARK: -  Properties
    var timeSeries: TimeSeries?
    var selectedIndex: Int?
    private var monthDatas: [MonthData] = []
    ///Closure that is passed to CalculatorTableViewController with the selected date index
    var didSelectDate: ((Int) -> Void)?
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    //MARK: - Setup navigation bar
    private func setupNavigationBar() {
        title = "Select Date"
    }
    //MARK: - Setup table view
    private func setupTableView() {
        monthDatas = timeSeries?.getMonthData(isReversed: true) ?? []
    }
}
//MARK: - Extensions
extension DateSelectionTableViewController {
    /// Configure number of rows in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthDatas.count
    }
    /// Create cells configured with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! DateSelectionTableViewCell
        let monthData = monthDatas[indexPath.item]
        let index = indexPath.item
        let isSelected = index == selectedIndex
        cell.configure(with: monthData, with: index, isSelected: isSelected)
        return cell
    }
    /// Selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Passes selected row index through closure
        didSelectDate?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
/// Custom Tableview cell
class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthData: MonthData, with index: Int, isSelected: Bool) {
        monthLabel.text = monthData.date.MMYYFormat
        /// Checkmark appears on selected cell
        accessoryType = isSelected ? .checkmark : .none
        /// Updates monthsAgoLabel text by index
        if index == 1 {
            monthsAgoLabel.text = "1 month ago"
        } else if index > 1{
            monthsAgoLabel.text = "\(index) months ago"
        } else {
            monthsAgoLabel.text = "Just invested"
        }
    }
}
