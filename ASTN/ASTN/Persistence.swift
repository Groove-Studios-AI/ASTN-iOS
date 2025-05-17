import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // IMPORTANT: "ASTNAppModel" should be the name of your .xcdatamodeld file
        container = NSPersistentContainer(name: "ASTNAppModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Preview provider for SwiftUI previews
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // TODO: Add sample data creation here for previews if needed, 
        // after you have generated your NSManagedObject subclasses.
        // Example (assuming you have a UserEntity):
        // let newUser = UserEntity(context: viewContext)
        // newUser.id = UUID()
        // newUser.username = "sampleUserPreview"
        // newUser.email = "preview@example.com"
        // newUser.createdAt = Date()
        // // ... and so on for other required attributes for UserEntity.

        // // You'll need to repeat this for other key entities for comprehensive previews.
        // // For instance, creating a sample ModuleEntity:
        // // let newModule = ModuleEntity(context: viewContext)
        // // newModule.id = UUID()
        // // newModule.title = "Sample Module"
        // // newModule.type = "COURSE" // Assuming type is a String, adjust if it's an enum or other
        // // newModule.category = "WEALTH"

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // Helper function to save the context
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                NSLog("Unresolved error saving context: \(nsError), \(nsError.userInfo)")
                // In a real app, you might want to handle this more gracefully
            }
        }
    }
}
