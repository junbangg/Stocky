//
//  CalculatorTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//

// * Note prepareforsegue and performs segue
import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var initialInvestmentAmountTextField : UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField : UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var symbolLabel : UILabel!
    @IBOutlet weak var assetLabel : UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel : UILabel!
    @IBOutlet weak var dateSlider : UISlider!
    
    var asset : Asset?
    
    @Published var initialDateOfInvestmentIndex : Int?
    
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        observeForm()
        setupDateSlider()
        
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
    
    private func setupDateSlider() {
        if let count = asset?.timeSeries.getMonthData().count {
            dateSlider.maximumValue = count.floatValue
        }
    }
    
    private func observeForm() {
        $initialDateOfInvestmentIndex.sink { [weak self] (index) in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            if let dateString = self?.asset?.timeSeries.getMonthData()[index].date.MMYYFormat {
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subscribers)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection",
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeSeries = sender as? TimeSeries {
            dateSelectionTableViewController.timeSeries = timeSeries
            dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(index: index)
            }
        }
        
    }
    
    private func handleDateSelection(index : Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        navigationController?.popViewController(animated: true)
        if let monthDatas = asset?.timeSeries.getMonthData() {
            initialDateOfInvestmentIndex = index
            let monthData = monthDatas[index]
            let dateString = monthData.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
    
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
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
