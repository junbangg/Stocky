//
//  CalculatorTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//

// * Note prepareforsegue and performs segue
import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var initialInvestmentAmountTextField : UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField : UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var symbolLabel : UILabel!
    @IBOutlet weak var assetLabel : UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel : UILabel!
    
    
    var asset : Asset?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency 
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addBrackets()
        }
        
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection",
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeSeries = sender as? TimeSeries {
            dateSelectionTableViewController.timeSeries = timeSeries
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(index: index)
            }
        }
        
    }
    
    private func handleDateSelection(index : Int) {
        if let monthDatas = asset?.timeSeries.getMonthData() {
            let monthData = monthDatas[index]
            let dateString = monthData.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
}

//showDateSelection
extension CalculatorTableViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeries)
        }
        return false
    }
}
