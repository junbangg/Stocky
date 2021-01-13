//
//  ViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/13.
//

import UIKit

class SearchTableViewController: UITableViewController {

    
    //code to ensure that the app compiles at all times
    private lazy var searchController : UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }


}

extension SearchTableViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
