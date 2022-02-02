//
//  DateSelectionTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/04.
//

import UIKit

// MARK: - DateSelectionDelegate

protocol DateSelectionDelegate: AnyObject {
    func reloadChart()
}

final class DateSelectionTableViewController: UITableViewController {
    //MARK: -  Properties
    
    weak var delegate: DateSelectionDelegate?
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.reloadChart()
    }
    
    // MARK: - Internal Methods
    
    func setTimeSeries(to timeSeries: TimeSeries) {
        self.timeSeries = timeSeries
    }
    
    func setDelegate(to viewController: DateSelectionDelegate) {
        self.delegate = viewController
    }
    
    func setSelectedIndex(to index: Int) {
        self.selectedIndex = index
    }
    
    func setDidSelectDate(to handler: @escaping (Int) -> Void) {
        self.didSelectDate = handler
    }
}

//MARK: - Private Methods

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
        let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectionTableViewCell.identifier, for: indexPath) as! DateSelectionTableViewCell
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

final class DateSelectionTableViewCell: UITableViewCell {
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

// MARK: - IdentifiableView

extension DateSelectionTableViewCell: IdentifiableView {}
