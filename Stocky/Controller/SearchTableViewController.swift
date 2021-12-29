//
//  ViewController.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/13.
//

import UIKit
import Combine

final class SearchTableViewController: UITableViewController, UIAnimatable {
    //MARK: - 중첩 타입
    private enum Stage {
        case greeting
        case search
    }
    
    private enum UIStrings: String, CustomStringConvertible {
        case searchBarPlaceholder
        case search
        
        var description: String {
            switch self {
            case .searchBarPlaceholder:
                return "e.g. Apple, AAPL"
            case .search:
                return "검색"
            }
        }
    }
    
    private enum SegueIdentifiers: String, CustomStringConvertible {
        case showCalculator
        
        var description: String {
            switch self {
            case .showCalculator:
                return "showCalculator"
            }
        }
    }
    
    // MARK: - 프로퍼티
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "\(UIStrings.searchBarPlaceholder)"
        searchController.searchBar.autocapitalizationType = .allCharacters
        
        return searchController
    }()
    
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    @Published private var stage: Stage = .greeting
    @Published var searchQuery = String()
    
    //MARK: - 생명주기 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeInputs()
    }
}

//MARK: - UI 메서드

extension SearchTableViewController {
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "\(UIStrings.search)"
    }
}

//MARK: - TableView 메서드

extension SearchTableViewController {
    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.item]
            let symbol = searchResult.symbol
            handleSelection(for: symbol, searchResult: searchResult)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - 메서드

extension SearchTableViewController {
    private func observeInputs() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                guard !searchQuery.isEmpty else {
                    return
                }
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
            let asset = Asset(searchResult: searchResult , timeSeries: timeSeries)
            //            self?.performSegue(withIdentifier: "\(SegueIdentifiers.showCalculator)", sender: asset)
            guard let viewController = self?.storyboard?.instantiateViewController(identifier: "CalculatorTableViewController", creator: { coder in
                CalculatorTableViewController(asset: asset, coder: coder)
            }) else {
                fatalError("Failed to create CalculatorTableViewVC")
            }
            self?.navigationController?.pushViewController(viewController, animated: true)
            self?.searchController.searchBar.text = nil
        }.store(in: &subscribers)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "\(SegueIdentifiers.showCalculator)",
    //           var destination = segue.destination as? CalculatorTableViewController,
    //           let asset = sender as? Asset {
    ////            destination.asset = asset
    ////            destination.setAsset(with: asset)
    //            destination = CalculatorTableViewController(asset: asset)
    //        }
    //    }
}

//MARK: - 프로토콜 Conformance

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              !searchQuery.isEmpty else {
            return
        }
        self.searchQuery = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        stage = .search
    }
}
