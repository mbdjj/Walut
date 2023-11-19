//
//  OnDeviceStorageView.swift
//  Walut
//
//  Created by Marcin Bartminski on 19/11/2023.
//

import SwiftUI

struct OnDeviceStorageView: View {
    
    @State var selected: StorageSavingOptions
    @State var showAlert: Bool = false
    let shared = SharedDataManager.shared
    
    init() {
        _selected = State(initialValue: shared.storageOption)
    }
    
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
                .alert("storage_alert_title", isPresented: $showAlert) {
                    Button("cancel", role: .cancel) {
                        showAlert = false
                    }
                    
                    Button("continue", role: .destructive) {
                        shared.storageOption = selected
                        UserDefaults.standard.set(selected.rawValue, forKey: "storageOptions")
                    }
                } message: {
                    Text("storage_alert_message")
                }

            } footer: {
                Text("storage_footer")
            }

        }
        .navigationTitle("settings_save_data")
        .toolbar {
            Button {
                showAlert = true
            } label: {
                Text("save")
                    .bold()
            }
            .disabled(selected == shared.storageOption)
        }
    }
}

extension StorageSavingOptions {
    var title: String {
        switch self {
        case .twoDays:
            String(localized: "storage_2d")
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
