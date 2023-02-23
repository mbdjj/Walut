//
//  CurrencyCalcViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/02/2023.
//

import SwiftUI

class CurrencyCalcViewModel: ObservableObject {
    
    let currency: Currency
    let base: Currency
    
    @Published var topCurrency: Currency
    @Published var bottomCurrency: Currency
    
    @Published var topAmount: Double = 0
    @Published var bottomAmount: Double = 0
    
    @Published var isDouble: Bool = false
    @Published var decimalDigits = 0
    
    init(currency: Currency, base: Currency) {
        self.currency = currency
        self.base = base
        
        self.topCurrency = base
        self.bottomCurrency = currency
    }
    
    
    func amountString(_ type: AmountType) -> String {
        let amount = type == .top ? topAmount : bottomAmount
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let decimal = Locale.current.decimalSeparator ?? "."
        
        var str = formatter.string(from: amount as NSNumber) ?? "0"
        
        if amount == Double(Int(amount)) && isDouble && type == .top {
            str += decimal
            
            for _ in 0 ..< decimalDigits {
                str += "0"
            }
        } else if amount * 10 == Double(Int(amount * 10)) && isDouble && type == .top {
            if decimalDigits == 2 {
                str += "0"
            }
        }
        
        return str
    }
    
    private func calcDecimal() {
        for i in 0 ... 2 {
            let amount = topAmount
            
            if amount * pow(10, Double(i)) == Double(Int(amount * pow(10, Double(i)))) { // I know it's a mess
                decimalDigits = i
                break
            } else if i == 2 {
                decimalDigits = i
                break
            }
        }
    }
    private func checkIfDouble() {
        isDouble = topAmount != Double(Int(topAmount))
        
        if isDouble {
            calcDecimal()
        }
    }
    func swapCurrencies() {
        (topCurrency, bottomCurrency) = (bottomCurrency, topCurrency)
        (topAmount, bottomAmount) = (bottomAmount, topAmount)
        
        checkIfDouble()
    }
    
    
    func buttonPressed(_ num: Int) {
        if !isDouble {
            topAmount *= 10
            topAmount += Double(num)
        } else {
            if decimalDigits < 2 {
                decimalDigits += 1
                
                topAmount *= pow(10, Double(decimalDigits))
                topAmount += Double(num)
                topAmount /= pow(10, Double(decimalDigits))
            }
        }
    }
    
    func buttonPressed(_ sym: String) {
        if sym == "," {
            isDouble = true
            
        } else if sym == "0" {
            if !isDouble {
                buttonPressed(0)
            } else {
                if decimalDigits < 2 {
                    decimalDigits += 1
                }
            }
            
        } else if sym == "<" {
            if !isDouble {
                topAmount = Double(Int(topAmount / 10))
            } else {
                if isDouble && decimalDigits == 0 {
                    isDouble = false
                } else {
                    decimalDigits -= 1
                    
                    topAmount *= pow(10, Double(decimalDigits))
                    topAmount = Double(Int(topAmount))
                    topAmount /= pow(10, Double(decimalDigits))
                }
            }
        }
    }
    
    func clear() {
        topAmount = 0
        isDouble = false
        decimalDigits = 0
    }
    
    func handleFavorites() {
        if !currency.isFavorite {
            favorite(currency: currency)
        } else {
            unfavorite(currency: currency)
        }
        
        UserDefaults.standard.set(SharedDataManager.shared.favorites, forKey: "favorites")
    }
    
    private func favorite(currency: Currency) {
        SharedDataManager.shared.favorites.append(currency.code)
    }
    
    private func unfavorite(currency: Currency) {
        if let i = SharedDataManager.shared.favorites.firstIndex(where: { currency.code == $0 }) {
            SharedDataManager.shared.favorites.remove(at: i)
        }
    }
    
}

enum AmountType {
    case top
    case bottom
}
