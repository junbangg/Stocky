//
//  CalculatorTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//


import UIKit
import Combine
import Charts

class CalculatorTableViewController: UITableViewController {
    
    enum Segue {
        static let showDataSelection = "showDateSelection"
        static let sendChartData = "sendChartData"
    }
    
    //Labels
    @IBOutlet weak var currentValueLabel : UILabel!
    @IBOutlet weak var investmentAmountLabel : UILabel!
    @IBOutlet weak var gainLabel : UILabel!
    @IBOutlet weak var yieldLabel : UILabel!
    @IBOutlet weak var annualReturnLabel : UILabel!
    @IBOutlet weak var latestSharePrice : UILabel!
    
    @IBOutlet weak var initialInvestmentAmountTextField : UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField : UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
//    @IBOutlet weak var symbolLabel : UILabel!
    @IBOutlet weak var assetLabel : UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel : UILabel!
    @IBOutlet weak var dateSlider : UISlider!
    
    var asset : Asset?
    
    @Published var initialDateOfInvestmentIndex : Int?
    @Published var initialInvestmentAmount : Int?
    @Published var monthlyDollarCostAveragingAmount : Int?
    //    @Published var closingPrices :
    private var dcaService = DCAService()
    private var subscribers = Set<AnyCancellable>()
    private let calculatorPresenter = CalculatorPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        observeForm()
        setupDateSlider()
        resetViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInvestmentAmountTextField.becomeFirstResponder()
    }
    
    private func setupViews() {
        navigationItem.title = asset?.searchResult.name
//        symbolLabel.text = asset?.searchResult.symbol
        assetLabel.text = asset?.searchResult.symbol
//        assetLabel.textColor = .themeRedShade
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency 
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addBrackets()
        }
        latestSharePrice.text = asset?.timeSeries.getMonthData(dateReverseSort: true).first?.adjustedClose.currencyFormatter
        
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    
    private func setupDateSlider() {
        if let count = asset?.timeSeries.getMonthData(dateReverseSort: true).count {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    
    private func observeForm() {
        $initialDateOfInvestmentIndex.sink { [weak self] (index) in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            if let dateString = self?.asset?.timeSeries.getMonthData(dateReverseSort: true)[index].date.MMYYFormat {
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            self?.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDollarCostAveragingTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            self?.monthlyDollarCostAveragingAmount = Int(text) ?? 0
            
        }.store(in: &subscribers)
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveragingAmount, $initialDateOfInvestmentIndex)
            .sink { [weak self] (initialInvestmentAmount, monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex) in
                
                guard let initialInvestmentAmount = initialInvestmentAmount,
                      let monthlyDollarCostAveragingAmount = monthlyDollarCostAveragingAmount,
                      let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex,
                      let asset = self?.asset else { return }
                
                //***** since there is a weak self
                guard let this = self else { return }
                
                let result = this.dcaService.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount.doubleValue, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount.doubleValue, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
                
                let presentation = this.calculatorPresenter.getPresentation(result: result)
                
                this.currentValueLabel.backgroundColor = presentation.currentValueLabelBackgroundColor
                this.currentValueLabel.text = presentation.currentValue
                this.investmentAmountLabel.text = presentation.investmentAmount
                this.gainLabel.text = presentation.gain
                this.yieldLabel.text = presentation.yield
                this.yieldLabel.textColor = presentation.yieldLabelTextColor
                this.annualReturnLabel.text = presentation.annualReturn
                this.annualReturnLabel.textColor = presentation.annualReturnLabelTextColor
                this.latestSharePrice.text = presentation.latestSharePrice
                
            }
            .store(in: &subscribers)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showDataSelection,
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeSeries = sender as? TimeSeries {
            dateSelectionTableViewController.timeSeries = timeSeries
            dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(index: index)
            }
        }
        if segue.identifier == Segue.sendChartData,
           let dataChartViewController = segue.destination as? DataChartViewController {
            dataChartViewController.timeSeries = asset?.timeSeries
            dataChartViewController.selectedIndex = initialDateOfInvestmentIndex
        }
        
    }
    /// Function that handles the Date Selection sent over from DateSelectionTableViewController
    
    private func handleDateSelection(index : Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        navigationController?.popViewController(animated: true)
        if let monthDatas = asset?.timeSeries.getMonthData(dateReverseSort: true) {
            initialDateOfInvestmentIndex = index
            let monthData = monthDatas[index]
            let dateString = monthData.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
    
    private func resetViews() {
        currentValueLabel.text = "0.00"
        investmentAmountLabel.text = "0.00"
        gainLabel.text = "-"
        yieldLabel.text = "-"
        annualReturnLabel.text = "-"
    }
    
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
//        performSegue(withIdentifier: Segue.sendChartData, sender: asset?.timeSeries)
    }
}

//showDateSelection
extension CalculatorTableViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: Segue.showDataSelection, sender: asset?.timeSeries)
//            performSegue(withIdentifier: Segue.sendChartData, sender: asset?.timeSeries)
            return false
        }
        return true
    }
}
