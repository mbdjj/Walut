//
//  NetworkManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/02/2022.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    
    @Published var base: Currency //Base currency is selected when first opening an app.
    @Published var sortedCurrencies = [Currency]()
    @Published var currencies = [Currency]() //This array contains data of all the currencies.
    @Published var favoriteCodes = [String]()
    @Published var chosenCurrencyTimeSeries = [Double]()
    
    @Published var allCurrencies = [Currency]() //This array contains data for base currency Pickers.
    
    @Published var currentSort: Int //Variable storing the sort Int which is decoded by decodeAndSort() method
    @Published var byFavorite: Bool
    var customSortCodes = [String]()
    
    @Published var tabSelection = 0 //This variable stores information about which tab is selected in TabView. It's used for checking the double tap.
    @Published var tappedTwice = false //This changes every time user taps more than one time on a tabItem.
    
    @Published var isBaseSelected: Bool //It's false if the app is launched for the first time. Otherwise true.
    
    let defaults = UserDefaults.standard
    let sortManager = SortManager()
    
    //When object from this class gets initialized (shared) this function changes the base currency and checks if it's the first time launching app.
    init() {
        base = Currency(baseCode: defaults.string(forKey: "base") ?? "AUD")
        
        isBaseSelected = defaults.bool(forKey: "isBaseSelected")
        
        currentSort = defaults.integer(forKey: "sort")
        byFavorite = defaults.bool(forKey: "byFavorite")
        
        if let array = defaults.array(forKey: "favorites") as? [String] {
            favoriteCodes = array
        }
        
        if let array = defaults.array(forKey: "customSort") as? [String] {
            customSortCodes = array
        }
        
        for code in allCodesArray {
            allCurrencies.append(Currency(baseCode: code))
        }
        
        if isBaseSelected {
            fetchData(forCode: base.code)
        }
    }
    
    static let shared = NetworkManager() //Shared manager accross all the views.
    
    let allCodesArray = ["AUD", "BRL", "BGN", "CAD", "CNY", "HRK", "CZK", "DKK", "EUR", "HKD", "HUF", "INR", "IDR", "ILS", "JPY", "MYR", "MXN", "RON", "NZD", "NOK", "PHP", "PLN", "GBP", "RUB", "SGD", "ZAR", "KRW", "SEK", "CHF", "THB", "TRY", "USD"]
    
    
    
    //MARK: - Methods
    //This method sents a request to API and downloads data for base currency selected by user.
    func fetchData(forCode baseCurrency: String) {
        
        currencies = []
        
        if let url = URL(string: "https://api.exchangerate.host/latest?base=\(baseCurrency)") {
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            let task = session.dataTask(with: request) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(CurrencyData.self, from: safeData)
                            
                            var currencyArray = [Currency]()
                            
                            for code in self.allCodesArray {
                                var currency = Currency(code: code, rate: results.rates.getRate(of: code))
                                if self.favoriteCodes.firstIndex(of: code) != nil {
                                    currency.isFavorite = true
                                }
                                currencyArray.append(currency)
                            }
                            
                            guard let index = currencyArray.firstIndex(of: Currency(baseCode: self.base.code)) else { return }
                            currencyArray.remove(at: index)
                            
                            DispatchQueue.main.async {
                                self.currencies = currencyArray
                                self.decodeAndSort()
                            }
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
            task.resume()
        }
    }
    
    func getChartData(for currency: Currency) {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let startDateString = formatter.string(from: startDate!)
        
        let endDate = Date()
        let endDateString = formatter.string(from: endDate)
        
        if let url = URL(string: "https://api.exchangerate.host/timeseries?start_date=\(startDateString)&end_date=\(endDateString)&base=\(currency.code)&symbols=\(base.code)") {
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            let task = session.dataTask(with: request) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(CurrencyTimeSeriesData.self, from: safeData)
                            
                            let timeSeriesData = results.rates.ratesArray
                            var timeSeriesArray = [Double()]
                            
                            for i in timeSeriesData {
                                timeSeriesArray.append(i[self.base.code]!)
                            }
                            
                            timeSeriesArray.remove(at: 0)
                            
                            DispatchQueue.main.async {
                                self.chosenCurrencyTimeSeries = timeSeriesArray
                                print(timeSeriesArray)
                            }
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    //This method helps with sorting using SortManager object.
    func decodeAndSort() {
        withAnimation {
            switch currentSort {
            case 0:
                sortedCurrencies = currencies
            case 1:
                sortedCurrencies = sortManager.sortByCode(array: currencies, atoz: false)
            case 2:
                sortedCurrencies = sortManager.sortByCode(array: currencies, atoz: true)
            case 3:
                sortedCurrencies = sortManager.sortByPrice(array: currencies, fromLargest: false)
            case 4:
                sortedCurrencies = sortManager.sortByPrice(array: currencies, fromLargest: true)
            case 5:
                if let baseIndex = customSortCodes.firstIndex(of: base.code) {
                    customSortCodes.remove(at: baseIndex)
                    defaults.set(customSortCodes, forKey: "customSort")
                }
                sortedCurrencies = sortManager.customSort(array: currencies, toPattern: customSortCodes)
                byFavorite = false
            default:
                sortedCurrencies = currencies
            }
            
            if byFavorite {
                sortedCurrencies = sortManager.favoritesFirst(array: sortedCurrencies, favorites: favoriteCodes)
            }
        }
    }
    
    //Method used for changing app icon.
    func changeIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        
        if iconName == "AUD" || iconName == "CAD" || iconName == "HKD" || iconName == "MXN" || iconName == "NZD" || iconName == "SGD" || iconName == "USD" {
            UIApplication.shared.setAlternateIconName(nil) { error in
                if error != nil {
                    print("Failed to change app icon: \(error!.localizedDescription)")
                } else {
                    print("App icon changed successfully")
                }
                
                return
            }
        }
        
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if error != nil {
                print("Failed to change app icon: \(error!.localizedDescription)")
            } else {
                print("App icon changed successfully")
            }
        }
    }
    
}
