//
//  ListView.swift
//  TestSwiftUI
//
//  Created by Kruthay Donapati on 10/1/23.
//

import Foundation
import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var items: FetchedResults<Item>

    @EnvironmentObject var controller : PersistenceController
    
    var body: some View {
        Text("Count \(items.count)")
        NavigationView {
            List {
                ForEach(items) { item in
                    if let itemDate = item.timestamp {
                        NavigationLink {
                            Text("Item at \(itemDate, formatter: itemFormatter)")
                        } label: {
                            Text(String(item.value))
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: controller.addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

