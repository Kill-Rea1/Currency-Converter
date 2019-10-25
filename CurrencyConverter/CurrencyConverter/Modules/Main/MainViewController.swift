//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 05/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol MainViewProtocol: class {
    func configureSwapButton()
    func configureKeyboardView()
    func configureInputCurrencyView()
    func configureOutputCurrencyView()
    func setOutputValue(with value: String?)
    func setInputValue(with value: String?)
    func setInputCurrencyShortName(with shortName: String)
    func setOutputCurrencyShortName(with shortName: String)
}

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol!
    let configurator: MainConfiguratorProtocol! = MainConfigurator()
    var keyboardView: KeyboardView! = KeyboardView()
    var inputCurrencyView = CurrencyView(tag: 0)
    var outputCurrencyView = CurrencyView(tag: 1)
    var swapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "swap"), for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.tintColor = #colorLiteral(red: 0.5113930702, green: 0.399178654, blue: 0.9329522252, alpha: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .init(width: 4, height: 5)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSwapButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurator.configure(with: self)
        presenter.configureView()
        configureNavigation()
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Currency converter"
    }
    
    @objc
    private func handleSwapButtonTapped() {
        presenter.swapButtonTapped()
    }
    
    // MARK:- MainViewProtocol methods
    
    func configureSwapButton() {
        view.addSubview(swapButton)
        NSLayoutConstraint.activate([
            swapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swapButton.heightAnchor.constraint(equalToConstant: 50),
            swapButton.widthAnchor.constraint(equalToConstant: 50),
            swapButton.topAnchor.constraint(equalTo: inputCurrencyView.bottomAnchor)
        ])
    }
    
    func configureInputCurrencyView() {
        view.addSubview(inputCurrencyView)
        NSLayoutConstraint.activate([
            inputCurrencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputCurrencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputCurrencyView.heightAnchor.constraint(equalToConstant: 125),
            inputCurrencyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    func configureOutputCurrencyView() {
        view.addSubview(outputCurrencyView)
        NSLayoutConstraint.activate([
            outputCurrencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            outputCurrencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            outputCurrencyView.heightAnchor.constraint(equalToConstant: 125),
            outputCurrencyView.topAnchor.constraint(equalTo: swapButton.bottomAnchor)
        ])
    }
    
    func setOutputCurrencyShortName(with shortName: String) {
        DispatchQueue.main.async {
            self.outputCurrencyView.currencyShortName = shortName
        }
    }
    
    func setInputCurrencyShortName(with shortName: String) {
        DispatchQueue.main.async {
            self.inputCurrencyView.currencyShortName = shortName
        }
    }
    
    func setOutputValue(with value: String?) {
        DispatchQueue.main.async {
            self.outputCurrencyView.valueLabel.text = value
        }
    }
    
    func setInputValue(with value: String?) {
        DispatchQueue.main.async {
            self.inputCurrencyView.valueLabel.text = value
        }
    }
    
    func configureKeyboardView() {
        view.addSubview(keyboardView)
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            keyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            keyboardView.heightAnchor.constraint(lessThanOrEqualToConstant: 275)
        ])
        let topConstraint = keyboardView.topAnchor.constraint(equalTo: outputCurrencyView.bottomAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(999)
        topConstraint.isActive = true
    }
}
