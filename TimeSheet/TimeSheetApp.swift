//
//  TimeSheetApp.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/24.
//

import SwiftUI

@main
struct TimeSheetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
