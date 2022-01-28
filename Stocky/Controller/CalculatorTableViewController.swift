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
final class CalculatorTableViewController: UITableViewController {
    //MARK: - Nested Types
    
    private enum Segue {
        static let showDataSelection = "showDateSelection"
        static let sendChartData = "sendChartData"
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investmentAmountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    @IBOutlet weak var latestSharePrice: UILabel!
    @IBOutlet weak var dataChartView: UIView!
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var dateSlider: UISlider!
    
    //MARK: - Properties
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.noDataText = ""
        chartView.backgroundColor = .themeGreenShade
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 15)
        yAxis.setLabelCount(4, force: false)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .white
        
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 13)
        chartView.xAxis.valueFormatter = DateAxisValueFormatter()
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisLineColor = .white
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    
    var asset: Asset!
    @Published var initialDateOfInvestmentIndex: Int?
    @Published var initialInvestmentAmount: Int?
    @Published var monthlyDollarCostAveragingAmount: Int?
    private var subscribers = Set<AnyCancellable>()
    
    //MARK: - Initializer
    
    init?(asset: Asset, coder: NSCoder) {
        self.asset = asset
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Class does not support nscoder")
    }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupTextFields()
        observeInputs()
        setupDateSlider()
        resetLabels()
        hideKeyboardOnTap()
        setupDefaultChartUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if initialInvestmentAmountTextField.text == "" {
            initialInvestmentAmountTextField.becomeFirstResponder()
        }
    }
}

//MARK: - IBActions

extension CalculatorTableViewController {
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
    }
}

//MARK: - UI Methods

extension CalculatorTableViewController {
    private func setupDefaultChartUI() {
        dataChartView.backgroundColor = .themeGreenShade
    }
    
    private func loadChartUI() {
        dataChartView.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: dataChartView.topAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: dataChartView.trailingAnchor).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: dataChartView.leadingAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: dataChartView.bottomAnchor).isActive = true
    }
    
    private func setupLabels() {
        navigationItem.title = asset?.searchResult.name
        assetLabel.text = asset?.searchResult.symbol
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addParentheses()
        }
        
        latestSharePrice.text = asset?.timeSeries.getMonthData(isReversed: true).first?.adjustedClose.currencyFormat
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    
    private func setupDateSlider() {
        if let count = asset?.timeSeries.getMonthData(isReversed: true).count {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    
    private func resetLabels() {
        currentValueLabel.text = "0.00"
        investmentAmountLabel.text = "0.00"
        gainLabel.text = "$0"
        yieldLabel.text = "0%"
        annualReturnLabel.text = "0%"
    }
}
    
// MARK: - Business Logic

extension CalculatorTableViewController {
    private func observeInputs() {
        $initialDateOfInvestmentIndex.sink { [weak self] (index) in
            guard let self = self,
                  let index = index else {
                return
            }
            self.dateSlider.value = index.floatValue
            guard let monthData = self.asset?.timeSeries.getMonthData(isReversed: true) else {
                return
            }
            let dateString = monthData[index].date.MMYYFormat
            self.initialDateOfInvestmentTextField.text = dateString
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField)
            .compactMap({ ($0.object as? UITextField)?.text })
            .sink { [weak self] (text) in
                self?.initialInvestmentAmount = Int(text) ?? 0
            }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDollarCostAveragingTextField)
            .compactMap({($0.object as? UITextField)?.text})
            .sink { [weak self] (text) in
                self?.monthlyDollarCostAveragingAmount = Int(text) ?? 0
            }.store(in: &subscribers)
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveragingAmount, $initialDateOfInvestmentIndex)
            .sink { [weak self] (initialInvestmentAmount, monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex) in
                guard let self = self else {
                    return
                }
                guard let initialInvestmentAmount = initialInvestmentAmount,
                      let monthlyDollarCostAveragingAmount = monthlyDollarCostAveragingAmount,
                      let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex,
                      let asset = self.asset else {
                    return
                }
                let dcaResult = self.calculateDCA(
                    asset,
                    initialInvestmentAmount.doubleValue,
                    monthlyDollarCostAveragingAmount.doubleValue,
                    initialDateOfInvestmentIndex
                )
                let presentation = self.getPresentation(result: dcaResult)
                self.currentValueLabel.backgroundColor = presentation.currentValueLabelBackgroundColor
                self.currentValueLabel.text = presentation.currentValue
                self.investmentAmountLabel.text = presentation.investmentAmount
                self.gainLabel.text = presentation.gain
                self.yieldLabel.text = presentation.yield
                self.yieldLabel.textColor = presentation.yieldLabelTextColor
                self.annualReturnLabel.text = presentation.annualReturn
                self.annualReturnLabel.textColor = presentation.annualReturnLabelTextColor
            }
            .store(in: &subscribers)
    }

    private func handleDateSelection(index: Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else {
            return
        }
        navigationController?.popViewController(animated: true)
        guard let monthDatas = asset?.timeSeries.getMonthData(isReversed: true) else {
            return
        }
        initialDateOfInvestmentIndex = index
        let monthData = monthDatas[index]
        let dateString = monthData.date.MMYYFormat
        initialDateOfInvestmentTextField.text = dateString
        
        loadChartUI()
        loadChartData(with: asset.timeSeries)
    }
    
    private func loadChartData(with timeSeries: TimeSeries) {
        let priceData = LineChartDataSet(entries: getData(of: timeSeries), label: "수정종가")
        priceData.mode = .cubicBezier
        priceData.circleRadius = 3
        priceData.lineWidth = 3
        priceData.setColor(.white)
        priceData.fill = Fill(color: .white)
        priceData.fillAlpha = 0.8
        priceData.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: priceData)
        lineChartView.data = data
    }
    
    /// Fetches data from timeSeries and configures to [ChartDataEntry]
    private func getData(of timeSeries: TimeSeries) -> [ChartDataEntry]{
        let monthData: [MonthData] = timeSeries.getMonthData(isReversed: false)
        var chartValues: [ChartDataEntry] = []
        var x = 0
        
        ///Working original code
        for data in monthData {
            let yData = data.adjustedClose
            let data = data.date
            let chartData = ChartDataEntry(x: x.doubleValue, y: yData, data: data)
            chartValues.append(chartData)
            x += 1
        }
        
        return chartValues
    }
}

//MARK: - Segue Methods

extension CalculatorTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showDataSelection,
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeSeries = sender as? TimeSeries {
            dateSelectionTableViewController.timeSeries = timeSeries
            dateSelectionTableViewController.delegate = self
            dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(index: index)
            }
        }
    }
}

// MARK: - DateSelectionDelegate

extension CalculatorTableViewController: DateSelectionDelegate {
    func reloadChart() {
        loadChartUI()
        loadChartData(with: asset.timeSeries)
    }
}

//MARK: - UITextFieldDelegate

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: Segue.showDataSelection, sender: asset?.timeSeries)
            return false
        }
        return true
    }
}

// MARK: - CalculatorUIPresentable

extension CalculatorTableViewController: CalculatorUIPresentable {}

// MARK: - DCAServicable

extension CalculatorTableViewController: DCAServicable {}

// MARK: - IdentifiableView

extension CalculatorTableViewController: IdentifiableView {}

//MARK: - Axis Formatter Class

//https://stackoverflow.com/questions/54915102/trying-to-enter-date-string-in-chartdataentry

fileprivate final class DateAxisValueFormatter: NSObject, IAxisValueFormatter {
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let secondsPerDay = 24.0 * 3600.0
        let date = Date(timeIntervalSince1970: value * secondsPerDay)
        
        return dateFormatter.string(from: date)
    }
}
