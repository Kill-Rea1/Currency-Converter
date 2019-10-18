//
//  CurrenciesPresenter.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 07/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol CurrenciesModuleDelegate: class {
    func didSelect(index: Int)
}

protocol CurrenciesPresenterProtocol: class {
    var router: CurrenciesRouterProtocol! { set get }
    var numberOfCurrencies: Int! { get }
    var title: String! { set get }
    var isSearching: Bool! { set get }
    var delegate: CurrenciesModuleDelegate? { set get }
    func closeButtonTapped()
    func didSelectRowAt(indexPath: IndexPath)
    func getCurrency(withIndex: Int) -> Currency
    func searchValueChanged(to text: String)
}

class CurrenciesPresenter: CurrenciesPresenterProtocol {
    
    weak var view: CurrenciesViewProtocol?
    var interactor: CurrenciesInteractorProtocol!
    weak var delegate: CurrenciesModuleDelegate?
    
    required init(view: CurrenciesViewProtocol) {
        self.view = view
    }
    
    // MARK:- CurrenciesPresenterProtocol methods
    var isSearching: Bool! = false {
        didSet {
            interactor.isSearching = isSearching
        }
    }
    
    var numberOfCurrencies: Int! {
        get {
            return interactor.numberOfCurrencies
        }
    }
    
    var title: String! {
        didSet {
            view?.setTitle(with: title)
        }
    }
    
    var router: CurrenciesRouterProtocol!
    
    func getCurrency(withIndex: Int) -> Currency {
        return interactor.getCurrency(withIndex: withIndex)
    }
    
    func closeButtonTapped() {
        router.closeCurrentViewController()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let currency = interactor.getCurrency(withIndex: indexPath.row)
        router.closeCurrentViewController()
        delegate?.didSelect(index: currency.index)
    }
    
    func searchValueChanged(to text: String) {
        interactor.getFilteredCurrencies(with: text)
    }
}
