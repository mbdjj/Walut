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
            
            self.products = sortedByPrice(products)
        } catch {
            print(error)
        }
    }
    
    func sortedByPrice(_ array: [Product]) -> [Product] {
        return array.sorted { $0.price < $1.price }
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            //await updateContent()
            
            await transaction.finish()
            
            return transaction
        case .pending, .userCancelled:
            return nil
        default:
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
                    
                    print("Verified")
                    //await updateContent()
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
}
