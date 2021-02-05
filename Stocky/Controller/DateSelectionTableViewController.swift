//
//  DateSelectionTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/04.
//

import UIKit

class DateSelectionTableViewController : UITableViewController {
    
    
    var timeSeries : TimeSeries?
    private var monthDatas : [MonthData] = []
    
    var didSelectDate: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViews()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Select Date"
    }
    
    private func setupTableViews() {
        monthDatas = timeSeries?.getMonthData() ?? []
    }
}

extension DateSelectionTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthDatas.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! DateSelectionTableViewCell
        let monthData = monthDatas[indexPath.item]
        let index = indexPath.item
        cell.configure(with: monthData, with: index)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class DateSelectionTableViewCell : UITableViewCell {
    
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var monthsAgoLabel : UILabel!
    
    func configure(with monthData: MonthData, with index: Int) {
        
        monthLabel.text = monthData.date.MMYYFormat
        
        if index == 1 {
            monthsAgoLabel.text = "1 month ago"
        } else if index > 1{
            monthsAgoLabel.text = "\(index) months ago"
        } else {
            monthsAgoLabel.text = "Just invested"
        }
    }
}
