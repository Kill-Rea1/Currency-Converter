//
//  CurrenciesInteractor.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 07/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol CurrenciesInteractorProtocol: class {
    var currencies: [Currency]! { get }
    var isSearching: Bool! { get set }
    var numberOfCurrencies: Int! { get }
    func getCurrency(withIndex index: Int) -> Currency
    func getFilteredCurrencies(with text: String)
}

class CurrenciesInteractor: CurrenciesInteractorProtocol {
    func getFilteredCurrencies(with text: String) {
        filterCurrencies = currencies
        if text != "" {
            filterCurrencies = filterCurrencies?.filter({ (currency) -> Bool in
            return currency.shortName.range(of: text, options: .caseInsensitive) != nil || currency.fullName.range(of: text, options: .caseInsensitive) != nil
        })
        }
    }
    
    var isSearching: Bool! = false
    
    lazy var filterCurrencies = currencies
    
    weak var currencyService: CurrencyServiceProtocol?
    let serverService: ServerServiceProtocol = ServerService()
    
    weak var presenter: CurrenciesPresenterProtocol?
    
    required init(presenter: CurrenciesPresenterProtocol) {
        self.presenter = presenter
    }
    
    var currencies: [Currency]! {
        get {
            return currencyService?.currencies
        }
    }
    
    var numberOfCurrencies: Int! {
        get {
            if isSearching {
                return filterCurrencies?.count
            }
            return currencies.count
        }
    }
    
    func getCurrencyNames() -> [String] {
        return currencyService?.currencyNames ?? []
    }
    
    func getCurrency(withIndex index: Int) -> Currency {
        if isSearching {
            return filterCurrencies?[index] ?? Currency.defaultCurrency1()
        }
        return currencies[index]
    }
}
