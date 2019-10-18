//
//  MainPresenter.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 05/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol MainPresenterProtocol: class {
    var interactor: MainInteractorProtocol! { set get }
    var router: MainRouterProtocol! { set get }
    func configureView()
    func updateOutputValue()
    func updateInputValue()
    func inputCurrencyNameUpdated()
    func outputCurrencyNameUpdated()
    func swapButtonTapped()
}

class MainPresenter: MainPresenterProtocol, KeyboardViewDelegate, CurrencyViewDelegate, CurrenciesModuleDelegate {
    
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol!
    weak var keyboardView: KeyboardViewProtocol?
    weak var inputCurrencyView: CurrencyViewProtocol?
    weak var outputCurrencyView: CurrencyViewProtocol?
    let inputCurrencyTitle = "Choose input currency"
    let outputCurrencyTitle = "Choose output currency"
    
    var inputValue: String! {
        set {
            if let value = newValue {
                interactor.inputValue = value
            }
        }
        get {
            return interactor.inputValue
        }
    }
    
    var outputValue: String? {
        get {
            var value = interactor.outputValue
            if value.hasSuffix(".0") {
                value.removeLast(2)
            }
            return value
        }
    }
    
    var inputCurrencyShortName: String {
        get {
            return interactor.inputCurrencyShortName
        }
    }
    
    var outupCurrencyShortName: String {
        get {
            interactor.outputCurrencyShortName
        }
    }
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    private func updateValues() {
        view?.setInputValue(with: inputValue)
        view?.setOutputValue(with: outputValue)
    }
    
    func swapButtonTapped() {
        interactor.swapCurrencies()
    }
    
    // MARK:- MainPresenterProtocol methods
    
    var router: MainRouterProtocol!
    
    func updateInputValue() {
        view?.setInputValue(with: inputValue)
    }
    
    func updateOutputValue() {
        updateValues()
    }
    
    func configureView() {
        inputCurrencyView?.currencyShortName = inputCurrencyShortName
        inputCurrencyView?.currencyValue = inputValue
        inputCurrencyView?.isFlipped = false
        outputCurrencyView?.currencyShortName = outupCurrencyShortName
        outputCurrencyView?.currencyValue = outputValue
        outputCurrencyView?.isFlipped = true
        view?.configureInputCurrencyView()
        view?.configureSwapButton()
        view?.configureOutputCurrencyView()
        view?.configureKeyboardView()
        view?.setInputValue(with: inputValue)
        view?.setInputCurrencyShortName(with: inputCurrencyShortName)
        view?.setOutputValue(with: outputValue)
        view?.setOutputCurrencyShortName(with: outupCurrencyShortName)
        keyboardView?.arrayNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        keyboardView?.commaImageName = "comma"
        keyboardView?.zeroNumber = 0
        keyboardView?.deleteImageName = "delete"
        keyboardView?.setupViews()
        interactor.getAllCurrencies()
    }
    
    func inputCurrencyNameUpdated() {
        view?.setInputCurrencyShortName(with: inputCurrencyShortName)
    }
    
    func outputCurrencyNameUpdated() {
        view?.setOutputCurrencyShortName(with: outupCurrencyShortName)
    }
    
    // MARK:- KeyboardViewDelegate methods
    
    func numberButtonTapped(number: Int) {
        inputValue += "\(number)"
        updateOutputValue()
    }
    
    func deleteButtonTapped() {
        if inputValue.count == 0 {
            return
        }
        inputValue.removeLast()
        updateOutputValue()
    }
    
    func commaButtonTapped() {
        inputValue += "."
        updateOutputValue()
    }
    
    func clearAll() {
        inputValue = ""
        updateOutputValue()
    }
    
    
    // MARK:- CurrencyViewDelegate methods
    
    func didCurrencyChangeButtonTapped(with tag: Int) {
        if tag == 0 {
            interactor.inputCurrencyChanging()
            router.showCurrenciesController(title: inputCurrencyTitle, delegate: self, currencyService: interactor.currencyService)
        } else {
            interactor.outputCurrencyChanging()
            router.showCurrenciesController(title: outputCurrencyTitle, delegate: self, currencyService: interactor.currencyService)
        }
    }
    
    // MARK:- CurrenciesModuleDelegate methods
    
    func didSelect(index: Int) {
        interactor.currencyChanged(to: index)
    }
}
