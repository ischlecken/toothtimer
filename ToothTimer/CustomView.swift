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
  
  required init?(coder aDecoder: NSCoder)
  { super.init(coder: aDecoder)
    
    self.initView()
  }
  
  override init(frame: CGRect)
  { super.init(frame: frame)
    
    self.initView()
  }
  
  override class func layerClass() -> AnyClass
  { return CAGradientLayer.self
  }
  
  var gradientLayer : CAGradientLayer
    { return self.layer as! CAGradientLayer
  }
  
  var circleRect : CGRect
  { var result = self.frame
    
    result.inset(dx: 40, dy: 80)
    
    return result
  }
  
  private func initView()
  { self.innerRing.fillColor       = UIColor(white: 1.0, alpha: 0.1) .CGColor
    self.innerRing.strokeColor     = UIColor(red: 0.3, green: 0.0, blue: 1.0, alpha: 0.8 ).CGColor
    self.innerRing.lineWidth       = 24
    self.innerRing.strokeStart     = 0.0
    self.innerRing.strokeEnd       = 0.0
    self.innerRing.lineCap         = kCALineCapRound
    self.innerRing.shadowColor     = UIColor.blackColor().CGColor
    self.innerRing.shadowOffset    = CGSize(width: 0, height: 6)
    self.innerRing.shadowRadius    = 2
    self.innerRing.shadowOpacity   = 1.0
    self.innerRing.frame           = CGRectNull
    
    self.layer.addSublayer(self.innerRing)
    
    self.gradientLayer.startPoint = CGPoint(x: 0.5,y: 0.0)
    self.gradientLayer.endPoint   = CGPoint(x: 0.5,y: 1.0)
    
    let gradientColors     = UIColor.colorWithName("gradientColors") as! [UIColor]
    var gradientColorsRefs = [CGColor]()
    
    for c in gradientColors
    { gradientColorsRefs.append(c.CGColor)
    }
    
    self.gradientLayer.colors = gradientColorsRefs
    self.gradientLayer.type   = kCAGradientLayerAxial
  }
  
  func addAnimation (duration:CFTimeInterval)
  { NSLog("addAnimation")
    
    UIView.animateWithDuration(duration) { () -> Void in
      let end = CABasicAnimation(keyPath: "strokeEnd")
      end.duration     = duration
      end.fromValue    = 0.0
      end.toValue      = 1.0
      
      self.innerRing.addAnimation(end, forKey: "strokeEnd")
      
    }
  }
  
  override var frame : CGRect
  { didSet
    {
      var r = CGRectNull
      
      if self.frame.width<self.frame.height
      { let h = self.frame.width
        
        r = CGRect(x: 0.0, y: 0.5*(self.frame.height-h), width: self.frame.width, height: h)
      }
      else
      {
        let w = self.frame.height
        
        r = CGRect(x: 0.5*(self.frame.width-w), y:0.0, width: w, height: self.frame.height)
      }
      
      self.innerRing.frame = r
      NSLog("frame:\(self.frame) f:\(r)")
      
      r = self.innerRing.bounds
      r.inset(dx: self.innerRing.lineWidth*2.0, dy: self.innerRing.lineWidth*2.0)
      
      let path = CGPathCreateMutable()
      CGPathAddArc(path, nil,
                   CGRectGetMidX(r), CGRectGetMidX(r),min( CGRectGetWidth(r),CGRectGetHeight(r))*0.5,
                   CGFloat(0.0-M_PI_2),CGFloat(2.5*M_PI-M_PI_2), false)
      
      self.innerRing.path = path

    }
  }
}