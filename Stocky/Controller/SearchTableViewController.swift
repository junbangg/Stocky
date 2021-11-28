//
//  ViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/13.
//

import UIKit
import Combine
/// Table View View Controller for Search
final class SearchTableViewController: UITableViewController, UIAnimatable {
    /**
     enumeration to divide View stages.. used to distinguish between when a search has been conducted or not
        - greeting : before the user selects search bar
        - search : after the user selects search bar
     */
    private enum Stage {
        case greeting
        case search
    }
    // MARK: - UISearchController
    //code to ensure that the app compiles at all times
    /// Instance of UISearchController used to handle users search
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "e.g. Apple, AAPL"
        //        searchController.searchBar.placeholder = "회사 이름 또는 종목코드를 검색하세요"
        searchController.searchBar.autocapitalizationType = .allCharacters
        return searchController
    }()
    /// Instance of APIService for networking with API
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    /// Search results returned from API
    private var searchResults: SearchResults?
    /// Property used to keep track of view stage
    @Published private var stage: Stage = .greeting
    /// searchQuery is kept track of by Published
    @Published var searchQuery = String()
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeInputs()
    }
    //MARK: - Navigation Bar
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
    }
    //MARK: - Table View methods
    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
    }
    /// Returns number of rows to configure in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    /// Create cell configured with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        return cell
    }
    /// Cell Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = self.searchResults {
            /// searchResults.items =  [SearchResult]
            let searchResult = searchResults.items[indexPath.item]
            let symbol = searchResult.symbol
            handleSelection(for: symbol, searchResult: searchResult)
        }
        /// Deselects row after handling is taken care of
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - observeForm Method
    /// Function that observes the UI for changes in data.. namely the Search query provided by the user
    private func observeInputs() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                guard !searchQuery.isEmpty else {return}
                showLoadingAnimation()
                self.apiService.fetchPreviewData(with: searchQuery).sink { (completion) in
                    dismissLoadingAnimation()
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] (searchResults) in
                    self?.searchResults = searchResults
                    self?.tableView.reloadData()
                    self?.tableView.isScrollEnabled = true
                }.store(in: &self.subscribers)
                
            }.store(in: &subscribers)
        
        $stage.sink { [unowned self] (mode) in
            switch mode {
            case .greeting:
                self.tableView.backgroundView = WelcomeView()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    //MARK: - handleSelection Method
    /// Function that handles cell selection event. This occurs when cell is selected by user
    /// - Parameters:
    ///   - symbol: NASDAQ code to search
    ///   - searchResult: SearchResult with data to present in table view
    private func handleSelection(for symbol: String, searchResult: SearchResult) {
        showLoadingAnimation()
        apiService.fetchTimeSeriesData(with: symbol).sink { [weak self] (completion) in
            self?.dismissLoadingAnimation()
            switch completion{
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] (timeSeries) in
            self?.dismissLoadingAnimation()
            /// Creates an Asset instance
            let asset = Asset(searchResult: searchResult , timeSeries: timeSeries)
            /// go to calculator view
            self?.performSegue(withIdentifier: "showCalculator", sender: asset)
            self?.searchController.searchBar.text = nil
        }.store(in: &subscribers)
    }
    // MARK: - Segue -> CalculatorTableView
    /// Segue function to navigate to CalculatorTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator",
           let destination = segue.destination as? CalculatorTableViewController,
           let asset = sender as? Asset {
            destination.asset = asset
        }
    }
}
//MARK: - Extensions
/// Extensions for SearchTableViewController
/// Conforms to
///     - UISearchResultsUpdating
///     - UISearchControllerDelegate
extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    /// updates the searchQuery Publisher
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery
    }
    /// when search is initiated by user
    func willPresentSearchController(_ searchController: UISearchController) {
        stage = .search
    }
}
