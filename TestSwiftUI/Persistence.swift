//
//  Persistence.swift
//  TestSwiftUI
//
//  Created by Kruthay Donapati on 10/1/23.
//

import CoreData

class PersistenceController : ObservableObject{
    
    var currentValue: Int = 0
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TestSwiftUI")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        
    }
    
     func addItem() {
         let viewContext = self.container.viewContext
            let newItem = Item(context: viewContext)
         newItem.value = Int64(currentValue)
            currentValue += 1
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
    
    
    
    func saveItems(numberOfItems: Int) {
        
        DispatchQueue.global(qos: .background).async {
            let context = self.container.newBackgroundContext()
            for i in self.currentValue..<self.currentValue + numberOfItems  {
                let item = Item(context: context)
                item.id = UUID()
                item.value = Int64(i)
                item.timestamp = Date.now
                if i % 500 == 0 {
                    do {
                        try context.save()
                    } catch {
                        print("Unable to save \(error.localizedDescription)")
                    }
                }
            }
            
            do {
                try context.save()
            } catch {
                print("Unable to save \(error.localizedDescription)")
            }

            self.currentValue += numberOfItems
            DispatchQueue.main.async {
                print("Finished")
            }
        }
    }
    private func getLastSyncTimestamp() -> Int64? {
        let context = self.container.viewContext
    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
    request.entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
    request.resultType = NSFetchRequestResultType.dictionaryResultType

    let keypathExpression = NSExpression(forKeyPath: "timestamp")
    let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])

    let key = "maxTimestamp"

    let expressionDescription = NSExpressionDescription()
    expressionDescription.name = key
    expressionDescription.expression = maxExpression
    expressionDescription.expressionResultType = .integer64AttributeType

    request.propertiesToFetch = [expressionDescription]

    var maxTimestamp: Int64? = nil

    do {

        if let result = try context.fetch(request) as? [[String: Int64]], let dict = result.first {
           maxTimestamp = dict[key]
        }

    } catch {
        assertionFailure("Failed to fetch max timestamp with error = \(error)")
        return nil
    }

    return maxTimestamp
    }

    
    func deleteAll() {
        let context = self.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try context.execute(deleteRequest)
                    try context.save()
                } catch {
                    print("Failed to delete data: \(error)")
                }
    }

    
    
}
