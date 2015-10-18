//
//  CustomView.swift
//  ToothTimer
//
//  Created by Feldmaus on 07.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import UIKit

class CircleButton : UIControl
{
  
  override func drawRect(rect: CGRect)
  { let ctx          = UIGraphicsGetCurrentContext()
  
    CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor)
    CGContextFillEllipseInRect(ctx, rect)
  }
}