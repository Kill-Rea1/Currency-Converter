//
//  CustomNavigationController.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 07/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    func configureNavigation() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.3469133377, green: 0.3547455966, blue: 0.9967538714, alpha: 1)
        navBarAppearance.shadowColor = nil
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.prefersLargeTitles = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
