//
//  ProfileView.swift
//  Walut
//
//  Created by Marcin Bartminski on 18/10/2022.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var model = ProfileViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section {
                TextField(String(localized: "your_name"), text: $model.name)
            } header: {
                Text("change_data")
            }
            
            Section {
                Picker(String(localized: "title"), selection: $model.selectedTitle) {
                    ForEach($model.titlePickerData, id: \.self) { titleID in
                        Text("\(model.titleArray[titleID.wrappedValue])" as String)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            } header: {
                Text("title")
            }
        }
        .navigationTitle(String(localized: "profile"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                model.save()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text(String(localized: "save"))
                    .bold()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
