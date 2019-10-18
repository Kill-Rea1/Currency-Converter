//
//  MainRouter.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 05/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import UIKit

protocol MainRouterProtocol: class {
    func showCurrenciesController(title: String, delegate: CurrenciesModuleDelegate, currencyService: CurrencyServiceProtocol)
}

class MainRouter: MainRouterProtocol {
    weak var viewController: MainViewController?
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func showCurrenciesController(title: String, delegate: CurrenciesModuleDelegate, currencyService: CurrencyServiceProtocol) {
        let vc = CurrenciesViewController(title: title, delegate: delegate, currencyService: currencyService)
        let navController = CustomNavigationController(rootViewController: vc)
        viewController?.present(navController, animated: true)
    }
}
