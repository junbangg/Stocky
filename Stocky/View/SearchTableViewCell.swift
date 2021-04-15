//
//  SearchTableViewCell.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//

import UIKit

/// Custom Tableview cell for Search Tableview
class SearchTableViewCell : UITableViewCell {
    
    @IBOutlet weak var assetNameLabel : UILabel!
    @IBOutlet weak var assetSymbolLabel : UILabel!
    @IBOutlet weak var assetTypeLabel : UILabel!
    
    /// Function to configure custom cell
    /// - Parameter searchResult: SearchResult that contains data to display search results
    func configure(with searchResult: SearchResult) {
        assetNameLabel.text = searchResult.name
        assetSymbolLabel.text = searchResult.symbol
        assetTypeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }
    
}
