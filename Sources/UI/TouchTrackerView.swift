//
//  TouchTrackerView.swift
//  PIAShared
//
//  Created by Rouzbeh Abadi on 14.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

public class TouchTrackerView: UIView {

   public enum Event {
      case changed
   }

   public var eventHandler: ((Event) -> Void)?

   var path = UIBezierPath()

   public override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
   }

   required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let first = touches.first {
         path.move(to: first.location(in: self))
      }
   }

   public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      addLine(touches: touches)
   }

   public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      addLine(touches: touches)
   }

   public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      addLine(touches: touches)
   }

   public override func draw(_: CGRect) {
      UIColor.magenta.setStroke()
      path.stroke()
   }
}

extension TouchTrackerView {

   public var isEmpty: Bool {
      return path.isEmpty
   }

   public func clear() {
      path.removeAllPoints()
      setNeedsDisplay()
   }

   public func annotation(over background: UIImage) -> UIImage? {
      guard !path.isEmpty else {
         return nil
      }
      let drawingSize = background.size
      let drawingRect = CGRect(origin: CGPoint(), size: drawingSize)
      UIGraphicsBeginImageContextWithOptions(drawingSize, true, 0)
      background.draw(in: drawingRect)
      drawHierarchy(in: drawingRect, afterScreenUpdates: true)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
   }
}

extension TouchTrackerView {

   private func setupUI() {
      isOpaque = false
      backgroundColor = UIColor.clear
      path.lineWidth = 6
   }

   private func addLine(touches: Set<UITouch>) {
      if let first = touches.first {
         let location = first.location(in: self)
         path.addLine(to: location)
         setNeedsDisplay()
      }
      eventHandler?(.changed)
   }
}
#endif
