//
//  MainInteractor.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 06/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

enum CurrencyChangingMode {
    case inputCurrencyChanging
    case outputCurrencyChanging
}

protocol MainInteractorProtocol: class {
    var currencyService: CurrencyServiceProtocol { set get }
    var inputValue: String { get set }
    var outputValue: String { get }
    var inputCurrencyShortName: String { get }
    var outputCurrencyShortName: String { get }
    var inputCurrencyIndex: Int { get }
    var outputCurrencyIndex: Int { get }
    var outputCurrencyRatio: Double { get }
    func getAllCurrencies()
    func getCurrencyNames() -> [String]
    func inputCurrencyChanging()
    func outputCurrencyChanging()
    func currencyChanged(to selectedIndex: Int)
    func swapCurrencies()
}

class MainInteractor: MainInteractorProtocol {
    
    var currencyService: CurrencyServiceProtocol = CurrencyService()
    let serverService: ServerServiceProtocol = ServerService()
    var currencyChangingMode: CurrencyChangingMode?
    
    weak var presenter: MainPresenterProtocol?
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        getOutputCurrencyRatio(newCurrency: nil)
    }
    
    private func getOutputCurrencyRatio(newCurrency: Currency?) {
        
        var requestInputCurrencyShortName = inputCurrencyShortName
        var requestOutputCurrencyShortName = outputCurrencyShortName
        
        if let mode = currencyChangingMode, let newCurrency = newCurrency {
            switch mode {
            case .inputCurrencyChanging:
                requestInputCurrencyShortName = newCurrency.shortName
            case .outputCurrencyChanging:
                requestOutputCurrencyShortName = newCurrency.shortName
            }
        }
        
        serverService.getRatio(inputCurrencyShortName: requestInputCurrencyShortName, outputCurrencyShortName: requestOutputCurrencyShortName) { (dict, err) in
            if err != nil {
                return
            }
            
            guard let dict = dict else { return }
            if let mode = self.currencyChangingMode, let newCurrency = newCurrency {
                switch mode {
                case .inputCurrencyChanging:
                    self.currencyService.inputCurrency = newCurrency
                    self.presenter?.inputCurrencyNameUpdated()
                case .outputCurrencyChanging:
                    self.currencyService.outputCurrency = newCurrency
                    self.presenter?.outputCurrencyNameUpdated()
                }
            }
            
            self.currencyService.saveOutputCurrencyRatio(with: dict) { (err) in
                if let err = err {
                    print(err)
                    return
                }
                self.presenter?.updateOutputValue()
            }
        }
    }
    
    // MARK:- MainInteractorProtocol methods
    
    var inputCurrencyShortName: String {
        get {
            return currencyService.inputCurrency.shortName
        }
    }
    
    var outputCurrencyShortName: String {
        get {
            return currencyService.outputCurrency.shortName
        }
    }
    
    var inputCurrencyIndex: Int {
        get {
            return currencyService.inputCurrency.index
        }
    }
    
    var outputCurrencyIndex: Int {
        get {
            return currencyService.outputCurrency.index
        }
    }
    
    var outputCurrencyRatio: Double {
        get {
            return currencyService.outputCurrency.ratio
        }
    }
    
    var inputValue: String {
        set {
            currencyService.inputValue = newValue
        }
        get {
            let value = currencyService.inputValue
            return String(value)
        }
    }
    
    var outputValue: String {
        get {
            let value = currencyService.outputValue
            return String(value)
        }
    }
    
    func inputCurrencyChanging() {
        currencyChangingMode = .inputCurrencyChanging
    }
    
    func outputCurrencyChanging() {
        currencyChangingMode = .outputCurrencyChanging
    }
    
    func currencyChanged(to selectedIndex: Int) {
        if currencyService.currencies.count > selectedIndex {
            
            let newCurrency = currencyService.currencies[selectedIndex]
            getOutputCurrencyRatio(newCurrency: newCurrency)
        }
    }
    
    func getAllCurrencies() {
        serverService.getAllCurrencies { (dict, err) in
            if err != nil {
                return
            }
            
            guard let dict = dict else { return }
            self.currencyService.saveAllCurrencies(with: dict) { (err) in
                if let err = err {
                    print(err)
                    return
                }
                self.currencyService.sortAndUpdateCurrentCurrencies()
                self.getOutputCurrencyRatio(newCurrency: nil)
            }
        }
    }
    
    func getCurrencyNames() -> [String] {
        return currencyService.currencyNames
    }
    
    func swapCurrencies() {
        let newOutputCurrencyShortName = inputCurrencyShortName
        let newInputCurrencyShortName = outputCurrencyShortName
        let newInputCurrency = currencyService.outputCurrency
        let newOutputCurrency = currencyService.inputCurrency
        serverService.getRatio(inputCurrencyShortName: newInputCurrencyShortName, outputCurrencyShortName: newOutputCurrencyShortName) { (dict, err) in
            if err != nil {
                return
            }
            
            guard let dict = dict else { return }
            self.currencyService.inputCurrency = newInputCurrency
            self.presenter?.inputCurrencyNameUpdated()
            self.currencyService.outputCurrency = newOutputCurrency
            self.presenter?.outputCurrencyNameUpdated()
            self.currencyService.saveOutputCurrencyRatio(with: dict) { (err) in
                if let err = err {
                    print(err)
                    return
                }
                self.presenter?.updateOutputValue()
            }
        }
    }
}
