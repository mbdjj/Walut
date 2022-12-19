//
//  NetworkManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    private let decoder = JSONDecoder()
    private let allCodesArray = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "USD", "ZAR"]
    
    let defaults = UserDefaults.standard
    
    
    func getCurrencyData(for base: Currency) async throws -> [Currency] {
        guard let url = URL(string: "https://api.exchangerate.host/latest?base=\(base.code)") else {
            throw NetworkError.invalidURL
        }
        guard let yesterdayUrl = URL(string: "https://api.exchangerate.host/\(yesterdayString())?base=\(base.code)") else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        let yesterdayReq = URLRequest(url: yesterdayUrl, cachePolicy: .reloadIgnoringLocalCacheData)
        let (yesterdayData, yesterdayResponse) = try await URLSession.shared.data(for: yesterdayReq)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        guard let yesterdayResponse = yesterdayResponse as? HTTPURLResponse, yesterdayResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            let yesterdayResults = try decoder.decode(CurrencyData.self, from: yesterdayData)
            
            var currencyArray = [Currency]()
            
            for code in self.allCodesArray {
                let currency = Currency(code: code, rate: results.rates.getRate(of: code), yesterday: yesterdayResults.rates.getRate(of: code))
                currencyArray.append(currency)
            }
            
            print("Fetched currency data for \(base.code)")
            self.saveDate()
            
            return currencyArray
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getChartData(for currency: Currency, base: Currency) async throws -> [RatesData] {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: .now)
        let startDateString = formatter.string(from: startDate!)
        
        let endDate = Date()
        let endDateString = formatter.string(from: endDate)
        
        guard let url = URL(string: "https://api.exchangerate.host/timeseries?start_date=\(startDateString)&end_date=\(endDateString)&base=\(currency.code)&symbols=\(base.code)") else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyTimeSeriesData.self, from: data)
            
            let timeSeriesData = results.rates.ratesArray
            let keyData = results.rates.keyArray
            var timeSeriesArray = [RatesData]()
            
            for i in 0..<timeSeriesData.count {
                timeSeriesArray.append(.init(code: results.base, date: keyData[i], value: timeSeriesData[i][base.code] ?? 0))
            }
            
            print("Fetched chart data for \(currency.code)")
            
            return timeSeriesArray
            
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    func getSmallWidgetData(for currencyCode: String, baseCode: String) async throws -> [RatesData] {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        let startDateString = formatter.string(from: startDate!)
        
        let endDate = Date()
        let endDateString = formatter.string(from: endDate)
        
        guard let url = URL(string: "https://api.exchangerate.host/timeseries?start_date=\(startDateString)&end_date=\(endDateString)&base=\(currencyCode)&symbols=\(baseCode)") else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyTimeSeriesData.self, from: data)
            
            let timeSeriesData = results.rates.ratesArray
            let keyData = results.rates.keyArray
            var timeSeriesArray = [RatesData]()
            
            for i in 0..<timeSeriesData.count {
                timeSeriesArray.append(.init(code: results.base, date: keyData[i], value: timeSeriesData[i][baseCode] ?? 0))
            }
            
            return timeSeriesArray
            
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    func yesterdayString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        let yesterdayString = formatter.string(from: yesterday!)
        
        return yesterdayString
    }
    
    // MARK: - NetworkErrors
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
    }
    
    // MARK: - Date checking refresh
    
    func shouldRefresh() -> Bool {
        let date = getDateFromDefaults()
        let now = Date.now
        
        let difference = now.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
        return difference > 60 * 15 // 15 minutes
    }
    
    private func getDateFromDefaults() -> Date {
        let dateString = defaults.string(forKey: "lastUpdate") ?? "2022-02-23 00:00:00" // my birthday :)
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "rrrr-MM-dd HH:mm:ss"
        
        return formatter.date(from: dateString)!
    }
    
    private func saveDate() {
        let date = Date.now
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "rrrr-MM-dd HH:mm:ss"
        
        let dateString = formatter.string(from: date)
        defaults.set(dateString, forKey: "lastUpdate")
    }
    
}
