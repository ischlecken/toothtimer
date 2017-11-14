//
//  UIImage.swift
//  ToothTimer
//
//  Created by Feldmaus on 09.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

extension UIImage
{
  
  func tintedGradientImageWithColor(_ tintColor:UIColor, backgroundColor:UIColor) -> UIImage
  { return self.tintedImageWithColor(tintColor,backgroundColor: backgroundColor,blendingMode: CGBlendMode.overlay) }

  func tintedImageWithColor(_ tintColor:UIColor, backgroundColor:UIColor) -> UIImage
  { return self.tintedImageWithColor(tintColor,backgroundColor: backgroundColor,blendingMode: CGBlendMode.destinationIn) }

  func tintedImageWithColor(_ tintColor:UIColor, backgroundColor:UIColor, blendingMode:CGBlendMode) -> UIImage
  { let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
    
    tintColor.setFill()
    UIRectFill(bounds)
    
    self.draw(in: bounds, blendMode: blendingMode, alpha: 1.0)
    
    let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
    
    backgroundColor.setFill()
    UIRectFill(bounds)
    
    tintedImage?.draw(in: bounds);
    
    let result = UIGraphicsGetImageFromCurrentImageContext()
    
    return result!
  }
  
  func circleImageWithSize(_ size:CGSize, circleColor:UIColor, disabled:Bool) -> UIImage
  {
    var circleColor = circleColor
    var hue:CGFloat    = 0.0
    var sat:CGFloat    = 0.0
    var bright:CGFloat = 0.0
    var alpha:CGFloat  = 0.0
    
    circleColor.getHue(&hue, saturation: &sat, brightness: &bright, alpha: &alpha)
    
    var circleRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let imageOffset = CGPoint(x: 0.5*(size.width-self.size.width), y: 0.5*(size.height-self.size.height))
    let imgColor = !disabled  &&
                    ((0.11<=hue && hue<=0.17) || (0.32<=hue && hue<=0.34) || (0.49<=hue && hue<=0.51)) &&
                    0.9<bright &&
                    0.9<sat
                  ? UIColor(white: 0.6, alpha: 1.0) : UIColor.white
    
    if disabled
    { circleColor = UIColor(hue: hue, saturation: sat*0.2, brightness: 1.0, alpha: 0.3) }
    
    let img = self.tintedImageWithColor(imgColor,backgroundColor: UIColor.clear)
    
    UIGraphicsBeginImageContext(size)
    let ctx = UIGraphicsGetCurrentContext()
    
    
    
    ctx?.saveGState();
    
    if !disabled
    { ctx?.setShadow(offset: CGSize(width: 0,height: 0), blur: 4.0, color: UIColor.gray.cgColor) }
    
    circleColor.setFill()
    
    circleRect = circleRect.insetBy(dx: 4, dy: 4)
    
    ctx?.fillEllipse(in: circleRect)
    
    ctx?.restoreGState()
    
    ctx?.setStrokeColor(circleColor.cgColor)
    ctx?.setLineWidth(disabled ? 0.5 : 1.0)
    ctx?.strokeEllipse(in: circleRect);
    
    img.draw(at: imageOffset)
    
    let result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result!;

  }

  func dropShadow(_ shadowColor:UIColor) -> UIImage
  {
    UIGraphicsBeginImageContext(self.size)
    
    let ctx = UIGraphicsGetCurrentContext()
    
    ctx?.setShadow(offset: CGSize(width: 2,height: 0), blur: 2.0, color: shadowColor.cgColor)
    
    let imageOffset = CGPoint(x: 0.0,y: 0.0)
    self.draw(at: imageOffset)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext();
    
    return result!;

  }

}
