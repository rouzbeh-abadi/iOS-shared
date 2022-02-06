import CoreData
import Foundation

extension NSManagedObjectContextConcurrencyType: CustomStringConvertible {

   public var description: String {
      switch self {
      case .confinementConcurrencyType:
         return "confinement"
      case .mainQueueConcurrencyType:
         return "main"
      case .privateQueueConcurrencyType:
         return "private"
      @unknown default: return "unknown"
      }
   }
}
