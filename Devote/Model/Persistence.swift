//
//  Persistence.swift
//  Devote
//
//  Created by MarthaBakManis on 18/01/25.
//

import CoreData

struct PersistenceController {
  
  // MARK: - 1. PERSISTEN CONTROLLER
  static let shared = PersistenceController()
  
  // MARK: - 2. PERSISTENT CONTROLLER
  let container: NSPersistentContainer
  
  // MARK: - 3. INITITALIZATION (load the persistent store)
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "Devote")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
  
  // MARK: - 4. PREVIEW
  @MainActor
  static let preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for _ in 0..<10 {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
    }
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
}
