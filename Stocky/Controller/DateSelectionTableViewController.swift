//
//  DateSelectionTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/04.
//

import UIKit

// MARK: - [Protocol] DateSelectionDelegate

protocol DateSelectionDelegate: AnyObject {
    func reloadChart()
}

// MARK: - [Class] DateSelectionTableViewController

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
