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
  { return CAGradientLayer.self
  }
  
  var gradientLayer : CAGradientLayer
  { return self.layer as! CAGradientLayer
  }
  
  func commonInit()
  { NSLog("commonInit()")
    
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
}