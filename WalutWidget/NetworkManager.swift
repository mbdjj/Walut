//
//  NetworkManager.swift
//  WalutWidgetExtension
//
//  Created by Marcin Bartminski on 17/11/2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let decoder = JSONDecoder()
    
    private init() {
        
    }
    
    func getCurrentPrice(for currencyCode: String, baseCode: String) async throws -> [RatesData] {
        
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
    
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
