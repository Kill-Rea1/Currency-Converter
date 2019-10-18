//
//  ServerService.swift
//  CurrencyConverter
//
//  Created by Кирилл Иванов on 06/10/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol ServerServiceProtocol: class {
    var URLAllCurrencies: String { get }
    func URLGetRatio(inputCurrencyShortName: String, outputCurrencyShortName: String) -> String
    func getAllCurrencies(completion: @escaping ([String: Any]?, Error?) -> ())
    func getRatio(inputCurrencyShortName: String, outputCurrencyShortName: String, completion: @escaping ([String: Any]?, Error?) -> ())
}

class ServerService: ServerServiceProtocol {
    func URLGetRatio(inputCurrencyShortName: String, outputCurrencyShortName: String) -> String {
        return "https://free.currconv.com/api/v7/convert?q=\(inputCurrencyShortName)_\(outputCurrencyShortName)&compact=y&apiKey=c03f6a8d9e4c90953596"
    }
    
    var URLAllCurrencies: String {
        return "https://free.currconv.com/api/v7/currencies?apiKey=c03f6a8d9e4c90953596"
    }
    
    func getAllCurrencies(completion: @escaping ([String : Any]?, Error?) -> Void) {
        if let url = URL(string: URLAllCurrencies) {
            fetchJSON(url: url, completion: completion)
        }
    }
    
    func getRatio(inputCurrencyShortName: String, outputCurrencyShortName: String, completion: @escaping ([String : Any]?, Error?) -> Void) {
        let urlString = URLGetRatio(inputCurrencyShortName: inputCurrencyShortName, outputCurrencyShortName: outputCurrencyShortName)
        if let url = URL(string: urlString) {
            fetchJSON(url: url, completion: completion)
        }
    }
    
    // MARK:- Private methods
    
    private func fetchJSON(url: URL, completion: @escaping ([String: Any]?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to fetch JSON:", err)
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                completion(json, nil)
                return
            }
            catch let jsonErr {
                print("Failed to load:", jsonErr)
                completion(nil, jsonErr)
                return
            }
        }.resume()
    }
}
