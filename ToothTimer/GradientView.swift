//
//  GradientView.swift
//  ToothTimer
//
//  Created by Feldmaus on 12.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation


class GradientView : UIView
{
  var dimmedColors           : [AnyObject]!
  var normalColors           : [AnyObject]!
  let dimGradientAnimation   = CABasicAnimation(keyPath: "colors")
  let resetGradientAnimation = CABasicAnimation(keyPath: "colors")
  var runningAnimation       : String?
 
  override init(frame: CGRect)
  { super.init(frame: frame)
    
    self.commonInit()
  }

  required init?(coder aDecoder: NSCoder)
  { super.init(coder: aDecoder)
    
    self.commonInit()
  }
  
  override class func layerClass() -> AnyClass
  { return CAGradientLayer.self }
  
  var gradientLayer : CAGradientLayer
  { return self.layer as! CAGradientLayer }
  
  func commonInit() {
    NSLog("commonInit()")
    
    self.gradientLayer.startPoint = CGPoint(x: 0.5,y: 0.0)
    self.gradientLayer.endPoint   = CGPoint(x: 0.5,y: 1.0)
    self.gradientLayer.type       = kCAGradientLayerAxial
    self.gradientLayer.colors     = self.loadGradientColors()
    
    self.dimmedColors = [UIColor(hexString: "#808080").CGColor,UIColor(hexString:"#000000").CGColor]
    self.normalColors = self.loadGradientColors()
    
    self.dimGradientAnimation.duration    = 20
    self.dimGradientAnimation.fromValue   = self.normalColors
    self.dimGradientAnimation.toValue     = self.dimmedColors

    self.resetGradientAnimation.duration  = 8
    self.resetGradientAnimation.fromValue = self.dimmedColors
    self.resetGradientAnimation.toValue   = self.normalColors
  }
  
  func loadGradientColors() -> [AnyObject] {
    let gradientColors     = UIColor.colorWithName(ColorName.gradientColors.rawValue) as! [UIColor]
    var gradientColorsRefs = [CGColor]()
    
    for c in gradientColors
    { gradientColorsRefs.append(c.CGColor)
    }
    
    return gradientColorsRefs
  }
  
  func dimGradient () {
    self.runningAnimation = "dimGradient"
    self.gradientLayer.removeAllAnimations()
    self.gradientLayer.addAnimation(self.dimGradientAnimation, forKey: runningAnimation)
    self.gradientLayer.colors = self.dimmedColors
  }
  
  func resetGradient() {
    self.runningAnimation = "resetGradient"
    self.gradientLayer.removeAllAnimations()
    self.gradientLayer.addAnimation(self.resetGradientAnimation, forKey: runningAnimation)
    self.gradientLayer.colors = self.normalColors
  }

}
