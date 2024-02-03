//
//  EchoAidApp.swift
//  EchoAid
//
//  Created by fzfzlfz on 2/3/24.
//

import SwiftUI

@main
struct EchoAidApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
