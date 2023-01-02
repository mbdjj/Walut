//
//  DatePickView.swift
//  Walut
//
//  Created by Marcin Bartminski on 02/01/2023.
//

import SwiftUI

struct DatePickView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var shouldShowDatePicker = false
    
    @ObservedObject var model = DatePickViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Choose date", selection: $model.pickerValue) {
                        Text("date_current")
                            .tag(0)
                        Text("date_custom")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    if shouldShowDatePicker {
                        DatePicker(selection: $model.customDate, in: model.range, displayedComponents: .date) {
                            Text("")
                        }
                        .datePickerStyle(.graphical)
                    }
                } header: {
                    Text("date_mode")
                }
            }
            .navigationTitle("date_historical_rates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        model.savePickerValue()
                        dismiss.callAsFunction()
                    } label: {
                        Text("save")
                            .bold()
                    }
                }
            }
            .onAppear {
                withAnimation {
                    shouldShowDatePicker = model.pickerValue == 1
                }
            }
            .onChange(of: model.pickerValue) { value in
                withAnimation {
                    shouldShowDatePicker = value == 1
                }
            }
        }
        .interactiveDismissDisabled(model.changed)
    }
}

struct DatePickView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickView()
    }
}
