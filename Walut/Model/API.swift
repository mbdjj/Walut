//
//  API.swift
//  Walut
//
//  Created by Marcin Bartminski on 15/06/2024.
//

import Foundation

struct API {
    static private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    static private let urlBase = "https://open.er-api.com/v6/latest/"
    
    // MARK: - Networking methods
    
    static func fetchCurrencyRates(for base: Currency, shouldSaveNextUpdate: Bool = true) async throws -> [Currency] {
        guard let url = URL(string: urlBase + base.code)
        else {
            throw APIError.invalidURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let results = try decoder.decode(CurrencyData.self, from: data)
            
            let currencyArray = StaticData.currencyCodes.map {
                Currency(code: $0, rate: results.rates.getRate(of: $0))
            }
            
            print("Fetched currency data for \(base.code)")
            if shouldSaveNextUpdate {
                let nextUpdate = Date(timeIntervalSince1970: Double(results.timeNextUpdateUnix))
                saveNextUpdate(date: nextUpdate, base: base.code)
            }
            
            return currencyArray
        } catch {
            throw APIError.decodingError
        }
    }
    
    static func fetchRate(of currency: Currency, base: Currency) async throws -> Currency {
        let rates = try await fetchCurrencyRates(for: base, shouldSaveNextUpdate: false)
        guard let data = rates.filter({ $0.code == currency.code }).first else {
            throw APIError.decodingError
        }
        return data
    }
    static func fetchRate(of currencyCode: String, baseCode: String) async throws -> Currency {
        return try await fetchRate(of: Currency(baseCode: currencyCode), base: Currency(baseCode: baseCode))
    }
    
    // MARK: - Helper methods

    static func shouldRefresh() -> Bool {
        let data = getDataFromDefaults()
        let now = Date.now

        let result = data.date < now || data.base != UserDefaults.standard.string(forKey: "base")
        print("Should\(result ? "" : "n't") refresh")
        return result
    }

    static private func getDataFromDefaults() -> (date: Date, base: String) {
        let interval = Defaults.nextUpdateInterval()
        let baseCode = Defaults.nextUpdateBaseCode()
        let date = Date(timeIntervalSince1970: Double(interval))

        return (date: date, base: baseCode)
    }
    
    static private func saveNextUpdate(date: Date, base: String) {
        print("Saved next update date \(date.formatted(date: .numeric, time: .standard))")
        let interval = Int(date.timeIntervalSince1970)
        Defaults.saveNextUpdateInterval(interval)
        Defaults.saveNextUpdateBaseCode(base)
    }
    
    // MARK: - Error
    
    enum APIError: Error {
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
}
