//
//  ScrollView+LazyVstack.swift
//  TestSwiftUI
//
//  Created by Kruthay Donapati on 10/1/23.
//

import SwiftUI

struct ScrollView_LazyVstack: View {
    var items: FetchedResults<Item>
    @State var editViewButton = false
    @State private var itemName: String = ""
    @EnvironmentObject var controller : PersistenceController
    
    var body: some View {
        // Tried using List but it's too slow for more than 10000 records
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(items) { item in
                        if let itemDate = item.timestamp {
                            NavigationLink {
                                Text("Item at \(itemDate, formatter: itemFormatter)")
                            } label: {
                                Text(String(item.value))
                            }
                        }
                        Divider()
                    }

                }
                .padding()
                .border(.secondary)
            }

            .toolbar {
                ToolbarItem {
                    Button(action: controller.addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitle("ScrollView + LazYViewStack", displayMode : .inline)
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
