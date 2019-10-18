//
//  CurrenciesRouter.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 07/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import UIKit

protocol CurrenciesRouterProtocol: class {
    func closeCurrentViewController()}

class CurrenciesRouter: CurrenciesRouterProtocol {
    
    weak var viewController: CurrenciesViewController?
    
    init(viewController: CurrenciesViewController) {
        self.viewController = viewController
    }
    
    func closeCurrentViewController() {
        viewController?.dismiss(animated: true)
    }
}
