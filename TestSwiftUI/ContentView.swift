//
//  ContentView.swift
//  TestSwiftUI
//
//  Created by Kruthay Donapati on 10/1/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.value, ascending: true)], animation: .easeInOut(duration: 0.5)) private var items: FetchedResults<Item>

    @EnvironmentObject var controller : PersistenceController
    @State var numberOfItems = 1
    @State private var sortBy = SortType.name
    var body: some View {
        Picker(selection: $sortBy, label: Text("Sort Garments")) {
            Text("Alpha").tag(SortType.name)
            Text("Creation Time").tag(SortType.creationDate)
        }
        .pickerStyle(.segmented)
        .padding()
        NavigationStack {

            NavigationLink {
                ListView(items: items)
            } label: {
                Text("List")
            }
            
            
            NavigationLink {
                ScrollView_LazyVstack(items: items )
            } label: {
                Text("ScrollView+LazyVstack")
            }
            .navigationTitle("Test ScrollView + LazyVStack vs List")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .onChange(of: sortBy) { newSortedValue in
            switch newSortedValue {
            case .name:
                items.nsSortDescriptors = [NSSortDescriptor(keyPath: \Item.value, ascending: true)]
            case .creationDate:
                items.nsSortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)]
            }
        }
        Spacer()
        
        VStack(spacing:1) {
            HStack {
                Spacer()
                Text("Add Number of Items")
                TextField("Add NumberOf Items", value: $numberOfItems, formatter: NumberFormatter())
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
            }
            Button("Save \(numberOfItems) Items") {
                controller.saveItems(numberOfItems: numberOfItems )
            }
            Button(action: controller.deleteAll) {
                Label("Delete All", systemImage: "trash")
            }
        }
        
    }
}

enum SortType {
    case name
    case creationDate
}
