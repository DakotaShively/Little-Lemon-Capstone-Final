//
//  MenuBreakdown.swift
//  Little Lemon
//
//  Created by Dakota Shively on 7/28/23.
//

import SwiftUI

enum MenuBreakdownCases : String, CaseIterable {
    case Starters = "Starters"
    case Mains = "Mains"
    case Desserts = "Desserts"
    case Drinks = "Drinks"
}

struct MenuBreakdown: View {
    @Binding var selectedCategory: String
    var body: some View {
        VStack {
            HStack {
                Text("ORDER FOR DELIEVERY!")
                Spacer()
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(MenuBreakdownCases.allCases, id: \.self) { option in
                        Text(option.rawValue)
                            .padding(.all)
                            .background(selectedCategory == option.rawValue ? Color.primary2 : Color.highlight1)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedCategory = selectedCategory == option.rawValue ? "" :  option.rawValue
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}

struct MenuBreakdown_Previews: PreviewProvider {
    @State static var selecteCategory = ""
    static var previews: some View {
        MenuBreakdown(selectedCategory: $selecteCategory)
    }
}
