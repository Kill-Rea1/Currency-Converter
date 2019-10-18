//
//  KeyboardView.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 06/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol KeyboardViewProtocol: class {
    var commaImageName: String! { set get }
    var arrayNumbers: [Int]! { set get }
    var deleteImageName: String! { set get }
    var zeroNumber: Int! { set get }
    func setupViews()
}

protocol KeyboardViewDelegate {
    func numberButtonTapped(number: Int)
    func deleteButtonTapped()
    func commaButtonTapped()
    func clearAll()
}
@IBDesignable
class KeyboardView: UIView, KeyboardViewProtocol {
    
    var buttonsArray: [UIView] = []
    var numbersAndImageNamesArray: [String] = []
    var delegate: KeyboardViewDelegate?
    
    
    private func createButton(with title: String? = nil, imageName: String? = nil, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        if let title = title {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 36)
            button.layer.cornerRadius = 8
            button.backgroundColor = .white
            button.setTitleColor(#colorLiteral(red: 0.3806797862, green: 0.4001729488, blue: 0.493964076, alpha: 1), for: .normal)
            button.addTarget(self, action: #selector(handleKeyboardButtonTapped), for: .touchUpInside)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = .init(width: 4, height: 5)
            button.layer.shadowRadius = 8
        } else {
            button.setImage(UIImage(named: imageName ?? "")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = #colorLiteral(red: 0.3806797862, green: 0.4001729488, blue: 0.493964076, alpha: 1)
            button.addTarget(self, action: #selector(handleImageButtonTapped), for: .touchUpInside)
            button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
        }
        button.tag = tag
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViews() {
        createButtons()
        let arrangedSubviews = setupStackViews()
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupStackViews() -> [UIStackView] {
        var stackViews: [UIStackView] = []
        var arrangedSubviews: [UIView] = []
        for i in 0...buttonsArray.count {
            if i % 3 == 0 && i != 0 {
                let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
                stackView.spacing = 8
                stackView.distribution = .fillEqually
                stackViews.append(stackView)
                arrangedSubviews = []
            }
            if i != 12 {
                arrangedSubviews.append(buttonsArray[i])
            }
        }
        return stackViews
    }
    
    private func createButtons() {
        for (index, element) in numbersAndImageNamesArray.enumerated() {
            if element != commaImageName && element != deleteImageName {
                let button = createButton(with: element, tag: index)
                buttonsArray.append(button)
            } else {
                let button = createButton(imageName: element, tag: index)
                buttonsArray.append(button)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK:- KeyboardViewProtocol
    
    var zeroNumber: Int! {
        didSet {
            numbersAndImageNamesArray.append(String(describing: zeroNumber ?? 0))
        }
    }
    
    var arrayNumbers: [Int]! {
        didSet {
            arrayNumbers.forEach { number in
                numbersAndImageNamesArray.append(String(describing: number))
            }
        }
    }
    
    var deleteImageName: String! {
        didSet {
            numbersAndImageNamesArray.append(deleteImageName)
        }
    }
    
    var commaImageName: String! {
        didSet {
            numbersAndImageNamesArray.append(commaImageName)
        }
    }
    
    // MARK:- KeyboardViewDelegate
    
    @objc
    private func handleLongPress(sender: UILongPressGestureRecognizer) {
        let button = buttonsArray.first { (button) -> Bool in
            return button.tag == 11
        }
        guard button != nil else { return }
        delegate?.clearAll()
    }
    
    @objc
    private func handleImageButtonTapped(sender: UIButton) {
        if sender.tag == 9 {
            delegate?.commaButtonTapped()
        } else {
            delegate?.deleteButtonTapped()
        }
    }
    
    @objc
    private func handleKeyboardButtonTapped(sender: UIButton) {
        let number = sender.tag == 10 ? 0 : sender.tag + 1
        delegate?.numberButtonTapped(number: number)
    }
}
