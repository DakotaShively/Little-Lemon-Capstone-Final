//
//  MenuList.swift
//  Little Lemon
//
//  Created by Dakota Shively on 7/19/23.
//

import Foundation

struct MenuItem: Codable, Identifiable {
    var id: Int
    let title: String
    let image: String
    let price: String
}

struct MenuList: Decodable {
    let menu: [MenuItem]
}
