//
//  CustomView.swift
//  ToothTimer
//
//  Created by Feldmaus on 07.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import UIKit

class CirclesView: UIView
{
  var ringLayers:[Ring]                       = []
  var ringGeometry                            = RingGeometry(frame: CGRect.null, ringCount: 0)
  var actualAnimatedRing                      = -1
  var totalAnimationDuration:CFTimeInterval   = 0.0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.initView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.initView()
  }

  func initView() {
    for l in self.ringLayers {
      l.backgroundLayer.removeFromSuperlayer()
      l.gradientLayer.removeFromSuperlayer()
    }
    
    self.ringLayers = []
    for i in 0..<ToothTimerSettings.sharedInstance.noOfSlices!.intValue
    { let r = Ring(position: i)
      
      self.layer.addSublayer(r.backgroundLayer)
      self.layer.addSublayer(r.gradientLayer)
      self.ringLayers.append(r)
    } /* of for */
    
    self.ringGeometry = RingGeometry(frame: self.frame,ringCount: self.ringLayers.count)
  }
  
  fileprivate func startNextAnimation() -> Void
  { let animatedLayer = self.ringLayers[actualAnimatedRing]
    
    CATransaction.begin()
    CATransaction.setCompletionBlock
      { () -> Void in
        
        print("Animation \(self.actualAnimatedRing) completed")

        if self.actualAnimatedRing>=0 && self.actualAnimatedRing<self.ringLayers.count-1
        {
          /*
          self.ringLayers[self.actualAnimatedRing].gradientAnimation.fromValue = self.ringLayers[self.actualAnimatedRing].gradientLayer.colors
          self.ringLayers[self.actualAnimatedRing].gradientAnimation.toValue = Ring.gradientColorsForRing(-1)
          self.ringLayers[self.actualAnimatedRing].gradientAnimation.duration = 10.0

          self.ringLayers[self.actualAnimatedRing].gradientLayer.removeAllAnimations()
          self.ringLayers[self.actualAnimatedRing].gradientLayer.addAnimation(self.ringLayers[self.actualAnimatedRing].gradientAnimation,forKey: "changeColors")
          */
          
          CATransaction.setAnimationDuration(10.0)
          self.ringLayers[self.actualAnimatedRing].gradientLayer.colors = Ring.gradientColorsForRing(-1)

          self.actualAnimatedRing += 1
          self.ringLayers[self.actualAnimatedRing].gradientLayer.colors = Ring.gradientColorsForRing(self.actualAnimatedRing)
          
          self.startNextAnimation()
          AudioUtil.playSound("lap")
        }
    }
    
    let end = CABasicAnimation(keyPath: "strokeEnd")
    end.duration       = self.totalAnimationDuration/Double(self.ringLayers.count)
    
    let mediaTimingFkt = actualAnimatedRing==0 ?
                         kCAMediaTimingFunctionEaseIn :
                         (actualAnimatedRing == self.ringLayers.count-1 ? kCAMediaTimingFunctionEaseOut: kCAMediaTimingFunctionLinear )
    
    end.timingFunction = CAMediaTimingFunction(name: mediaTimingFkt)
    end.fromValue      = 0.0
    end.toValue        = 1.0
    
    animatedLayer.shapeLayer.strokeStart = 0.0
    animatedLayer.shapeLayer.strokeEnd   = 1.0
    animatedLayer.shapeLayer.add(end, forKey: "strokeEnd")
    
    CATransaction.commit()
    
  }
  
  func addAnimation (_ duration:CFTimeInterval)
  { print("CirclesView.addAnimation(\(duration))")
    
    self.totalAnimationDuration = duration
    
    if actualAnimatedRing<0
    { actualAnimatedRing = 0
      
      for r in self.ringLayers {
        r.startAnimation()
      }
      
      self.startNextAnimation()
    } /* of if */
  }
  
  func removeAnimation()
  { print("CirclesView.removeAnimation")
    
    if actualAnimatedRing>=0
    {
      for r in self.ringLayers {
        r.stopAnimation()
      } /* of for */
      
      actualAnimatedRing = -1
    } /* of if */
  }
  
  /*
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
    CGContextSetLineWidth(ctx, 1.0)
    CGContextStrokeRect(ctx, self.bounds)
    
    CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
    CGContextStrokeRect(ctx, self.ringGeometry.ringFrame)
  }*/
  
  func updateGeometry() {
    print("CirclesView.updateGeometry(\(self.frame.origin.x),\(self.frame.origin.y),\(self.frame.size.width),\(self.frame.size.height))")
    
    self.ringGeometry = RingGeometry(frame: self.frame, ringCount: self.ringLayers.count)
    
    for r in self.ringLayers {
      r.updateGeometry(self.ringGeometry)
    }
  }
  
  override func layoutSubviews() {
    print("CirclesView.layoutSubviews()")
    
    super.layoutSubviews()
    
    self.updateGeometry()
    self.setNeedsDisplay()
  }
}

// MARK: - Ring

struct RingGeometry {
  static let outterInset           = CGFloat(25.0)
  static let trackInset            = CGFloat(2.0)
  static let innerFreeCircleRadius = CGFloat(30.0)
  
  var ringCount  = 0
  var ringWidth  = CGFloat(0.0)
  var lineWidth  = CGFloat(0.0)
  var ringFrame  = CGRect.null
  var ringBounds = CGRect.null
  
