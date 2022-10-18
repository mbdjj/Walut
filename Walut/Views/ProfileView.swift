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
//            HStack {
//                Spacer()
//
//                Text(model.letter)
//                    .font(.system(.largeTitle))
//                    .bold()
//                    .padding(24)
//                    .foregroundColor(.white)
//                    .background(
//                        Color.accentColor
//                            .clipShape(Circle())
//                    )
//
//                Spacer()
//            }
            
            Section {
                TextField(String(localized: "your_name"), text: $model.name)
                
                Picker(String(localized: "title"), selection: $model.selectedTitle) {
                    ForEach($model.titlePickerData, id: \.self) { titleID in
                        Text("\(model.titleArray[titleID.wrappedValue])" as String)
                    }
                }
            } header: {
                Text(String(localized: "change_data"))
            }
        }
        .navigationTitle(String(localized: "profile"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(String(localized: "save")) {
                model.save()
                presentationMode.wrappedValue.dismiss()
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
