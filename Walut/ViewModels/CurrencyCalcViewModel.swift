//
//  CurrencyCalcViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/02/2023.
//

import SwiftUI

@Observable class CurrencyCalcViewModel {
    
    var currency: Currency
    var base: Currency
    
    var topAmount: Double = 0
    var bottomAmount: Double = 0
    
    var isDouble: Bool = false
    var decimalDigits = 0
    
    var isTopOpen = true
    
    private let shared = SharedDataManager.shared
    private let defaults = UserDefaults.standard
    var textToShare: String {
        "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(shared.currencyLocaleString(value: currency.price, currencyCode: base.code))"
    }
    
    init(currency: Currency, base: Currency, shouldSwap: Bool) {
        self.currency = currency
        self.base = base
        
        #if os(watchOS)
        topAmount = 1
        #endif
        calcPassive()
    }
    
    
    func amountString(_ type: AmountType) -> String {
        let amount = isTopOpen == (type == .active) ? topAmount : bottomAmount
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let decimal = Locale.current.decimalSeparator ?? "."
        
        var str = formatter.string(from: amount as NSNumber) ?? "0"
        
        if amount == floor(amount) && isDouble && type == .active {
            str += decimal
            
            for _ in 0 ..< decimalDigits {
                str += "0"
            }
        } else if amount * 10 == floor(amount * 10) && isDouble && type == .active {
            if decimalDigits == 2 {
                str += "0"
            }
        }
        
        return str
    }
    
    func valueToShare(_ type: AmountType = .active) -> String {
        var first = ""
        var second = ""
        
        if isTopOpen == (type == .active) {
            first = shared.priceLocaleString(value: topAmount, currencyCode: currency.code)
            second = shared.priceLocaleString(value: bottomAmount, currencyCode: base.code)
        } else {
            first = shared.priceLocaleString(value: bottomAmount, currencyCode: base.code)
            second = shared.priceLocaleString(value: topAmount, currencyCode: currency.code)
        }
        
        return "\(first) = \(second)"
    }
    
    private func calcDecimal() {
        let activeAmount = isTopOpen ? topAmount : bottomAmount
        for i in 0 ... 2 {
            let amount = activeAmount
            
            if amount * pow(10, Double(i)) == floor(amount * pow(10, Double(i))) {
                decimalDigits = i
                break
            } else if i == 2 {
                decimalDigits = i
                break
            }
        }
    }
    private func checkIfDouble() {
        let activeAmount = isTopOpen ? topAmount : bottomAmount
        isDouble = activeAmount != floor(activeAmount)
        
        if isDouble {
            calcDecimal()
        }
    }
    func swapActive() {
        checkIfDouble()
    }
    
    
    func buttonPressed(_ num: Int) {
        if isTopOpen {
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
        } else {
            if !isDouble {
                bottomAmount *= 10
                bottomAmount += Double(num)
            } else {
                if decimalDigits < 2 {
                    decimalDigits += 1
                    
                    bottomAmount *= pow(10, Double(decimalDigits))
                    bottomAmount += Double(num)
                    bottomAmount /= pow(10, Double(decimalDigits))
                }
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
            if isTopOpen {
                if !isDouble {
                    topAmount = floor(topAmount / 10)
                } else {
                    if isDouble && decimalDigits == 0 {
                        isDouble = false
                    } else {
                        decimalDigits -= 1
                        
                        topAmount *= pow(10, Double(decimalDigits))
                        topAmount = floor(topAmount)
                        topAmount /= pow(10, Double(decimalDigits))
                    }
                }
            } else {
                if !isDouble {
                    bottomAmount = floor(bottomAmount / 10)
                } else {
                    if isDouble && decimalDigits == 0 {
                        isDouble = false
                    } else {
                        decimalDigits -= 1
                        
                        bottomAmount *= pow(10, Double(decimalDigits))
                        bottomAmount = floor(bottomAmount)
                        bottomAmount /= pow(10, Double(decimalDigits))
                    }
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
    
    func changeCurrency(_ type: AmountType, to code: String) {
        let currencyToSwitch = isTopOpen == (type == .active) ? currency : base
        
        if currencyToSwitch == base {
            base = Currency(baseCode: code)
            Task {
                await getCurrency()
            }
        } else {
            currency = Currency(baseCode: code)
            Task {
                await self.getCurrency()
            }
        }
    }
    
    private func getCurrency() async {
        do {
            let data = try await NetworkManager.shared.getData(for: currency, base: base)
            present(data)
        } catch {
            print("Couldn't update currency")
            print(error.localizedDescription)
        }
    }
    
    private func present(_ data: Currency) {
        DispatchQueue.main.async {
            self.currency = data
        }
    }
    
    func calcPassive() {
        if isTopOpen {
            bottomAmount = topAmount * currency.price
        } else {
            topAmount = bottomAmount * currency.rate
        }
    }
}

enum AmountType {
    case active
    case passive
}