  init(frame:CGRect, ringCount:Int) {
    self.ringCount = ringCount
    
    if frame.width<frame.height
    { let h = frame.width
      
      ringFrame = CGRect(x: 0.0, y: 0.5*(frame.height-h), width: frame.width, height: frame.width)
    }
    else
    { let w = frame.height
      
      ringFrame = CGRect(x: 0.5*(frame.width-w), y:0.0, width: w, height: w)
    }
    
    self.ringBounds = CGRect(x: 0, y: 0, width: ringFrame.size.width, height: ringFrame.size.height)
    self.ringWidth  = (ringFrame.size.width*0.5 - RingGeometry.innerFreeCircleRadius) / CGFloat(self.ringCount)
    self.lineWidth  = self.ringWidth - 2.0 * RingGeometry.trackInset
    
    print("ringWidth:\(self.ringWidth) lineWidth:\(self.lineWidth)")
  }

  func circleRadiusForRing(_ position:Int) -> CGFloat {
    let maxCircleR = self.ringFrame.size.width*0.5 - RingGeometry.trackInset - self.lineWidth*0.5
    
    return maxCircleR - self.ringWidth*CGFloat(position)
  }
  
  func ringPathForPosition(_ position:Int) -> CGPath {
    let circleBounds = self.ringBounds
    let circleRadius = self.circleRadiusForRing(position)
    let circleX      = circleBounds.origin.x + circleBounds.midX
    let circleY      = circleBounds.origin.y + circleX
    
    let path         = CGMutablePath()
    let sliceAngle   = 2.0 * Double.pi
    let startAngle   = 0.0
    let stopAngle    = sliceAngle
    
    path.addArc(center: CGPoint(x: circleX, y: circleY), radius: circleRadius,
                startAngle: CGFloat(startAngle-Double.pi*0.5), endAngle: CGFloat(stopAngle-Double.pi*0.5),
                clockwise: false)
    
    return path
  }

}

struct Ring {
  let backgroundLayer         = CAShapeLayer()
  let gradientLayer           = CAGradientLayer()
  let shapeLayer              = CAShapeLayer()
  let gradientAnimation       = CABasicAnimation(keyPath: "colors")
  var position                = 0

  init(position:Int) {
    self.position               = position
    
    backgroundLayer.fillColor   = UIColor.clear.cgColor
    backgroundLayer.strokeColor = UIColor(white: 1.0, alpha: 0.1).cgColor
    backgroundLayer.strokeStart = 0.0
    backgroundLayer.strokeEnd   = 1.0
    backgroundLayer.lineCap     = kCALineCapRound
    
    gradientLayer.startPoint    = CGPoint(x: 0.5,y: 0.0)
    gradientLayer.endPoint      = CGPoint(x: 0.5,y: 1.0)
    gradientLayer.type          = kCAGradientLayerAxial
    gradientLayer.colors        = Ring.gradientColorsForRing(position)
    
    shapeLayer.fillColor        = UIColor.clear.cgColor
    shapeLayer.strokeColor      = UIColor.black.cgColor
    shapeLayer.strokeStart      = 0.0
    shapeLayer.strokeEnd        = 0.0
    shapeLayer.lineCap          = kCALineCapRound
    shapeLayer.shadowColor      = UIColor(white: 1.0, alpha: 0.6).cgColor
    shapeLayer.shadowOffset     = CGSize(width: 0, height: 4)
    shapeLayer.shadowRadius     = 2
    shapeLayer.shadowOpacity    = 1.0
    
    gradientLayer.mask          = shapeLayer
  }
  
  func startAnimation() {
    self.shapeLayer.strokeStart = 0.0
    self.shapeLayer.strokeEnd   = 0.0
    
    CATransaction.setAnimationDuration(2.0)
    self.gradientLayer.colors   = Ring.gradientColorsForRing(position)
  }
  
  func stopAnimation() {
    if let pl = self.shapeLayer.presentation() {
      self.shapeLayer.strokeEnd = pl.strokeEnd
    }
      
    self.shapeLayer.removeAnimation(forKey: "strokeEnd")
    
    CATransaction.setAnimationDuration(10.0)
    self.gradientLayer.colors = Ring.gradientColorsForRing(position)
  }
  
  func updateGeometry(_ ringGeometry:RingGeometry) {
    self.gradientLayer.frame       = ringGeometry.ringFrame
    
    self.shapeLayer.frame          = ringGeometry.ringBounds
    self.shapeLayer.lineWidth      = CGFloat(ringGeometry.lineWidth)
    self.shapeLayer.path           = ringGeometry.ringPathForPosition(self.position)
    
    self.backgroundLayer.frame     = ringGeometry.ringFrame
    self.backgroundLayer.lineWidth = CGFloat(ringGeometry.lineWidth)
    self.backgroundLayer.path      = ringGeometry.ringPathForPosition(self.position)
  }
  
  static func gradientColorsForRing(_ position:Int) -> [AnyObject] {
    switch position
    {
    case -1:
      return [UIColor(white: 1.0, alpha: 0.1).cgColor,UIColor(white: 1.0, alpha: 0.1).cgColor]
    case 0:
      return [UIColor.blue.cgColor,UIColor.red.cgColor]
    case 1:
      return [UIColor.cyan.cgColor,UIColor.magenta.cgColor]
    case 2:
      return [UIColor.green.cgColor,UIColor.orange.cgColor]
    default:
      return [UIColor.yellow.cgColor,UIColor.purple.cgColor]
    }
  }

}
