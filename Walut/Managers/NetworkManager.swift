//
//  NetworkManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation

class NetworkManager: ObservableObject {
    
    let shared = SharedDataManager.shared
    
    @Published var currencyArray = [Currency]()
    @Published var ratesArray = [RatesData]()
    
    
    func fetchCurrencyData(for base: Currency) {
        
        if let url = URL(string: "https://api.exchangerate.host/latest?base=\(base.code)") {
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            let task = session.dataTask(with: request) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(CurrencyData.self, from: safeData)
                            
                            var currencyArray = [Currency]()
                            
                            for code in self.shared.allCodesArray {
                                let currency = Currency(code: code, rate: results.rates.getRate(of: code))
//                                if self.favoriteCodes.firstIndex(of: code) != nil {
//                                    currency.isFavorite = true
//                                }
                                currencyArray.append(currency)
                            }
                            
                            guard let index = currencyArray.firstIndex(of: Currency(baseCode: base.code)) else { return }
                            currencyArray.remove(at: index)
                            
                            print("Fetched data for \(base.code)")
                            
                            DispatchQueue.main.async {
                                self.currencyArray = currencyArray
                                //self.decodeAndSort()
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
        } else {
            print("nie działa")
        }
    }
    
    func getChartData(for currency: Currency, base: Currency) {
        
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
                            let keyData = results.rates.keyArray
                            var timeSeriesArray = [RatesData]()
                            
                            for i in 0..<timeSeriesData.count {
                                timeSeriesArray.append(.init(date: keyData[i], value: timeSeriesData[i][base.code]!))
                            }
                            
                            DispatchQueue.main.async {
                                self.ratesArray = timeSeriesArray
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
    
}
