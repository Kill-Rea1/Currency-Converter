//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 07/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CurrencyTableViewCellProtocol: class {
    var currency: Currency! { set get }
}

class CurrencyTableViewCell: UITableViewCell, CurrencyTableViewCellProtocol {
    
    var currencyFullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Currency name"
        label.textColor = #colorLiteral(red: 0.3806797862, green: 0.4001729488, blue: 0.493964076, alpha: 1)
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Short"
        label.textColor = #colorLiteral(red: 0.3806797862, green: 0.4001729488, blue: 0.493964076, alpha: 1)
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [
            currencyFullNameLabel,
            currencyShortNameLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var currency: Currency! {
        didSet {
            currencyFullNameLabel.text = currency.fullName
            currencyShortNameLabel.text = currency.shortName
        }
    }
}
