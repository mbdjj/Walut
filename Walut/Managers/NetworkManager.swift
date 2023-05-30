//
//  NetworkManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation
import Network

struct NetworkManager {
    
    private let decoder = JSONDecoder()
    private let allCodesArray: [String]
    private let defaults = UserDefaults.standard
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let shared = NetworkManager()
    
    init() {
        allCodesArray = SharedDataManager.shared.allCodesArray
    }
    
    
    // MARK: - Methods for fetching currency data
    func getCurrencyData(for base: Currency) async throws -> [Currency] {
        guard let url = URL(string: "https://api.exchangerate.host/latest?base=\(base.code)"),
              let yesterdayUrl = URL(string: "https://api.exchangerate.host/\(yesterdayString())?base=\(base.code)")
        else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        let yesterdayReq = URLRequest(url: yesterdayUrl, cachePolicy: .reloadIgnoringLocalCacheData)
        let (yesterdayData, yesterdayResponse) = try await URLSession.shared.data(for: yesterdayReq)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200,
              let yesterdayResponse = yesterdayResponse as? HTTPURLResponse, yesterdayResponse.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            let yesterdayResults = try decoder.decode(CurrencyData.self, from: yesterdayData)
            
            let currencyArray = self.allCodesArray.map {
                Currency(code: $0, rate: results.rates.getRate(of: $0), yesterday: yesterdayResults.rates.getRate(of: $0))
            }
            
            print("Fetched currency data for \(base.code)")
            self.saveDate()
            
            return currencyArray
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getCurrencyData(for base: Currency, date: Date) async throws -> [Currency] {
        let dateStrings = stringsForURLs(from: date)
        
        guard let url = URL(string: "https://api.exchangerate.host/\(dateStrings.0)?base=\(base.code)"),
              let yesterdayUrl = URL(string: "https://api.exchangerate.host/\(dateStrings.1)?base=\(base.code)")
        else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        let yesterdayReq = URLRequest(url: yesterdayUrl, cachePolicy: .reloadIgnoringLocalCacheData)
        let (yesterdayData, yesterdayResponse) = try await URLSession.shared.data(for: yesterdayReq)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200,
              let yesterdayResponse = yesterdayResponse as? HTTPURLResponse, yesterdayResponse.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            let yesterdayResults = try decoder.decode(CurrencyData.self, from: yesterdayData)
            
            let currencyArray = self.allCodesArray.map {
                Currency(code: $0, rate: results.rates.getRate(of: $0), yesterday: yesterdayResults.rates.getRate(of: $0))
            }
            
            print("Fetched currency data for \(base.code) on \(dateString(from: date))")
            self.saveDate()
            
            return currencyArray
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getData(for currency: Currency, base: Currency) async throws -> Currency {
        guard let url = URL(string: "https://api.exchangerate.host/latest?base=\(base.code)") else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            let currency = Currency(code: currency.code, rate: results.rates.getRate(of: currency.code))
            
            print("Fetched currency data for \(base.code) and returned only \(currency.code)")
            
            return currency
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getData(for currency: Currency, base: Currency, date: Date) async throws -> Currency {
        let dateString = dateString(from: date)
        
        guard let url = URL(string: "https://api.exchangerate.host/\(dateString)?base=\(base.code)") else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            let currency = Currency(code: currency.code, rate: results.rates.getRate(of: currency.code))
            
            print("Fetched currency data for \(base.code) and returned only \(currency.code)")
            
            return currency
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // MARK: - Methods for fetching chart data
    func getChartData(for currency: Currency, base: Currency, date: Date = .now, range: ChartRange = .oneMonth) async throws -> [RatesData] {
        let startDate = Calendar.current.date(byAdding: .month, value: -range.monthValue, to: date)
        let startDateString = formatter.string(from: startDate!)
        let endDateString = formatter.string(from: date)
        
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
            var timeSeriesArray = timeSeriesData
                .enumerated()
                .map { RatesData(code: results.base, date: keyData[$0.offset], value: timeSeriesData[$0.offset][base.code] ?? 0) }
            
            if range != .oneMonth {
                timeSeriesArray = timeSeriesArray
                    .reversed()
                    .enumerated()
                    .filter { $0.offset % range.monthValue == 0 }
                    .reversed()
                    .map { $0.element }
            }
            
            print("Fetched chart data for \(currency.code) on \(dateString(from: date))")
            
            return timeSeriesArray
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getChartData(forCode currency: String, baseCode: String) async throws -> [RatesData] {
        try await getChartData(for: Currency(baseCode: currency), base: Currency(baseCode: baseCode))
    }
    
    // MARK: - Methods for fetching data for small widget
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
            let timeSeriesArray = timeSeriesData
                .enumerated()
                .map { RatesData(code: results.base, date: keyData[$0.offset], value: timeSeriesData[$0.offset][baseCode] ?? 0) }
            
            return timeSeriesArray
            
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    // MARK: - Methods for making string from date
    func dateString(from date: Date) -> String {
        return formatter.string(from: date)
    }
    
    func yesterdayString() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        return dateString(from: yesterday!)
    }
    
    func stringsForURLs(from date: Date) -> (String, String) {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date)
        return (dateString(from: date), dateString(from: yesterday!))
    }
    
    // MARK: - NetworkErrors
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        
        var localizedDesc: String {
            switch self {
            case .invalidURL:
                return String(localized: "error_invalid_url")
            case .invalidResponse:
                return String(localized: "error_invalid_response")
            case .decodingError:
                return String(localized: "error_decoding")
            }
        }
    }
    
    // MARK: - Date checking refresh
    
    func shouldRefresh() -> Bool {
        let date = getDateFromDefaults()
        let now = Date.now
        
        let difference = now.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
        return difference > 60 * 15 // 15 minutes
    }
    
    private func getDateFromDefaults() -> Date {
        let dateString = defaults.string(forKey: "lastUpdate") ?? "2004-02-23 00:00:00" // my birthday :)
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: dateString)!
    }
    
    private func saveDate() {
        let date = Date.now
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = formatter.string(from: date)
        defaults.set(dateString, forKey: "lastUpdate")
    }
    
}
