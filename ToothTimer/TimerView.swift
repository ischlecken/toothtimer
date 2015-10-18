//
//  CustomView.swift
//  ToothTimer
//
//  Created by Feldmaus on 07.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import UIKit

class TimerView: UIView
{
  
  var timeLabel = UILabel()
  
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
    self.timeLabel.textColor = UIColor.redColor()
    self.timeLabel.text = "00:00"
    self.timeLabel.frame = CGRect(x: 0,y: 0,width: 120,height: 64)
  }
  
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx,UIColor.blueColor().CGColor)
    CGContextSetLineWidth(ctx, CGFloat(1.0))
    
    CGContextStrokeRect(ctx, rect)
  }
  

  
}