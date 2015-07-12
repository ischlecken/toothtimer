import UIKit
import XCPlayground

class CustomView: UIView
{
  var innerRing:CAShapeLayer = CAShapeLayer()
  
  required init?(coder aDecoder: NSCoder)
  { super.init(coder: aDecoder)
  }

  override init(frame: CGRect)
  { super.init(frame: frame)
    
    self.innerRing.fillColor   = UIColor.clearColor().CGColor
    self.innerRing.strokeColor = UIColor.greenColor().CGColor
    self.innerRing.lineWidth   = 4
    self.innerRing.strokeStart = 0
    self.innerRing.strokeEnd   = 0.5
    self.innerRing.frame       = CGRect(x: 50, y: 50, width: 40, height: 40)
    
    let path = CGPathCreateMutable()
    CGPathAddArc(path, nil, CGFloat(40), CGFloat(40), CGFloat(40), CGFloat(0), CGFloat(2.0*M_PI), true)
    
    self.innerRing.path = path
    
    self.layer.addSublayer(self.innerRing)
  }
  
  func addAnimation ()
  {
    UIView.animateWithDuration(2.0) { () -> Void in
      let end = CABasicAnimation(keyPath: "lineWidth")
      end.duration     = 3.0
      end.fromValue    = 4.0
      end.toValue      = 2.0
      
      self.innerRing.addAnimation(end, forKey: "strokeEnd")

    }
  }
  
  override func drawRect(rect: CGRect)
  {
    let ctx        = UIGraphicsGetCurrentContext()
    let color0     = UIColor.orangeColor()
    let color1     = UIColor.redColor()
    
    let colorSpace = CGColorSpaceCreateDeviceRGB();
    let locations  = [ CGFloat(0.1),CGFloat(0.9) ];
    
    let gradient   = CGGradientCreateWithColors(colorSpace, [color0.CGColor,color1.CGColor], locations)
    
    let startPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame))
    let endPoint   = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame))
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
    
    CGContextSetFillColorWithColor(ctx, UIColor(white: 1.0, alpha: 0.8).CGColor)
    
    var circleRect = self.frame
    circleRect.inset(dx: 20, dy: 20)
    
    CGContextFillEllipseInRect(ctx, circleRect)
  }
}

let v = CustomView(frame: CGRectMake(0, 0, 200, 200))

v.addAnimation()

XCPShowView("Container View1", view:v)







