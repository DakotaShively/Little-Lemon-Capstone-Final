//
//  Little_LemonApp.swift
//  Little Lemon
//
//  Created by Dakota Shively on 7/17/23.
//

import SwiftUI

@main
struct Little_LemonApp: App {
    let persistence = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
