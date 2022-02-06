import CoreData
import Foundation

extension NSManagedObjectContext {

   public func perform(workItem: @escaping (NSManagedObjectContext) throws -> Void) throws {
      var operationError: Swift.Error?
      performAndWait {
         do {
            try workItem(self)
         } catch {
            operationError = error
         }
      }
      if let error = operationError {
         throw error
      }
   }

   public func saveIfHasChanges(savingParent: Bool) throws {
      try perform(savingParent: savingParent, workItem: { _ in })
   }

   public func perform(savingParent: Bool, workItem: @escaping (NSManagedObjectContext) throws -> Void) throws {
      var contextHadChanges = false
      var operationError: Swift.Error?
      performAndWait { [unowned self] in
         do {
            try workItem(self)
            contextHadChanges = self.hasChanges
            if contextHadChanges {
               try self.obtainPermanentIDsIfNeeded()
               try self.save()
            }
         } catch {
            operationError = error
         }
      }
      if let error = operationError {
         throw error
      }
      if contextHadChanges, savingParent, let contextToSave = parent {
         try contextToSave.perform(savingParent: savingParent, workItem: { _ in })
      }
   }
}

extension NSManagedObjectContext {

   public func perform(workItem: @escaping ((NSManagedObjectContext) -> Void)) {
      perform {
         workItem(self)
      }
   }

   public func perform<T: AnyObject>(_ caller: T, workItem: @escaping ((T, NSManagedObjectContext) -> Void)) {
      perform { [weak caller] _ in guard let caller = caller else { return }
         workItem(caller, self)
      }
   }
}

extension NSManagedObjectContext {

   public func perform<T>(completion: @escaping Result<T>.Completion, on queue: DispatchQueue,
                          workItem: @escaping ((NSManagedObjectContext) throws -> T)) {
      perform(completion: { result in
         queue.async {
            completion(result)
         }
      }, workItem: workItem)
   }

   public func perform<T>(completion: @escaping Result<T>.Completion,
                          workItem: @escaping ((NSManagedObjectContext) throws -> T)) {
      perform {
         do {
            let result = try workItem(self)
            completion(.success(result))
         } catch {
            completion(.error(error))
         }
      }
   }

   public func perform<T>(savingParent: Bool, completion: @escaping Result<T>.Completion, on queue: DispatchQueue,
                          workItem: @escaping ((NSManagedObjectContext) throws -> T)) {
      perform(savingParent: savingParent, completion: { result in
         queue.async {
            completion(result)
         }
      }, workItem: workItem)
   }

   public func perform<T>(savingParent: Bool, completion: @escaping Result<T>.Completion,
                          workItem: @escaping ((NSManagedObjectContext) throws -> T)) {
      perform {
         do {
            let result = try workItem(self)
            self.saveIfHasChanges(savingParent: savingParent) {
               switch $0 {
               case .error(let error):
                  completion(.error(error))
               case .success:
                  completion(.success(result))
               }
            }
         } catch {
            completion(.error(error))
         }
      }
   }

   public func perform(savingParent: Bool, completion: @escaping Result<Void>.Completion, on queue: DispatchQueue,
                       workItem: @escaping ((NSManagedObjectContext) throws -> Void)) {
      perform(savingParent: savingParent, completion: { result in
         queue.async {
            completion(result)
         }
      }, workItem: workItem)
   }

   public func perform(savingParent: Bool, completion: @escaping Result<Void>.Completion,
                       workItem: @escaping ((NSManagedObjectContext) throws -> Void)) {
      perform {
         do {
            try workItem(self)
            self.saveIfHasChanges(savingParent: savingParent, completion: completion)
         } catch {
            completion(.error(error))
         }
      }
   }

   public func saveIfHasChanges(savingParent: Bool, on queue: DispatchQueue, completion: @escaping (Result<Void>) -> Void) {
      saveIfHasChanges(savingParent: savingParent) { result in
         queue.async {
            completion(result)
         }
      }
   }

   public func saveIfHasChanges(savingParent: Bool, completion: @escaping (Result<Void>) -> Void) {
      perform {
         if self.hasChanges {
            do {
               try self.obtainPermanentIDsIfNeeded()
               try self.save()
               if savingParent, let contextToSave = self.parent {
                  contextToSave.saveIfHasChanges(savingParent: savingParent, completion: completion)
               } else {
                  completion(.success(()))
               }
            } catch {
               completion(.error(error))
            }
         } else {
            completion(.success(()))
         }
      }
   }
}

extension NSManagedObjectContext {

   public func insert<T: Collection>(_ objects: T) where T.Iterator.Element: NSManagedObject {
      objects.forEach {
         insert($0)
      }
   }

   public func delete<T: Collection>(_ objects: T) where T.Iterator.Element: NSManagedObject {
      objects.forEach {
         delete($0)
      }
   }
}

extension NSManagedObjectContext {

   public func fetchFirst<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> T? {
      request.fetchLimit = 1
      let objects = try fetch(request)
      return objects.first
   }
}

extension NSManagedObjectContext {

   // See also: https://stackoverflow.com/questions/11336120/when-to-call-obtainpermanentidsforobjects
   private func obtainPermanentIDsIfNeeded() throws {
      guard let parent = parent, parent.concurrencyType == .mainQueueConcurrencyType else {
         return
      }
      let objects = Array(insertedObjects) + Array(updatedObjects)
      if !objects.isEmpty {
         try obtainPermanentIDs(for: objects)
      }
   }

   private struct AssociatedKeys {
      static var descriptiveName = "com.app.descriptiveName"
   }

   public var descriptiveName: String {
      get {
         var value = ""
         performAndWait {
            value = (self.userInfo[AssociatedKeys.descriptiveName] as? String) ?? String(format: "%p", pointerAddress(of: self))
         }
         return value
      } set {
         perform {
            self.userInfo[AssociatedKeys.descriptiveName] = newValue
         }
      }
   }

   public func dump() -> String {
      let values = ["name \(descriptiveName)",
                    "inserted \(insertedObjects.count)",
                    "deleted \(deletedObjects.count)",
                    "updated \(updatedObjects.count)"]
      return values.joined(separator: ", ")
   }
}
