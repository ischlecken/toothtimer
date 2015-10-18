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
  
  var slideLabel                : UILabel!
  var slideLabelConstaintsAdded = false
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.initView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.initView()
    
  }
  
  func initView() {
    NSLog("SlideButton.initView()")
    
    self.slideLabel = UILabel()
    self.slideLabel.textAlignment = NSTextAlignment.Center
    self.slideLabel.font = UIFont.monospacedDigitSystemFontOfSize(32, weight: UIFontWeightBold)
    self.slideLabel.textColor = UIColor.lightGrayColor()
    self.slideLabel.text = "Slide to start..."

    self.addSubview(self.slideLabel)
  }
  
  override func layoutSubviews() {
    NSLog("SlideButton.layoutSubviews()")
    
    super.layoutSubviews()
    
    if !slideLabelConstaintsAdded {
      self.addConstraint(
        NSLayoutConstraint( item: self.slideLabel,
          attribute: NSLayoutAttribute.TopMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Top,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.addConstraint(
        NSLayoutConstraint( item: self.slideLabel,
          attribute: NSLayoutAttribute.BottomMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Bottom,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      
      self.addConstraint(
        NSLayoutConstraint( item: self.slideLabel,
          attribute: NSLayoutAttribute.LeadingMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Leading,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.addConstraint(
        NSLayoutConstraint( item: self.slideLabel,
          attribute: NSLayoutAttribute.TrailingMargin,
          relatedBy: NSLayoutRelation.Equal,
          toItem: self,
          attribute: NSLayoutAttribute.Trailing,
          multiplier: 1.0,
          constant: 0
        )
      )
      
      self.slideLabel.translatesAutoresizingMaskIntoConstraints = false
      
      slideLabelConstaintsAdded = true
    }
  }
  
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx,UIColor.blueColor().CGColor)
    CGContextSetLineWidth(ctx, CGFloat(1.0))
    
    CGContextStrokeRect(ctx, rect)
  }
}