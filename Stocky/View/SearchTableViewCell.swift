//
//  SearchTableViewCell.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var assetSymbolLabel: UILabel!
    @IBOutlet weak var assetTypeLabel: UILabel!
    
    // MARK: - Configuration Methods
    
    func configure(with searchResult: SearchResult) {
        assetNameLabel.text = searchResult.name
        assetSymbolLabel.text = searchResult.symbol
        assetTypeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }
}

// MARK: - IdentifiableView

extension SearchTableViewCell: IdentifiableView {}
