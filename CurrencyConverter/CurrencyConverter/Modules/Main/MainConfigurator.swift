//
//  MainConfigurator.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 05/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import UIKit

protocol MainConfiguratorProtocol: class {
    func configure(with viewController: MainViewController)
}

class MainConfigurator: MainConfiguratorProtocol {
    func configure(with viewController: MainViewController) {
        let presenter = MainPresenter(view: viewController)
        let interactor = MainInteractor(presenter: presenter)
        let router = MainRouter(viewController: viewController)
        
        viewController.presenter = presenter
        viewController.keyboardView.delegate = presenter
        viewController.inputCurrencyView.delegate = presenter
        viewController.outputCurrencyView.delegate = presenter
        
        presenter.keyboardView = viewController.keyboardView
        presenter.inputCurrencyView = viewController.inputCurrencyView
        presenter.outputCurrencyView = viewController.outputCurrencyView
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
