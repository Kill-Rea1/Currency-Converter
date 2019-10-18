//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 06/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

struct CurrencyError {
    let description: String
    var localizedDesc: String {
        return NSLocalizedString(description, comment: "")
    }
}

protocol CurrencyServiceProtocol: class {
    var currencies: [Currency] { get set }
    var currencyNames: [String] { get set }
    var inputValue: String { get set }
    var outputValue: Double { get }
    var inputCurrency: Currency { set get }
    var outputCurrency: Currency { set get }
    func saveAllCurrencies(with dict: [String: Any], completion: @escaping (CurrencyError?) -> ())
    func sortAndUpdateCurrentCurrencies()
    func saveOutputCurrencyRatio(with dict: [String: Any], completion: @escaping (CurrencyError?) -> ())
}

class CurrencyService: CurrencyServiceProtocol {
    
    private let storageService: StorageServiceProtocol = StorageService()
    var currencies: [Currency] = []
    var currencyNames: [String] = []
    
    init() {
        inputValue = storageService.savedInputValue() ?? "0"
        inputCurrency = storageService.savedInputCurrency() ?? Currency.defaultCurrency1()
        outputCurrency = storageService.savedOutputCurrency() ?? Currency.defaultCurrency2()
    }
    
    // MARK:- CurrencyServiceProtocol
    
    var inputValue: String {
        didSet {
            if (oldValue != inputValue) {
                storageService.saveInputValue(with: inputValue)
            }
        }
    }
    
    var outputValue: Double {
        get {
            guard var value = Double(inputValue) else { return 0.0 }
            value *= outputCurrency.ratio
            return value
        }
    }
    var inputCurrency: Currency {
        didSet {
            if (oldValue != inputCurrency) {
                storageService.saveInputCurrency(with: inputCurrency)
            }
        }
    }
    var outputCurrency: Currency {
        didSet {
            if (oldValue != outputCurrency) {
                storageService.saveOutputCurrency(with: outputCurrency)
            }
        }
    }
    
    func saveAllCurrencies(with dict: [String : Any], completion: @escaping (CurrencyError?) -> ()) {
        currencies = []
        currencyNames = []
        
        if let dictResults = dict["results"] as! [String: [String: String]]? {
            if dictResults.count > 0 {
                for (_, value) in dictResults {
                    if let fullName = value["currencyName"], let shortName = value["id"] {
                        let currency = Currency(fullName: fullName, shortName: shortName, ratio: 1, index: 0)
                        currencies.append(currency)
                    }
                }
                completion(nil)
                return
            }
        }
        completion(CurrencyError(description: "Currencies' data format is wrong"))
    }
    
    func sortAndUpdateCurrentCurrencies() {
        if currencies.count > 0 {
            currencies.sort {
                $0.shortName < $1.shortName
            }
            
            var index = 0
            var inputCurrencyUpdated = false
            var outputCurrencyUpdated = false
            
            for currency in currencies {
                let name = "\(currency.shortName) : \(currency.fullName)"
                currencyNames.append(name)
                currency.index = index
                
                if inputCurrency.shortName == currency.shortName {
                    inputCurrency = currency
                    inputCurrencyUpdated = true
                }
                if outputCurrency.shortName == currency.shortName {
                    outputCurrency = currency
                    outputCurrencyUpdated = true
                }
                index += 1
            }
            
            if !inputCurrencyUpdated {
                inputCurrency = currencies.first!
            }
            if !outputCurrencyUpdated {
                outputCurrency = currencies.first!
            }
        }
    }
    
    func saveOutputCurrencyRatio(with dict: [String : Any], completion: @escaping (CurrencyError?) -> ()) {
        let key = "\(inputCurrency.shortName)_\(outputCurrency.shortName)"
        if let dictValue = dict[key] as! [String: Double]? {
            if dictValue.count > 0 {
                if let value = dictValue["val"] {
                    outputCurrency.ratio = value
                    storageService.saveOutputCurrency(with: outputCurrency)
                    completion(nil)
                    return
                }
            }
        }
        completion(CurrencyError(description: "Error in saving ratio for currency"))
    }
}
