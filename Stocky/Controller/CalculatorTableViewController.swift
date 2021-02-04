//
//  CalculatorTableViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    
    
    @IBOutlet weak var symbolLabel : UILabel!
    @IBOutlet weak var assetLabel : UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel : UILabel!
    
    
    var asset : Asset?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency 
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addBrackets()
        }
        
    }
}
