//
//  NetworkManager.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation
import SwiftUI

struct NetworkManager {
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private let allCodesArray: [String]
    private let defaults = UserDefaults.standard
    private let sharedDefaults = UserDefaults(suiteName: "group.dev.bartminski.Walut")!
    
    static let shared = NetworkManager()
    
    init() {
        allCodesArray = SharedDataManager.shared.allCodesArray
    }
    
    
    // MARK: - Methods for fetching currency data
    func getCurrencyData(for base: Currency) async throws -> [Currency] {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(base.code)")
        else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            
            let currencyArray = self.allCodesArray.map {
                Currency(code: $0, rate: results.rates.getRate(of: $0))
            }
            
            print("Fetched currency data for \(base.code)")
            let nextUpdate = Date(timeIntervalSince1970: Double(results.timeNextUpdateUnix))
            self.saveData(date: nextUpdate, base: base.code)
            
            return currencyArray
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getData(for currency: Currency, base: Currency) async throws -> Currency {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(base.code)") else {
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
    
    // MARK: - Methods for fetching data for small widget
    func getSmallWidgetData(for currencyCode: String, baseCode: String) async throws -> Currency {
        
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(baseCode)") else {
            throw NetworkError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            let currency = Currency(code: currencyCode, rate: results.rates.getRate(of: currencyCode))
            
            return currency
            
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    // MARK: - Methods for making string from date
    
    func yesterdayString() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        return SharedDataManager.shared.customString(from: yesterday!)
    }
    
    func stringsForURLs(from date: Date) -> (String, String) {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date)
        return (SharedDataManager.shared.customString(from: date), SharedDataManager.shared.customString(from: yesterday!))
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
        let data = getDataFromDefaults()
        let now = Date.now
        
        let result = data.date < now || data.base != SharedDataManager.shared.base.code
        print("shouldRefresh() returned \(result)")
        return result
    }
    
    private func getDataFromDefaults() -> (date: Date, base: String) {
        let interval = sharedDefaults.integer(forKey: "nextUpdate")
        let baseCode = sharedDefaults.string(forKey: "nextUpdateBase") ?? ""
        let date = Date(timeIntervalSince1970: Double(interval))
        
        return (date: date, base: baseCode)
    }
    
    private func saveData(date: Date, base: String) {
        print("Saved next update date \(date.formatted(date: .numeric, time: .standard))")
        let interval = Int(date.timeIntervalSince1970)
        sharedDefaults.set(interval, forKey: "nextUpdate")
        sharedDefaults.set(base, forKey: "nextUpdateBase")
    }
    
}
