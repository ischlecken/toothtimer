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
  
  func commonInit()
  { NSLog("commonInit()")
    
    self.gradientLayer.startPoint = CGPoint(x: 0.5,y: 0.0)
    self.gradientLayer.endPoint   = CGPoint(x: 0.5,y: 1.0)
    self.gradientLayer.type       = kCAGradientLayerAxial
    self.gradientLayer.colors     = self.loadGradientColors()
  }
  
  func loadGradientColors() -> [AnyObject]
  { let gradientColors     = UIColor.colorWithName(ColorName.gradientColors.rawValue) as! [UIColor]
    var gradientColorsRefs = [CGColor]()
    
    for c in gradientColors
    { gradientColorsRefs.append(c.CGColor)
    }
    
    return gradientColorsRefs
  }
  
  func dimGradient ()
  { NSLog("dimGradient")
    
    self.gradientLayer.removeAllAnimations()
    
    let colors = [UIColor(hexString: "#808080").CGColor,UIColor(hexString:"#000000").CGColor]
    
    CATransaction.begin()
    CATransaction.setCompletionBlock
      { () -> Void in
        
        self.gradientLayer.colors = colors
        NSLog("dimGradient completed")
    }
    
    //self.gradientLayer.colors = colors
    
    let colorsAnim = CABasicAnimation(keyPath: "colors")
    colorsAnim.duration = 4
    colorsAnim.toValue  = colors
    
    self.gradientLayer.addAnimation(colorsAnim, forKey: "colorsAnimation")
    CATransaction.commit()
  }
  
  func resetGradient()
  { NSLog("resetGradient")
    
    self.gradientLayer.removeAllAnimations()
    
    let colors = self.loadGradientColors()
    
    CATransaction.begin()
    CATransaction.setCompletionBlock
      { () -> Void in
        
        self.gradientLayer.colors = colors
        NSLog("resetGradient completed")
      }
    
    //self.gradientLayer.colors = self.loadGradientColors()
    
    let colorsAnim = CABasicAnimation(keyPath: "colors")
    colorsAnim.duration = 2
    colorsAnim.toValue  = colors
    
    self.gradientLayer.addAnimation(colorsAnim, forKey: "colorsAnimation")
    
    CATransaction.commit()
  }

}