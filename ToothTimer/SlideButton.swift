//
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import UIKit

class SlideButton: UIControl
{
  let gradientLayer : CAGradientLayer = {
    let result         = CAGradientLayer()
    let gradientColors = UIColor.colorWithName(ColorName.gradientColors.rawValue) as! [UIColor]
    let color1         = gradientColors[0].cgColor
    let color0         = gradientColors[gradientColors.count-1].cgColor
    
    result.startPoint = CGPoint(x: 0.0,y: 0.5)
    result.endPoint   = CGPoint(x: 1.0,y: 0.5)
    result.type       = kCAGradientLayerAxial
    result.colors     = [color0,color1,color0]
    result.locations  = [ 0.25, 0.5, 0.75 ]
    
    return result
  }()
  
  let textAttributes0: [String: AnyObject] = {
    let style = NSMutableParagraphStyle()
    
    style.alignment = .center
    
    return [ NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 38.0)!,
             NSParagraphStyleAttributeName: style
           ]
  }()
  
  let textAttributes1: [String: AnyObject] = {
    let style = NSMutableParagraphStyle()
    
    style.alignment = .center
    
    return [ NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 22.0)!,
      NSParagraphStyleAttributeName: style
    ]
    }()
  
  var textAttributes : [String: AnyObject] {
    get {
      return self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact ? self.textAttributes1 : self.textAttributes0
    }
  }
  
  let slideAnimation : CABasicAnimation = {
    let result = CABasicAnimation(keyPath: "locations")
    result.fromValue   = [0.0, 0.0, 0.25]
    result.toValue     = [0.75, 1.0, 1.0]
    result.duration    = 4.0
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
    self.gradientLayer.add(self.slideAnimation, forKey: "slideAnimation")
  }
  
  func disappear() {
    self.layer.removeAllAnimations()
    self.layer.add(self.hideAnimation, forKey: "hide")
    self.layer.opacity = 0.0
  }

  func appear() {
    self.layer.removeAllAnimations()
    self.layer.add(self.showAnimation, forKey: "show")
    self.layer.opacity = 1.0
  }

  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    print("TimerView.traitCollectionDidChange(\(String(describing: previousTraitCollection)))")
    
    gradientMask()
    setNeedsDisplay()
  }
  
  override func layoutSubviews() {
    print("SlideButton.layoutSubviews()")
    
    super.layoutSubviews()
    
    self.gradientLayer.frame = CGRect( x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
    gradientMask()
    
  }
  
  override func didMoveToWindow() {
    print("TimerView.didMoveToWindow()")
    
    super.didMoveToWindow()
    
    self.layer.addSublayer(self.gradientLayer)
    self.startSlideAnimation()
  }
  
  @IBInspectable var text: String! {
    didSet {
      print("setText(\(self.text))")
    
      gradientMask()
      setNeedsDisplay()
    }
  }
  
  func gradientMask() {
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
    self.text.draw(in: bounds, withAttributes: self.textAttributes)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let maskLayer = CALayer()
    maskLayer.backgroundColor = UIColor.clear.cgColor
    maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
    maskLayer.contents = image?.cgImage
    
    self.gradientLayer.mask = maskLayer
  }

  /*
  override func drawRect(rect: CGRect)
  { let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(ctx,UIColor.blueColor().CGColor)
    CGContextSetLineWidth(ctx, CGFloat(1.0))
    
    CGContextStrokeRect(ctx, rect)
  }*/
}
