//
//  CalculatorTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//
import UIKit
import Combine
import Charts

/// TODO : After user finished entering values, immediately change focus to the next input for better UX
class CalculatorTableViewController: UITableViewController {
    
    /// Segue identifiers
    enum Segue {
        static let showDataSelection = "showDateSelection"
        static let sendChartData = "sendChartData"
    }
    //MARK: - IBOutlets
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
    
    //MARK: - Publishers and properties for Data communication
    var asset : Asset?
    
    /// index of selected initial date month
    @Published var initialDateOfInvestmentIndex : Int?
    @Published var initialInvestmentAmount : Int?
    @Published var monthlyDollarCostAveragingAmount : Int?
    //    @Published var closingPrices :
    private var dcaService = DCAService()
    private var subscribers = Set<AnyCancellable>()
    private let calculatorPresenter = CalculatorPresenter()
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupTextFields()
        observeInputs()
        setupDateSlider()
        resetLabels()
    }
    
    //MARK: - viewDidAppear()
    /// Changes the focus to initialInvestmentAmountTextField so User can immediately start entering values (for better UX)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInvestmentAmountTextField.becomeFirstResponder()
    }
    //MARK: - setupViews()
    /// Sets labels
    private func setupLabels() {
        navigationItem.title = asset?.searchResult.name
        assetLabel.text = asset?.searchResult.symbol
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency 
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addParentheses()
        }
        latestSharePrice.text = asset?.timeSeries.getMonthData(dateReverseSort: true).first?.adjustedClose.currencyFormatter
    }
    //MARK: - Setup TextFields
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    //MARK: - Setup Date Slider
    /// Function to setup maximum value for date slider
    ///         - max is set to number of months in timeSeries data
    private func setupDateSlider() {
        if let count = asset?.timeSeries.getMonthData(dateReverseSort: true).count {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    //MARK: - Observe Form
    /// Function that observes the UI for changes in data
    private func observeInputs() {
        /// Attaches subscriber to initialDateOfInvestmentIndex Publisher
        $initialDateOfInvestmentIndex.sink { [weak self] (index) in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            if let dateString = self?.asset?.timeSeries.getMonthData(dateReverseSort: true)[index].date.MMYYFormat {
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subscribers)
        /// Publisher for initialInvestmentAmountTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField)
            .compactMap({ ($0.object as? UITextField)?.text })
            .sink { [weak self] (text) in
                self?.initialInvestmentAmount = Int(text) ?? 0
            }.store(in: &subscribers)
        /// Publisher for monthlyDollarCostAveragingTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDollarCostAveragingTextField)
            .compactMap({($0.object as? UITextField)?.text})
            .sink { [weak self] (text) in
                self?.monthlyDollarCostAveragingAmount = Int(text) ?? 0
                
            }.store(in: &subscribers)
        /// Combines last elements from 3 publishers
        /// ( initial investment + monthly dollar cost averaging amount + initial date of investment ) is used to calculate DCA
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveragingAmount, $initialDateOfInvestmentIndex)
            .sink { [weak self] (initialInvestmentAmount, monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex) in
                
                guard let initialInvestmentAmount = initialInvestmentAmount,
                      let monthlyDollarCostAveragingAmount = monthlyDollarCostAveragingAmount,
                      let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex,
                      let asset = self?.asset else { return }
                
                ///***** since there is a weak self
                guard let this = self else { return }
                /// Calculate DCA
                let result = this.dcaService.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount.doubleValue, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount.doubleValue, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
                
                let presentation = this.calculatorPresenter.getPresentation(result: result)
                /// Update UI
                this.currentValueLabel.backgroundColor = presentation.currentValueLabelBackgroundColor
                this.currentValueLabel.text = presentation.currentValue
                this.investmentAmountLabel.text = presentation.investmentAmount
                this.gainLabel.text = presentation.gain
                this.yieldLabel.text = presentation.yield
                this.yieldLabel.textColor = presentation.yieldLabelTextColor
                this.annualReturnLabel.text = presentation.annualReturn
                this.annualReturnLabel.textColor = presentation.annualReturnLabelTextColor
            }
            .store(in: &subscribers)
        
    }
    //MARK: - prepare for segue
    /// Segues for date selection and chart data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// sends time series data to get initial date of investment index
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
    //MARK: - Handle Date Selection
    /// Function that handles the Date Selection sent over from DateSelectionTableViewController
    private func handleDateSelection(index : Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        /// pops view controller when date is selected
        navigationController?.popViewController(animated: true)
        if let monthDatas = asset?.timeSeries.getMonthData(dateReverseSort: true) {
            initialDateOfInvestmentIndex = index
            let monthData = monthDatas[index]
            let dateString = monthData.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
    //MARK: - Reset Labels
    private func resetLabels() {
        currentValueLabel.text = "0.00"
        investmentAmountLabel.text = "0.00"
        gainLabel.text = "$0"
        yieldLabel.text = "0%"
        annualReturnLabel.text = "0%"
    }
    //MARK: - Date Slider Update
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
    }
}

//MARK: - Extensions
/// Conforms to
///     - UITextFieldDelegate
//showDateSelection
extension CalculatorTableViewController : UITextFieldDelegate {
    /// If user touches textfield -> Segue triggered
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: Segue.showDataSelection, sender: asset?.timeSeries)
            return false
        }
        return true
    }
}
