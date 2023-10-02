//
//  MainViewModel.swift
//  TestApp
//
//  Created by Artem Leschenko on 02.10.2023.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var text1 = ""
    @Published var text2 = "0.0"
    @Published var firstValue = "USD"
    @Published var secondValue = "UAH"
    
    @Published var errorText = "Something go wrong :(" {
        didSet {
            showError = true
        }
    }
    @Published var showError = false
    
    @Published var activeValue = [String]() // Для зручності зроблено окрему змінну
    @Published var data: MoneyData?
    
    
    //MARK: - For favorite
    @AppStorage("favotitePairs") var favotitePairs: String = ""
    var listOfFavor = [String]()
    let apiKey = "b1a8d9d5b3554b375179f306"
    @Published  var pickOfFav = "" {
        didSet { setFav() }
    }

    func addToFav() {
        if let index = listOfFavor.firstIndex(of: "\(firstValue)+\(secondValue)") {
            listOfFavor.remove(at: index)
            UserDefaults.standard.set(listOfFavor.joined(separator: "-"), forKey: "favotitePairs")
        } else {
            listOfFavor.append("\(firstValue)+\(secondValue)")
            
            UserDefaults.standard.set(listOfFavor.joined(separator: "-"), forKey: "favotitePairs")
        }
    }
    
    func setFav() {
        let components = pickOfFav.components(separatedBy: "+")
        guard components.count > 1 else { return }
        firstValue = components[0]
        secondValue = components[1]
    }
    
    func setUp() {
        fetchExchangeRates()
        if let data = UserDefaults.standard.string(forKey: "favotitePairs") {
            listOfFavor = data.components(separatedBy: "-")
        }
    }
    
    func fetchExchangeRates() {
        if let url = URL(string: "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/USD") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let exchangeRates = try decoder.decode(MoneyData.self, from: data)
                        
                        self.data = exchangeRates
                        self.updateActiveValue(from: exchangeRates)
                    } catch {
                        self.errorText = "Something went wrong :( (\(error.localizedDescription)"
                    }
                }
            }.resume()
        }
    }
    
    func fetchRate() {
        if let url = URL(string: "https://v6.exchangerate-api.com/v6/\(apiKey)/pair/\(firstValue)/\(secondValue)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let exchangeRates = try decoder.decode(RateData.self, from: data)
                        
                        guard let textDouble = Double(self.text1) else { self.errorText = "Write corect data"; return }
                        self.text2 = String(textDouble * exchangeRates.conversionRate)
                    } catch {
                        self.errorText = "Something went wrong :( (\(error.localizedDescription)"
                    }
                }
            }.resume()
        }
    }
    
    func updateActiveValue(from exchangeRates: MoneyData) {
            let keys = Array(exchangeRates.conversionRates.keys)
            activeValue = keys
        }
}
