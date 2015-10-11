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
         var innerRing:[CAShapeLayer]                = []
         var actualAnimatedRing                      = -1
         var segmentAnimationDuration:CFTimeInterval = 0.0
         var timeLabel                               = UILabel()
         var trackWidth                              = CGFloat(0.0)
         var lineWidth                               = CGFloat(0.0)
  static let outterInset                             = CGFloat(25.0)
  static let trackInset                              = CGFloat(2.0)
  static let innerFreeCircleDiameter                 = CGFloat(15.0)
  
  required init?(coder aDecoder: NSCoder)
  { super.init(coder: aDecoder)
    
    self.initView()
  }
  
  override init(frame: CGRect)
  { super.init(frame: frame)
    
    self.initView()
    
  }
  
  func initView()
  { self.timeLabel.removeFromSuperview()
    self.addSubview(self.timeLabel)
    
    self.timeLabel.textAlignment = NSTextAlignment.Center
    self.timeLabel.font = UIFont.monospacedDigitSystemFontOfSize(64.0, weight: UIFontWeightBold)
    self.timeLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
    
    for l in self.innerRing {
      l.removeFromSuperlayer()
    }
    
    self.innerRing = []
    
    let ringColors = UIColor.colorWithName(ColorName.iconColors.rawValue) as! [UIColor]
    
    for i in 0..<ToothTimerSettings.sharedInstance.noOfSlices!.integerValue
    { let l = CAShapeLayer()
      
      l.fillColor       = UIColor.clearColor() .CGColor
      l.strokeColor     = ringColors[i].CGColor
      l.strokeStart     = 0.0
      l.strokeEnd       = 0.0
      l.lineCap         = kCALineCapRound
      l.shadowColor     = UIColor(white: 1.0, alpha: 0.6).CGColor
      l.shadowOffset    = CGSize(width: 0, height: 4)
      l.shadowRadius    = 2
      l.shadowOpacity   = 1.0
      l.frame           = CGRectNull
      
      self.layer.addSublayer(l)
      self.innerRing.append(l)
    } /* of for */
  }
  
  private func startNextAnimation() -> Void
  { let animatedLayer = self.innerRing[actualAnimatedRing]
    
    CATransaction.begin()
    CATransaction.setCompletionBlock
      { () -> Void in
        
        NSLog("Animation \(self.actualAnimatedRing) completed")
        
        if self.actualAnimatedRing>=0 && self.actualAnimatedRing<self.innerRing.count-1
        { self.actualAnimatedRing++
          
          self.startNextAnimation()
          AudioUtil.playSound("lap")
        }
    }
    
    let end = CABasicAnimation(keyPath: "strokeEnd")
    end.duration       = self.segmentAnimationDuration/Double(self.innerRing.count)
    
    let mediaTimingFkt = actualAnimatedRing==0 ?
                         kCAMediaTimingFunctionEaseIn :
                         (actualAnimatedRing == self.innerRing.count-1 ? kCAMediaTimingFunctionEaseOut: kCAMediaTimingFunctionLinear )
    
    end.timingFunction = CAMediaTimingFunction(name: mediaTimingFkt)
    end.fromValue      = 0.0
    end.toValue        = 1.0
    
    animatedLayer.strokeStart = 0.0
    animatedLayer.strokeEnd   = 1.0
    
    animatedLayer.addAnimation(end, forKey: "strokeEnd")
    
    CATransaction.commit()
    
  }
  
  func addAnimation (duration:CFTimeInterval)
  { NSLog("addAnimation(\(duration))")
    
    self.segmentAnimationDuration = duration
    
    if actualAnimatedRing<0
    { actualAnimatedRing = 0
      
      for i in 0..<self.innerRing.count
      { self.innerRing[i].strokeStart = 0.0
        self.innerRing[i].strokeEnd   = 0.0
      }
      
      self.startNextAnimation()
    } /* of if */
  }
  
  func removeAnimation()
  { NSLog("removeAnimation")
    
    if actualAnimatedRing>=0
    { for i in 0..<self.innerRing.count
      { if let pl = self.innerRing[i].presentationLayer()
        { self.innerRing[i].strokeEnd = pl.strokeEnd
        }
      
        self.innerRing[i].removeAnimationForKey("strokeEnd")
      } /* of for */
      
      actualAnimatedRing = -1
    } /* of if */
  }
  
  override func drawRect(rect: CGRect)
  { let ctx          = UIGraphicsGetCurrentContext()
    
    for i in 0..<self.innerRing.count {
      var r            = self.calcRect()

      r.origin.x -= CustomView.outterInset*0.5
      r.origin.y -= CustomView.outterInset
      
      CGContextAddPath(ctx, self.createCirclePath(r, position: i))
      CGContextSetStrokeColorWithColor(ctx,UIColor(white: 1.0, alpha: 0.1).CGColor)
      CGContextSetLineWidth(ctx, CGFloat(lineWidth))
      CGContextStrokePath(ctx)
    }
  }
  
  func calcRect() -> CGRect
  { var r = CGRectNull
    
    if self.frame.width<self.frame.height
    { let h = self.frame.width
      
      r = CGRect(x: 0.0, y: 0.5*(self.frame.height-h), width: self.frame.width, height: self.frame.width)
    }
    else
    {
      let w = self.frame.height
      
      r = CGRect(x: 0.5*(self.frame.width-w), y:0.0, width: w, height: w)
    }

    return r.insetBy(dx: CustomView.outterInset, dy: CustomView.outterInset)
  }
  
  func createCirclePath(circleBounds:CGRect, position:Int) -> CGPath {
    let maxCircleR = CustomView.innerFreeCircleDiameter + self.trackWidth*CGFloat(self.innerRing.count)
    
    let path       = CGPathCreateMutable()
    let circleX    = circleBounds.origin.x + CGRectGetMidX(circleBounds)
    let circleY    = circleBounds.origin.y + circleX
    let circleR    = maxCircleR - self.trackWidth*CGFloat(position)
    let sliceAngle = 2.0 * M_PI
    let startAngle = 0.0
    let stopAngle  = sliceAngle
    
    CGPathAddArc(path, nil, circleX, circleY, circleR, CGFloat(startAngle-M_PI_2),CGFloat(stopAngle-M_PI_2), false)
    
    return path
  }
  
  func updateGeometry() {
    if self.innerRing.count>0
    { let r = self.calcRect()
      
      self.trackWidth = (min(CGRectGetWidth(r),CGRectGetHeight(r))*0.5 - CustomView.innerFreeCircleDiameter) / CGFloat(self.innerRing.count)
      self.lineWidth  = self.trackWidth - 2.0 * CustomView.trackInset
      
      NSLog("trackWidth:\(self.trackWidth) lineWidth:\(self.lineWidth)")
      
      var labelFrame = r
      labelFrame.size.height = 64
      labelFrame = labelFrame.offsetBy(dx:0, dy: -labelFrame.size.height-self.trackWidth*0.5)
      self.timeLabel.frame = labelFrame
      //self.timeLabel.layer.borderWidth = 1.0
      //self.timeLabel.layer.borderColor = UIColor.whiteColor().CGColor
      
      let circleBounds = CGRect(origin: CGPoint(x: 0.0,y: 0.0), size: r.size)
      
      for i in 0..<ToothTimerSettings.sharedInstance.noOfSlices!.integerValue
      { self.innerRing[i].frame       = r
        self.innerRing[i].lineWidth   = CGFloat(self.lineWidth)
        self.innerRing[i].path        = self.createCirclePath(circleBounds,position: i)
      } /* of for */
    } /* of if */
  }
  
  override var frame : CGRect
  { didSet {
      self.updateGeometry()
    }
  }
}