//
//  TestSwiftUIApp.swift
//  TestSwiftUI
//
//  Created by Kruthay Donapati on 10/1/23.
//

import SwiftUI

@main
struct TestSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
