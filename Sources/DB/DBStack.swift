import CoreData
import Foundation

open class DBStack {

   public enum ContextAction: String {
      case delete, modify, fetch
   }

   private(set) lazy var mainContext = setupMainContext()
   private(set) lazy var writerContext = setupWriterContext()

   private(set) lazy var model = setupModel()
   private(set) lazy var coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

   public init() {
   }

   /// Default value is **DB.sqlite**
   open var storeName: String {
      return "DB.sqlite"
   }

   /// Default value is **DB.momd**
   open var modelName: String {
      return "DB.momd"
   }

   /// Default value is **~/Library/Application Support/app.local.storage**
   open var storeDirectory: URL {
      return FileManager.applicationSupportDirectory.appendingPathComponent("app.local.storage")
   }
}

extension DBStack {

   public var isStoreExists: Bool {
      return FileManager.default.regularFileExists(at: storeURL)
   }

   public func addPersistentStore(type storeType: PersistentStoreType? = nil) throws {
      let isInMemoryStore = RuntimeInfo.isUnderTesting || RuntimeInfo.isInMemoryStore
      let storeTypeFromRuntime: PersistentStoreType = isInMemoryStore ? .memory : .sql
      let storeType = storeType ?? storeTypeFromRuntime
      switch storeType {
      case .memory:
         try coordinator.addPersistentStore(ofType: storeType.stringValue, configurationName: nil, at: nil, options: nil)
      case .sql:
         try addSQLPersistentStore()
      }
   }

   private func addSQLPersistentStore() throws {
      let storeType = PersistentStoreType.sql
      let url = storeURL
      try setupDirectoryStructureIfNeeded(url: storeDirectory)
      logger.debug(.setup, "SQLite url: \(url)")
      let options = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true
      ]
      try coordinator.addPersistentStore(ofType: storeType.stringValue, configurationName: nil, at: url, options: options)
   }

   public func makeBackgroundContext<T>(for type: T.Type, action: ContextAction) -> NSManagedObjectContext {
      let contextID = Settings.Key.identifier(for: type) + "-" + action.rawValue
      return makeBackgroundContext(named: contextID)
   }

   public func makeBackgroundContext(named: String? = nil) -> NSManagedObjectContext {
      let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      if let mocName = named {
         privateMOC.descriptiveName = mocName
      }
      privateMOC.parent = mainContext
      return privateMOC
   }

   public func makeMainContext<T>(for type: T.Type, action: ContextAction) -> NSManagedObjectContext {
      let contextID = Settings.Key.identifier(for: type) + "-" + action.rawValue
      return makeMainContext(named: contextID)
   }

   public func makeMainContext(named: String? = nil) -> NSManagedObjectContext {
      let privateMOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      if let mocName = named {
         privateMOC.descriptiveName = mocName
      }
      privateMOC.parent = mainContext
      return privateMOC
   }

   public func deleteStoreDirectory() throws {
      let url = storeDirectory
      if FileManager.default.directoryExists(at: url) {
         try FileManager.default.removeItem(at: url)
      }
   }
}

extension DBStack {

   public var storeURL: URL {
      let storeURL = storeDirectory.appendingPathComponent(storeName)
      return storeURL
   }

   private func setupModel() -> NSManagedObjectModel {
      let bundle = Bundle(for: type(of: self))
      let baseName = modelName.deletingPathExtension
      let extName = modelName.pathExtension
      guard let modelURL = bundle.url(forResource: baseName, withExtension: extName) else {
         fatalError("Error loading model from bundle: \(bundle).")
      }

      // It is a fatal error for the application not to be able to find and load its model.
      guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
         fatalError("Error initializing mom from: \(modelURL)")
      }
      return mom
   }

   private func setupMainContext() -> NSManagedObjectContext {
      let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      moc.parent = writerContext
      moc.descriptiveName = "app.db.context-main"
      return moc
   }

   private func setupWriterContext() -> NSManagedObjectContext {
      let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      moc.persistentStoreCoordinator = coordinator
      moc.descriptiveName = "app.db.context-writer"
      return moc
   }

   private func setupDirectoryStructureIfNeeded(url: URL) throws {
      if !FileManager.default.directoryExists(at: url) {
         try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
      }
   }
}
