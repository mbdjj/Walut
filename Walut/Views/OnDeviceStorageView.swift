//
//  OnDeviceStorageView.swift
//  Walut
//
//  Created by Marcin Bartminski on 19/11/2023.
//

import SwiftUI

struct OnDeviceStorageView: View {
    
    @Environment(AppSettings.self) var settings
    
    @State var selected: StorageSavingOptions
    @State var showAlert: Bool = false
    @State var showAlertAll: Bool = false
    
    @Environment(\.modelContext) var modelContext
    
    init(settings: AppSettings) {
        selected = settings.storageOption
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
                        settings.updateStorageOption(to: selected)
                    }
                } message: {
                    Text("storage_alert_message")
                }

            } footer: {
                Text("storage_footer")
            }
            
            Section {
                Button(role: .destructive) {
                    showAlertAll = true
                } label: {
                    Label("storage_delete_all_data", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }
                .alert("storage_alert_title", isPresented: $showAlertAll) {
                    Button("cancel", role: .cancel) {
                        showAlertAll = false
                    }
                    
                    Button("continue", role: .destructive) {
                        try? modelContext.delete(model: SavedCurrency.self, where: #Predicate {
                            $0.nextRefresh > 0
                        })
                    }
                } message: {
                    Text("storage_alert_message_all")
                }
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
            .disabled(selected == settings.storageOption)
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
    OnDeviceStorageView(settings: AppSettings())
}
