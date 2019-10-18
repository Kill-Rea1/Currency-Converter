//
//  CurrenciesConfigurator.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 07/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import UIKit

protocol CurrenciesConfiguratorProtocol: class {
    func configure(with viewController: CurrenciesViewController)
}

class CurrenciesConfigurator: CurrenciesConfiguratorProtocol {
    func configure(with viewController: CurrenciesViewController) {
        let presenter = CurrenciesPresenter(view: viewController)
        let interactor = CurrenciesInteractor(presenter: presenter)
        let router = CurrenciesRouter(viewController: viewController)
        
        viewController.presenter = presenter
        interactor.currencyService = viewController.currencyService ?? nil
        presenter.interactor = interactor
        presenter.delegate = viewController.delegate
        presenter.title = viewController.navigationTitle
        presenter.router = router
    }
}
