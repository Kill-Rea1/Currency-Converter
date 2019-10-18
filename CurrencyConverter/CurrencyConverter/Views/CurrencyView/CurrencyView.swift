//
//  CurrencyView.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 06/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CurrencyViewProtocol: class {
    var currencyShortName: String! { set get }
    var currencyValue: String! { set get }
    var isFlipped: Bool { set get }
}

protocol CurrencyViewDelegate: class {
    func didCurrencyChangeButtonTapped(with tag: Int)
}

@IBDesignable
class CurrencyView: UIView, CurrencyViewProtocol {
    
    var delegate: CurrencyViewDelegate?
    
    var currencyShortNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Currency  ", for: .normal)
        button.tintColor = #colorLiteral(red: 0.3806797862, green: 0.4001729488, blue: 0.493964076, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCurrencyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func handleCurrencyButtonTapped() {
        delegate?.didCurrencyChangeButtonTapped(with: self.tag)
    }
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "Value"
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.5113930702, green: 0.399178654, blue: 0.9329522252, alpha: 1)
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 4, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        backgroundColor = .clear
    }
    
    init(tag: Int) {
        super.init(frame: .zero)
        setupShadow()
        setupViews()
        translatesAutoresizingMaskIntoConstraints = false
        self.tag = tag
    }
    
    private func setupViews() {
        addSubview(currencyShortNameButton)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            currencyShortNameButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            currencyShortNameButton.widthAnchor.constraint(equalToConstant: 100),
            currencyShortNameButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            valueLabel.topAnchor.constraint(equalTo: currencyShortNameButton.bottomAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
        ])
    }
    
    override func draw(_ rect: CGRect) {
        let size = bounds.size

        let p1 = self.bounds.origin
        let p2 = CGPoint(x: p1.x, y: p1.y + size.height)
        var p3 = CGPoint(x: p1.x + size.width / 2 - 30, y: p2.y)
        var p4 = CGPoint(x: p3.x + 30, y: p3.y - 30)
        var p5 = CGPoint(x: p4.x + 30, y: p2.y)
        let p6 = CGPoint(x: p1.x + size.width, y: p2.y)
        let p7 = CGPoint(x: p6.x, y: p1.y)

        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        if isFlipped {
            p3.y -= size.height
            p5.y -= size.height
            p4.y = p3.y + 30
            path.addLine(to: p6)
            path.addLine(to: p7)
            path.addLine(to: p5)
            path.addQuadCurve(to: p3, controlPoint: p4)
        } else {
            path.addLine(to: p3)
            path.addQuadCurve(to: p5, controlPoint: p4)
            path.addLine(to: p6)
            path.addLine(to: p7)
        }
        path.close()
        UIColor.white.setFill()
        path.fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK:- CurrencyViewProtocol methods
    
    var currencyShortName: String! {
        didSet {
            currencyShortNameButton.setTitle(currencyShortName, for: .normal)
        }
    }
    
    var currencyValue: String! {
        didSet {
            valueLabel.text = currencyValue
        }
    }
    
    @IBInspectable var isFlipped: Bool = false {
        didSet {
            draw(.zero)
        }
    }
}
