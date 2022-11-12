//
//  SupportDevViewModel.swift
//  Walut
//
//  Created by Marcin Bartminski on 03/11/2022.
//

import SwiftUI
import StoreKit

class SupportDevViewModel: ObservableObject {
    
    @Published var products = [Product]()
    @Published var shouldShowThanks = false
    @Published var shouldDisableButtons = false
    var titleToPresent = ""
    var arrayToSave = [Int]()
    
    let shared = SharedDataManager.shared
    let defaults = UserDefaults.standard
    
    var taskHandle: Task<Void, Error>?
    
    init() {
        
        taskHandle = listenForTransactions()
        
        Task.init {
            await requestProducts()
        }
    }
    
    func requestProducts() async {
        do {
            let products = try await Product.products(for: ["ga.bartminski.WalutApp.SupportSmall", "ga.bartminski.WalutApp.SupportMedium"])
            
            DispatchQueue.main.async {
                self.products = self.sortedByPrice(products)
            }
        } catch {
            print(error)
        }
    }
    
    private func sortedByPrice(_ array: [Product]) -> [Product] {
        return array.sorted { $0.price < $1.price }
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        DispatchQueue.main.async {
            self.shouldDisableButtons = true
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            updateContent(for: product.id)
            
            await transaction.finish()
            
            DispatchQueue.main.async {
                self.shouldDisableButtons = false
            }
            
            return transaction
        case .pending, .userCancelled:
            DispatchQueue.main.async {
                self.shouldDisableButtons = false
            }
            
            return nil
        default:
            DispatchQueue.main.async {
                self.shouldDisableButtons = false
            }
            
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            print("Unverified transaction")
            throw StoreKitError.notEntitled
        case .verified(let safe):
            return safe
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    self.updateContent(for: transaction.productID)
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func updateContent(for productID: String) {
        
        var titleID = 0
        
        if productID == "ga.bartminski.WalutApp.SupportSmall" {
            titleID = 3
        } else if productID == "ga.bartminski.WalutApp.SupportMedium" {
            titleID = 4
        }
        
        titleToPresent = shared.titleArray[titleID]
        var titleIDArray = shared.titleIDArray
        
        if titleIDArray.firstIndex(of: titleID) == nil {
            titleIDArray.append(titleID)
            defaults.set(titleIDArray, forKey: "titleIDArray")
        }
        
        arrayToSave = titleIDArray
        
        DispatchQueue.main.async {
            self.shouldShowThanks = true
        }
    }
    
}
