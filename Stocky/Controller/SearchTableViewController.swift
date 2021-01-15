//
//  ViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/13.
//

import UIKit
import Combine

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
    
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    @Published var searchQuery = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        obvserveForm()
        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func obvserveForm() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                self.apiService.fetchSymbolsPublisher(key: searchQuery).sink { (completion) in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        break
                    }
                } receiveValue: { (searchResults) in
                    print(searchResults)
                }.store(in: &self.subscribers)

            }.store(in: &subscribers)
        
    }
    
//    private func performSearch() {
//        apiService.fetchSymbolsPublisher(key: "S&P500").sink { (completion) in
//            switch completion {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .finished: break
//            }
//        } receiveValue: { (searchResults) in
//            print(searchResults)
//        }.store(in: &subscribers)
//
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        return cell
    }

}

extension SearchTableViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        
        self.searchQuery = searchQuery
        
        
    }
}
