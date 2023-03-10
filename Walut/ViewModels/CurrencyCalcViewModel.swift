//
//  CurrencyCalcViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 23/02/2023.
//

import SwiftUI

class CurrencyCalcViewModel: ObservableObject {
    
    @Published var currency: Currency
    var base: Currency
    
    @Published var topCurrency: Currency
    @Published var bottomCurrency: Currency
    
    @Published var topAmount: Double = 0
    @Published var bottomAmount: Double = 0
    
    @Published var isDouble: Bool = false
    @Published var decimalDigits = 0
    
    let shared = SharedDataManager.shared
    let defaults = UserDefaults.standard
    var textToShare: String {
        "\(currency.fullName)\(String(localized: "text_to_share0"))(\(currency.code))\(String(localized: "text_to_share1"))\(shared.currencyLocaleString(value: currency.price, currencyCode: base.code))"
    }
    
    var isCustom: Bool { shared.isCustomDate }
    var customDate: Date { shared.customDate }
    
    var finishedLoading = false
    
    init(currency: Currency, base: Currency, shouldSwap: Bool) {
        self.currency = currency
        self.base = base
        
        self.topCurrency = base
        self.bottomCurrency = currency
        
        if shouldSwap {
            self.swapCurrencies()
        }
        
        let codeFromSave = defaults.string(forKey: "savedCodes")
        if codeFromSave == "\(currency.code)\(base.code)" {
            let topCode = defaults.string(forKey: "savedTopCode")
            let amount = defaults.double(forKey: "savedAmount")
            
            if topCurrency.code != topCode {
                self.swapCurrencies()
            }
            
            topAmount = amount
        }
        calcBottom()
        finishedLoading = true
    }
    
    
    func amountString(_ type: AmountType) -> String {
        let amount = type == .top ? topAmount : bottomAmount
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let decimal = Locale.current.decimalSeparator ?? "."
        
        var str = formatter.string(from: amount as NSNumber) ?? "0"
        
        if amount == floor(amount) && isDouble && type == .top {
            str += decimal
            
            for _ in 0 ..< decimalDigits {
                str += "0"
            }
        } else if amount * 10 == floor(amount * 10) && isDouble && type == .top {
            if decimalDigits == 2 {
                str += "0"
            }
        }
        
        return str
    }
    
    func valueToShare(_ type: AmountType = .top) -> String {
        var first = ""
        var second = ""
        
        if type == .top {
            first = shared.priceLocaleString(value: topAmount, currencyCode: topCurrency.code)
            second = shared.priceLocaleString(value: bottomAmount, currencyCode: bottomCurrency.code)
        } else {
            first = shared.priceLocaleString(value: bottomAmount, currencyCode: bottomCurrency.code)
            second = shared.priceLocaleString(value: topAmount, currencyCode: topCurrency.code)
        }
        
        return "\(first) = \(second)"
    }
    
    private func calcDecimal() {
        for i in 0 ... 2 {
            let amount = topAmount
            
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
        isDouble = topAmount != floor(topAmount)
        
        if isDouble {
            calcDecimal()
        }
    }
    func swapCurrencies() {
        (topCurrency, bottomCurrency) = (bottomCurrency, topCurrency)
        (topAmount, bottomAmount) = (bottomAmount, topAmount)
        
        checkIfDouble()
        if finishedLoading {
            saveToDefaults()
        }
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
        
        saveToDefaults()
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
        }
        
        saveToDefaults()
    }
    
    func clear() {
        topAmount = 0
        isDouble = false
        decimalDigits = 0
        saveToDefaults()
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
        let currencyToSwitch = type == .top ? topCurrency : bottomCurrency
        
        if currencyToSwitch == base {
            base = Currency(baseCode: code)
            Task {
                await getCurrency()
            }
            if type == .top {
                topCurrency = base
                bottomCurrency = currency
            } else {
                topCurrency = currency
                bottomCurrency = base
            }
        } else {
            currency = Currency(baseCode: code)
            Task {
                await self.getCurrency()
            }
            if type == .top {
                topCurrency = currency
                bottomCurrency = base
            } else {
                topCurrency = base
                bottomCurrency = currency
            }
        }
        
        if topAmount != 0 {
            saveToDefaults()
        }
    }
    
    func getCurrency() async {
        do {
            if isCustom {
                let data = try await NetworkManager.shared.getData(for: currency, base: base, date: customDate)
                present(data)
            } else {
                let data = try await NetworkManager.shared.getData(for: currency, base: base)
                present(data)
            }
        } catch {
            print("Couldn't update currency")
            print(error.localizedDescription)
        }
    }
    
    func present(_ data: Currency) {
        DispatchQueue.main.async {
            self.currency = data
        }
    }
    
    private func saveToDefaults() {
        defaults.set("\(currency.code)\(base.code)", forKey: "savedCodes")
        defaults.set(topCurrency.code, forKey: "savedTopCode")
        defaults.set(topAmount, forKey: "savedAmount")
        print("saved!")
    }
    
    func calcBottom() {
        if topCurrency == base {
            bottomAmount = topAmount / currency.price
        } else {
            bottomAmount = topAmount / currency.rate
        }
    }
}

enum AmountType {
    case top
    case bottom
}
