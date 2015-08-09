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
  
  func tintedGradientImageWithColor(tintColor:UIColor, backgroundColor:UIColor) -> UIImage
  { return self.tintedImageWithColor(tintColor,backgroundColor: backgroundColor,blendingMode: CGBlendMode.Overlay) }

  func tintedImageWithColor(tintColor:UIColor, backgroundColor:UIColor) -> UIImage
  { return self.tintedImageWithColor(tintColor,backgroundColor: backgroundColor,blendingMode: CGBlendMode.DestinationIn) }

  func tintedImageWithColor(tintColor:UIColor, backgroundColor:UIColor, blendingMode:CGBlendMode) -> UIImage
  { let bounds = CGRectMake(0, 0, self.size.width, self.size.height)
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
    
    tintColor.setFill()
    UIRectFill(bounds)
    
    self.drawInRect(bounds, blendMode: blendingMode, alpha: 1.0)
    
    let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
    
    backgroundColor.setFill()
    UIRectFill(bounds)
    
    tintedImage.drawInRect(bounds);
    
    let result = UIGraphicsGetImageFromCurrentImageContext()
    
    return result
  }
  
  func circleImageWithSize(size:CGSize, var circleColor:UIColor, disabled:Bool) -> UIImage
  {
    var hue:CGFloat    = 0.0
    var sat:CGFloat    = 0.0
    var bright:CGFloat = 0.0
    var alpha:CGFloat  = 0.0
    
    circleColor.getHue(&hue, saturation: &sat, brightness: &bright, alpha: &alpha)
    
    var circleRect = CGRectMake(0, 0, size.width, size.height)
    let imageOffset = CGPointMake(0.5*(size.width-self.size.width), 0.5*(size.height-self.size.height))
    let imgColor = !disabled  &&
                    ((0.11<=hue && hue<=0.17) || (0.32<=hue && hue<=0.34) || (0.49<=hue && hue<=0.51)) &&
                    0.9<bright &&
                    0.9<sat
                  ? UIColor(white: 0.6, alpha: 1.0) : UIColor.whiteColor()
    
    if disabled
    { circleColor = UIColor(hue: hue, saturation: sat*0.2, brightness: 1.0, alpha: 0.3) }
    
    let img = self.tintedImageWithColor(imgColor,backgroundColor: UIColor.clearColor())
    
    UIGraphicsBeginImageContext(size)
    let ctx = UIGraphicsGetCurrentContext()
    
    
    
    CGContextSaveGState(ctx);
    
    if !disabled
    { CGContextSetShadowWithColor(ctx, CGSizeMake(0,0), 4.0, UIColor.grayColor().CGColor) }
    
    circleColor.setFill()
    
    circleRect = CGRectInset(circleRect, 4, 4)
    
    CGContextFillEllipseInRect(ctx, circleRect)
    
    CGContextRestoreGState(ctx)
    
    CGContextSetStrokeColorWithColor(ctx, circleColor.CGColor)
    CGContextSetLineWidth(ctx, disabled ? 0.5 : 1.0)
    CGContextStrokeEllipseInRect(ctx, circleRect);
    
    img.drawAtPoint(imageOffset)
    
    let result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;

  }

  func dropShadow(shadowColor:UIColor) -> UIImage
  {
    UIGraphicsBeginImageContext(self.size)
    
    let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(2,0), 2.0, shadowColor.CGColor)
    
    let imageOffset = CGPointMake(0.0,0.0)
    self.drawAtPoint(imageOffset)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext();
    
    return result;

  }

}