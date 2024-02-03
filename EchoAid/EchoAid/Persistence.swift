//
//  Persistence.swift
//  EchoAid
//
//  Created by fzfzlfz on 2/3/24.
//

import CoreData

class PersistenceController : ObservableObject {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let defaultItem = RecordedAudio(context: viewContext)
        defaultItem.uid = "uid1"
        defaultItem.audioFilename = "audio1"
        for _ in 0..<10 {
            let randomNum = Int.random(in: 100000...999999)
            let randomNumStr = String(randomNum)
            
            let newItem = RecordedAudio(context: viewContext)
            // Attach the random number to each attribute
            newItem.uid = "uid" + randomNumStr
            newItem.audioFilename = "audio" + randomNumStr
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
        container = NSPersistentContainer(name: "EchoAid")
        if inMemory {
            if let storeDescription = container.persistentStoreDescriptions.first {
                storeDescription.url = URL(fileURLWithPath: "/dev/null")
            } else {
                fatalError("No Persistent Store Description found.")
            }
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
