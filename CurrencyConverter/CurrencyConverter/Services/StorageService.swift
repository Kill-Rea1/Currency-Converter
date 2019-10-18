//
//  StorageService.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 06/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol StorageServiceProtocol: class {
    func savedInputValue() -> String?
    func saveInputValue(with value: String?)
    func savedInputCurrency() -> Currency?
    func saveInputCurrency(with currency: Currency)
    func savedOutputCurrency() -> Currency?
    func saveOutputCurrency(with currency: Currency)
}

class StorageService: StorageServiceProtocol {
    
    private let kSavedInputValue = "savedInputValue"
    private let kSavedInputCurrency = "savedInputCurrency"
    private let kSavedOutputCurrency = "savedOutputCurrency"
    
    // MARK: - StorageServiceProtocol methods
    
    func savedInputValue() -> String? {
        if UserDefaults.standard.object(forKey: kSavedInputValue) != nil {
            return UserDefaults.standard.string(forKey: kSavedInputValue);
        }
        return nil
    }
    
    func saveInputValue(with value: String?) {
        if let newValue = value {
            UserDefaults.standard.set(newValue, forKey: kSavedInputValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func savedInputCurrency() -> Currency? {
        if let data = UserDefaults.standard.value(forKey:kSavedInputCurrency) as? Data {
            let currency = try? PropertyListDecoder().decode(Currency.self, from: data)
            return currency
        }
        return nil
    }
    
    func saveInputCurrency(with currency: Currency) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currency), forKey:kSavedInputCurrency)
        UserDefaults.standard.synchronize()
    }
    
    func savedOutputCurrency() -> Currency? {
        if let data = UserDefaults.standard.value(forKey:kSavedOutputCurrency) as? Data {
            let currency = try? PropertyListDecoder().decode(Currency.self, from: data)
            return currency
        }
        return nil
    }
    
    func saveOutputCurrency(with currency: Currency) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currency), forKey:kSavedOutputCurrency)
        UserDefaults.standard.synchronize()
    }
}
