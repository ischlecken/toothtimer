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
  
  var timeLabel                : UILabel!
  var timeLabelConstaintsAdded = false
  
  required init?(coder aDecoder: NSCoder)
  { super.init(coder: aDecoder)
    
    self.initView()
  }
  
  override init(frame: CGRect)
  { super.init(frame: frame)
    
    self.initView()
    
  }
  
  func initView()
  { NSLog("TimerView.initView()")
    
    self.timeLabel = UILabel()
    self.timeLabel.textAlignment = NSTextAlignment.Center
    self.timeLabel.font = UIFont.monospacedDigitSystemFontOfSize(64.0, weight: UIFontWeightBold)
    self.timeLabel.textColor = UIColor.redColor()
    self.timeLabel.text = "00:00"
    self.addSubview(self.timeLabel)
  }
  
  
  override func layoutSubviews() {
    NSLog("TimerView.layoutSubviews()")
    
    super.layoutSubviews()
    
    if !timeLabelConstaintsAdded {
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.TopMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Top,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.BottomMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Bottom,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.LeadingMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Leading,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.TrailingMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Trailing,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
      
      timeLabelConstaintsAdded = true
    }
  }
  
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx,UIColor.blueColor().CGColor)
    CGContextSetLineWidth(ctx, CGFloat(1.0))
    
    CGContextStrokeRect(ctx, rect)
  }
  

  
}