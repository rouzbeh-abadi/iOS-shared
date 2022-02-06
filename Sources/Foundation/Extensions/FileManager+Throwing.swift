import Foundation

extension FileManager {

   public class Throwing {
      fileprivate let instance: FileManager
      fileprivate init(instance: FileManager) {
         self.instance = instance
      }
   }

   public var throwing: Throwing {
      return Throwing(instance: self)
   }
}

extension FileManager.Throwing {

   public enum Error: Swift.Error {
      case unableToGetContentsOfFileAtPath(String)
   }

   public func contents(atPath path: String) throws -> Data {
      if let data = instance.contents(atPath: path) {
         return data
      } else {
         throw Error.unableToGetContentsOfFileAtPath(path)
      }
   }
}
