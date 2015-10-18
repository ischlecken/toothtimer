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
  let gradientLayer : CAGradientLayer = {
    let result = CAGradientLayer()
    
    result.startPoint = CGPoint(x: 0.0,y: 0.5)
    result.endPoint   = CGPoint(x: 1.0,y: 0.5)
    result.type       = kCAGradientLayerAxial
    result.colors     = [UIColor(hexString: "#ff44ff").CGColor,UIColor(hexString:"#ffffff").CGColor,UIColor(hexString: "#ff44ff").CGColor]
    result.locations  = [ 0.25, 0.5, 0.75 ]
    
    return result
  }()
  
  let textAttributes0: [String: AnyObject] = {
    let style = NSMutableParagraphStyle()
    
    style.alignment = .Center
    
    return [ NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 38.0)!,
             NSParagraphStyleAttributeName: style
           ]
  }()
  
  let textAttributes1: [String: AnyObject] = {
    let style = NSMutableParagraphStyle()
    
    style.alignment = .Center
    
    return [ NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 22.0)!,
      NSParagraphStyleAttributeName: style
    ]
    }()
  
  var textAttributes : [String: AnyObject] {
    get {
      return self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact ? self.textAttributes1 : self.textAttributes0
    }
  }
  
  let slideAnimation : CABasicAnimation = {
    let result = CABasicAnimation(keyPath: "locations")
    result.fromValue = [0.0, 0.0, 0.25]
    result.toValue = [0.75, 1.0, 1.0]
    result.duration = 3.0
    result.repeatCount = Float.infinity

    return result
  }()
  
  let hideAnimation : CABasicAnimation = {
    let result = CABasicAnimation(keyPath: "opacity")
    result.fromValue = 1.0
    result.toValue = 0.0
    result.duration = 3.0
    
    return result
    }()
  
  let showAnimation : CABasicAnimation = {
    let result = CABasicAnimation(keyPath: "opacity")
    result.fromValue = 0.0
    result.toValue = 1.0
    result.duration = 3.0
    
    return result
    }()
  

  func startSlideAnimation() {
    self.gradientLayer.removeAllAnimations()
    self.gradientLayer.addAnimation(self.slideAnimation, forKey: "slideAnimation")
  }
  
  func disappear() {
    self.layer.removeAllAnimations()
    self.layer.addAnimation(self.hideAnimation, forKey: "hide")
    self.layer.opacity = 0.0
  }

  func appear() {
    self.layer.removeAllAnimations()
    self.layer.addAnimation(self.showAnimation, forKey: "show")
    self.layer.opacity = 1.0
  }

  
  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    NSLog("TimerView.traitCollectionDidChange(\(previousTraitCollection))")
    
    gradientMask()
    setNeedsDisplay()
  }
  
  override func layoutSubviews() {
    NSLog("SlideButton.layoutSubviews()")
    
    super.layoutSubviews()
    
    self.gradientLayer.frame = CGRect( x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
    gradientMask()
    
  }
  
  override func didMoveToWindow() {
    NSLog("TimerView.didMoveToWindow()")
    
    super.didMoveToWindow()
    
    self.layer.addSublayer(self.gradientLayer)
    self.startSlideAnimation()
  }
  
  @IBInspectable var text: String! {
    didSet {
      NSLog("setText(\(self.text))")
    
      gradientMask()
      setNeedsDisplay()
    }
  }
  
  func gradientMask() {
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
    self.text.drawInRect(bounds, withAttributes: self.textAttributes)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let maskLayer = CALayer()
    maskLayer.backgroundColor = UIColor.clearColor().CGColor
    maskLayer.frame = CGRectOffset(bounds, bounds.size.width, 0)
    maskLayer.contents = image.CGImage
    
    self.gradientLayer.mask = maskLayer
  }

  
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx,UIColor.blueColor().CGColor)
    CGContextSetLineWidth(ctx, CGFloat(1.0))
    
    CGContextStrokeRect(ctx, rect)
  }
}