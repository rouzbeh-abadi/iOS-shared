import Foundation

private let tracer = Log<AppLogCategory>(subsystem: "net")

extension URLSession {

   public typealias DataResult = Swift.Result<Data, Swift.Error>
   public typealias JsonResult<Key: Hashable, Value> = Swift.Result<[Key: Value], Swift.Error>
   public typealias ObjectResult<T> = Swift.Result<T, Swift.Error>

   public func dataTask(request: Request, completion: @escaping (DataResult) -> Void) throws -> URLSessionDataTask {
      let urlRequest = try request.toURLRequest()
      let shouldSaveTracesToFile = self.shouldSaveTracesToLogFile
      type(of: self).logRequest(urlRequest, shouldSaveTracesToFile: shouldSaveTracesToFile)
      let task = httpDataTask(with: urlRequest) { result in
         switch result {
            case .failure(let error):
               completion(.failure(error))
            case .success(let data, let response):
               type(of: self).logResponse(urlRequest, response, data: data, shouldSaveTracesToFile: shouldSaveTracesToFile)
               if request.isAccepted(statusCode: response.statusCode) {
                  completion(.success(data))
               } else {
                  if let error = request.error(from: data) {
                     completion(.failure(error))
                  } else {
                     completion(.failure(ResponseError.unexpectedStatusCode(response.statusCode)))
                  }
               }
         }
      }
      return task
   }

   public func jsonTask<Key: Hashable, Value>(request: Request,
                                       completion: @escaping (JsonResult<Key, Value>) -> Void) throws -> URLSessionDataTask {
      let task = try dataTask(request: request) {
         switch $0 {
         case .failure(let error):
            completion(.failure(error))
         case .success(let data):
            do {
               let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
               if let json = jsonObject as? [Key: Value] {
                  completion(.success(json))
               } else {
                  completion(.failure(ResponseError.unexpectedResponseDataType(type(of: jsonObject), expected: [Key: Value].self)))
               }
            } catch {
               completion(.failure(error))
            }
         }
      }
      return task
   }

   public func objectTask<T: Decodable>(_: T.Type, request: Request,
                                 completion: @escaping (ObjectResult<T>) -> Void) throws -> URLSessionDataTask {
      let task = try dataTask(request: request) {
         switch $0 {
         case .failure(let error):
            completion(.failure(error))
         case .success(let data):
            do {
               let responseValue = try JSONDecoder.makeDefault().decode(T.self, from: data)
               completion(.success(responseValue))
            } catch {
               completion(.failure(error))
            }
         }
      }
      return task
   }
}

extension URLSession {

   private struct Key {
      static var shouldSaveTracesToLogFile = "app.ui.shouldSaveTracesToLogFile"
   }

   public var shouldSaveTracesToLogFile: Bool {
      get {
         return ObjCAssociation.value(from: self, forKey: &Key.shouldSaveTracesToLogFile) ?? false
      } set {
         ObjCAssociation.setCopyNonAtomic(value: newValue, to: self, forKey: &Key.shouldSaveTracesToLogFile)
      }
   }
}

extension URLSession {

   private static func prettyPrinted(data: Data?) -> String? {
      guard let data = data else {
         return nil
      }
      if data.isEmpty {
         return "Data response is zero length."
      }
      do {
         let json = try JSONSerialization.jsonObject(with: data, options: [])
         let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
         return String(data: data, encoding: .utf8)
      } catch {
         return nil
      }
   }

   public static func logRequest(_ urlRequest: URLRequest,
                                 shouldSaveTracesToFile: Bool = true) {
      let message = "Task (\(urlRequest.httpMethod ?? "Unknown")): \(urlRequest.url?.absoluteString ?? "Unknown")"
      tracer.debug(.request, message)
      let shouldTrace = RuntimeInfo.isNetworkTracingEnabled && RuntimeInfo.isLocalRun && RuntimeInfo.isTracingEnabled
      if shouldTrace {
         if let string = prettyPrinted(data: urlRequest.httpBody) {
            tracer.trace(">>>\n\(message)\n\(string)\n", shouldSaveToFile: shouldSaveTracesToFile)
         } else {
            tracer.trace(">>>\n\(message)", shouldSaveToFile: shouldSaveTracesToFile)
         }
      }
   }

   public static func logResponse(_ urlRequest: URLRequest, _ response: HTTPURLResponse, data: Data,
                                  shouldSaveTracesToFile: Bool = true) {
      guard let url = response.url else {
         return
      }
      let message = "Task (\(urlRequest.httpMethod ?? "Unknown")) finished [\(response.statusCode)]: \(url.absoluteString)"
      tracer.debug(.response, message)
      let shouldTrace = RuntimeInfo.isNetworkTracingEnabled && RuntimeInfo.isLocalRun && RuntimeInfo.isTracingEnabled
      if shouldTrace {
         if let string = prettyPrinted(data: data) {
            tracer.trace("<<<\n\(message)\n\(string)\n", shouldSaveToFile: shouldSaveTracesToFile)
         } else {
            tracer.trace("<<<\n\(message)", shouldSaveToFile: shouldSaveTracesToFile)
         }
      }
   }
}
