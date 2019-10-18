//
//  CurrenciesViewController.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 07/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CurrenciesViewProtocol: class {
    var index: Int! { get set }
    var navigationTitle: String! { get set }
    var delegate: CurrenciesModuleDelegate? { get set }
    var currencyService: CurrencyServiceProtocol? { get set }
    func setTitle(with title: String)
}

class CurrenciesViewController: UITableViewController, CurrenciesViewProtocol, UISearchBarDelegate {
    
    init(title: String, delegate: CurrenciesModuleDelegate?, currencyService: CurrencyServiceProtocol) {
        super.init(style: .plain)
        self.navigationTitle = title
        self.delegate = delegate
        self.currencyService = currencyService
        configurator.configure(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cellId = "CurrencyCellId"
    var presenter: CurrenciesPresenterProtocol!
    let configurator: CurrenciesConfiguratorProtocol = CurrenciesConfigurator()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        view.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: cellId)
        searchBar()
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleClose))
    }
    
    func searchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.setDefaultSearchBar()
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK:- CurrenciesViewProtocol methods
    
    var index: Int!
    var navigationTitle: String!
    weak var delegate: CurrenciesModuleDelegate?
    weak var currencyService: CurrencyServiceProtocol?
    
    func setTitle(with title: String) {
        navigationItem.title = title
    }
    
    @objc
    private func handleClose() {
        presenter.closeButtonTapped()
    }
    
    // MARK:- UITableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCurrencies
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CurrencyTableViewCellProtocol
        cell.currency = presenter.getCurrency(withIndex: indexPath.row)
        return cell as! UITableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
    }
    
    // MARK:- UISearchBarDelegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        presenter.isSearching = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchValueChanged(to: searchText)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.isSearching = false
    }
}

extension UISearchBar {
    func setDefaultSearchBar() {
        self.tintColor = UIColor.white
        self.searchBarStyle = .prominent
        let searchBarTextField = self.value(forKey: "searchField") as! UITextField
        searchBarTextField.textColor = UIColor.white
        searchBarTextField.tintColor = UIColor.blue
        searchBarTextField.backgroundColor = .white
    }
}
