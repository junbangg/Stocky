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
    
    var asset : Asset?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetLabel.text = asset?.searchResult.name
        
    }
}
