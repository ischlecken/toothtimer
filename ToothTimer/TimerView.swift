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
  { print("TimerView.initView()")
    
    self.timeLabel = UILabel()
    self.timeLabel.textAlignment = NSTextAlignment.center
    self.timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 64.0, weight: UIFontWeightBold)
    self.timeLabel.textColor = UIColor.lightGray
    self.timeLabel.text = "00:00"
    self.timeLabel.adjustsFontSizeToFitWidth = true
    self.timeLabel.minimumScaleFactor = 0.1
    
    self.addSubview(self.timeLabel)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    print("TimerView.traitCollectionDidChange(\(previousTraitCollection))")
    
    var fontSize = CGFloat(64.0)
    var fontColor = UIColor.lightGray
    
    if self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact {
      fontSize = 32.0
      fontColor = UIColor.white
    }
    
    self.timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFontWeightBold)
    self.timeLabel.textColor = fontColor
    
  }
  
  override func layoutSubviews() {
    print("TimerView.layoutSubviews()")
    
    super.layoutSubviews()
    
    if !timeLabelConstaintsAdded {
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.topMargin,
          relatedBy: NSLayoutRelation.equal,
          toItem: self,
          attribute: NSLayoutAttribute.top,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.bottomMargin,
          relatedBy: NSLayoutRelation.equal,
          toItem: self,
          attribute: NSLayoutAttribute.bottom,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.leadingMargin,
          relatedBy: NSLayoutRelation.equal,
          toItem: self,
          attribute: NSLayoutAttribute.leading,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.addConstraint(
        NSLayoutConstraint( item: self.timeLabel,
          attribute: NSLayoutAttribute.trailingMargin,
          relatedBy: NSLayoutRelation.equal,
          toItem: self,
          attribute: NSLayoutAttribute.trailing,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
      
      timeLabelConstaintsAdded = true
    }
  }
  
  /*
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx,UIColor.blueColor().CGColor)
    CGContextSetLineWidth(ctx, CGFloat(1.0))
    
    CGContextStrokeRect(ctx, rect)
  } */
  

  
}
