//
//  SavedCurrency.swift
//  Walut
//
//  Created by Marcin Bartminski on 19/11/2023.
//

import Foundation
import SwiftData

typealias SavedCurrency = SavedCurrencyV2.SavedCurrency

enum SavedCurrencyV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [SavedCurrency.self]
    }
    
    @Model class SavedCurrency {
        let code: String
        let base: String
        let rate: Double
        
        let nextRefresh: Int
        let dateSaved: Date
        
        init(code: String, base: String, rate: Double, nextRefresh: Int, dateSaved: Date = .now) {
            self.code = code
            self.base = base
            self.rate = rate
            self.nextRefresh = nextRefresh
            self.dateSaved = dateSaved
        }
        
        var idString: String { "\(base)+\(code)+\(nextRefresh)" }
    }
}

enum SavedCurrencyV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [SavedCurrency.self]
    }
    
    @Model class SavedCurrency {
        @Attribute(.unique) let dataIdentity: String
        
        let code: String
        let base: String
        let rate: Double
        
        let nextRefresh: Int
        let dateSaved: Date
        
        init(code: String, base: String, rate: Double, nextRefresh: Int, dateSaved: Date = .now) {
            self.dataIdentity = "\(base)+\(code)+\(nextRefresh)"
            self.code = code
            self.base = base
            self.rate = rate
            self.nextRefresh = nextRefresh
            self.dateSaved = dateSaved
        }
    }
}

enum SavedCurrencyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SavedCurrencyV1.self, SavedCurrencyV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: SavedCurrencyV1.self,
        toVersion: SavedCurrencyV2.self,
        willMigrate: { context in
            let saved = try context.fetch(FetchDescriptor<SavedCurrencyV1.SavedCurrency>())
            
            for currency in saved {
                context.delete(currency)
            }
            
            try context.save()
        },
        didMigrate: nil
    )
}
