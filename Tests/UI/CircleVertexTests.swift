import Foundation
@testable import PIASPMShared
@testable import PIATestsShared

class CircleVertexTests: AppTestCase {

   func test_default() {
      let vertex = CircleVertex()
      let vertices = vertex.toVertices()
      Assert.equals(vertices.count, 540)
   }

   func test_minimal() {
      let vertex = CircleVertex()
      let vertices = vertex.toVertices(perimeterPoints: 4)
      Assert.equals(vertices.count, 6)
   }

   func test_withCoordinates() {
      let vertex = CircleVertex(x: 10, y: 20, diamater: 5)
      let vertices = vertex.toVertices(perimeterPoints: 10)
      Assert.equals(vertices.count, 15)
   }
}
