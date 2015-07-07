//
//  CustomView.swift
//  ToothTimer
//
//  Created by Feldmaus on 07.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import UIKit

class CustomView: UIView
{
  var innerRing:CAShapeLayer = CAShapeLayer()
  
  required init(coder aDecoder: NSCoder)
  { super.init(coder: aDecoder)
    
    self.initView()
  }
  
  override init(frame: CGRect)
  { super.init(frame: frame)
    
    self.initView()
  }
  
  var circleRect : CGRect
  { var result = self.frame
    
    result.inset(dx: 40, dy: 80)
    
    return result
  }
  
  private func initView()
  { self.innerRing.fillColor   = UIColor.clearColor().CGColor
    self.innerRing.strokeColor = UIColor.redColor().CGColor
    self.innerRing.lineWidth   = 24
    self.innerRing.strokeStart = 0
    self.innerRing.strokeEnd   = 0
    self.innerRing.lineCap     = kCALineCapRound
    self.innerRing.shadowColor = UIColor.blueColor().CGColor
    self.innerRing.shadowOffset = CGSize(width: 4, height: 4)
    self.innerRing.shadowRadius = 8
    
    let r = CGRect(x: 80, y: 80, width: 100, height: 100)
    
    self.innerRing.frame       = r

    
    let path = CGPathCreateMutable()
    CGPathAddArc(path, nil, CGRectGetMidX(r), CGRectGetMidX(r),CGRectGetWidth(r),CGFloat(0), CGFloat(2.0*M_PI), true)
    
    self.innerRing.path = path
    
    self.layer.addSublayer(self.innerRing)
    
    self.setNeedsDisplay()
  }
  
  func addAnimation (duration:CFTimeInterval)
  { NSLog("addAnimation")
    
    UIView.animateWithDuration(duration) { () -> Void in
      let end = CABasicAnimation(keyPath: "strokeEnd")
      end.duration     = duration
      end.fromValue    = 0.0
      end.toValue      = 1.0
      end.removedOnCompletion = true
      
      self.innerRing.addAnimation(end, forKey: "strokeEnd")
      
    }
  }
  
  override func drawRect(rect: CGRect)
  {
    let ctx        = UIGraphicsGetCurrentContext()
    let color0     = UIColor.orangeColor()
    let color1     = UIColor.redColor()
    
    let colorSpace = CGColorSpaceCreateDeviceRGB();
    let locations  = [ CGFloat(0.1),CGFloat(0.9) ];
    
    let gradient   = CGGradientCreateWithColors(colorSpace, [color0.CGColor,color1.CGColor], locations)
    
    let startPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame))
    let endPoint   = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame))
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
    
    CGContextSetFillColorWithColor(ctx, UIColor(white: 1.0, alpha: 0.8).CGColor)
    CGContextFillEllipseInRect(ctx, self.circleRect)
  }
}