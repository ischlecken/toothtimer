//
//  CustomView.swift
//  ToothTimer
//
//  Created by Feldmaus on 07.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import UIKit

class SlideButton: UIControl
{
  
  var slideLabel = UILabel()
  
  required init?(coder aDecoder: NSCoder)
  { super.init(coder: aDecoder)
    
    self.initView()
  }
  
  override init(frame: CGRect)
  { super.init(frame: frame)
    
    self.initView()
    
  }
  
  func initView()
  { self.slideLabel.removeFromSuperview()
    self.addSubview(self.slideLabel)
    
    self.slideLabel.textAlignment = NSTextAlignment.Center
    self.slideLabel.font = UIFont.monospacedDigitSystemFontOfSize(64.0, weight: UIFontWeightBold)
    self.slideLabel.textColor = UIColor.lightGrayColor()
    self.slideLabel.text = "Slide to start..."
    self.slideLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 48)
  }
  
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx,UIColor.blueColor().CGColor)
    CGContextSetLineWidth(ctx, CGFloat(1.0))
    
    CGContextStrokeRect(ctx, rect)
  }
}