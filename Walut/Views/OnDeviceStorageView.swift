//
//  OnDeviceStorageView.swift
//  Walut
//
//  Created by Marcin Bartminski on 19/11/2023.
//

import SwiftUI

struct OnDeviceStorageView: View {
    
    @State var selected: StorageSavingOptions = .oneMonth
    
    var body: some View {
        List {
            Section {
                Picker("", selection: $selected) {
                    ForEach(StorageSavingOptions.allCases, id: \.self) { option in
                        Text(option.title)
                    }
                }
                .labelsHidden()
                .pickerStyle(.inline)
            } footer: {
                Text("storage_footer")
            }

        }
        .navigationTitle("settings_save_data")
    }
}

enum StorageSavingOptions: CaseIterable {
    case oneDay
    case oneWeek
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear
}

extension StorageSavingOptions {
    var title: String {
        switch self {
        case .oneDay:
            String(localized: "storage_1d")
        case .oneWeek:
            String(localized: "storage_1w")
        case .oneMonth:
            String(localized: "storage_1m")
        case .threeMonths:
            String(localized: "storage_3m")
        case .sixMonths:
            String(localized: "storage_6m")
        case .oneYear:
            String(localized: "storage_1y")
        }
    }
}

#Preview {
    OnDeviceStorageView()
}
