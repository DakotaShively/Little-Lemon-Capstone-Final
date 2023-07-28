//
//  HeroSection.swift
//  Little Lemon
//
//  Created by Dakota Shively on 7/28/23.
//

import SwiftUI

struct HeroSection: View {
    @StateObject private var keyboardHandler = KeyboardHandler()
    var searchText: Binding<String>? = nil
    @State var showSearchField: Bool? = false
    var body: some View {
        VStack(alignment: .leading) {
            if keyboardHandler.keyboardHeight == 0.0 {
                Text("Little Lemon")
                    .foregroundColor(Color.primary2)
                Text("Chicago")
                    .foregroundColor(Color.highlight1)
                HStack(spacing: 0) {
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .foregroundColor(Color.highlight1)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Image("HomeImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .cornerRadius(10)
                }
            }
            if showSearchField == true {
                TextField("Search menu", text: searchText!)
                    .padding(.all)
                    .background(Color.highlight1)
                    .cornerRadius(5)
            }
        }
        .padding(.all)
        .background(Color.primary1)
    }
}

struct HeroSection_Previews: PreviewProvider {
    @State static var searchText = ""
    static var previews: some View {
        HeroSection(searchText: $searchText)
    }
}
