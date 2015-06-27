#import "UIImage+Tint.h"
#import "CommonCoreGraphics.h"
#import "UIColor+Hexadecimal.h"

@implementation UIImage (Tint)

#pragma mark - Public methods

/**
 *
 */
- (UIImage *)tintedGradientImageWithColor:(UIColor *)tintColor andBackgroundColor:(UIColor*)backgroundColor
{ return [self tintedImageWithColor:tintColor andBackgroundColor:backgroundColor blendingMode:kCGBlendModeOverlay]; }

/**
 *
 */
- (UIImage *)tintedImageWithColor:(UIColor *)tintColor andBackgroundColor:(UIColor*)backgroundColor
{ return [self tintedImageWithColor:tintColor andBackgroundColor:backgroundColor blendingMode:kCGBlendModeDestinationIn]; }

/**
 *
 */
-(UIImage*) tintedImageWithColor:(UIColor *)tintColor andBackgroundColor:(UIColor*)backgroundColor blendingMode:(CGBlendMode)blendMode
{ CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
  
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  
  [tintColor setFill];
  UIRectFill(bounds);
  
  [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
  
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  
  [backgroundColor setFill];
  UIRectFill(bounds);
  
  [tintedImage drawInRect:bounds];
  
  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return resultImage;
}


/**
 *
 */
-(UIImage*) circleImageWithSize:(CGSize)size andColor:(UIColor*)circleColor isDisabled:(BOOL)disabled
{ UIImage* result = nil;
  
  CGFloat hue;
  CGFloat sat;
  CGFloat bright;
  CGFloat alpha;
  [circleColor getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
  
  //_NSLOG(@"%@[%@]: h:%f,s:%f,b:%f a:%f",[circleColor colorHexString],circleColor,hue,sat,bright,alpha);
  
  CGPoint  imageOffset = CGPointMake(0.5*(size.width-self.size.width), 0.5*(size.height-self.size.height));
  
  // yellow 0.12
  // green  0.33
  // cyan   0.5
  UIColor* imgColor = !disabled &&
                      ((0.11<=hue && hue<=0.17) || (0.32<=hue && hue<=0.34) || (0.49<=hue && hue<=0.51)) &&
                       0.9<bright &&
                       0.9<sat
                       ? [UIColor colorWithWhite:0.6 alpha:1.0] : [UIColor whiteColor];
  
  if( disabled )
    circleColor = [UIColor colorWithHue:hue saturation:sat*0.2 brightness:1.0 alpha:0.3];
  
  UIGraphicsBeginImageContext(size);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextSaveGState(ctx);
  
  if( !disabled )
    CGContextSetShadowWithColor(ctx, CGSizeMake(0,0), 4.0, [UIColor grayColor].CGColor);
  
  [circleColor setFill];
  
  CGRect circleRect = CGRectMake(0, 0, size.width, size.height);
  circleRect = CGRectInset(circleRect, 4, 4);
  
  CGContextFillEllipseInRect(ctx, circleRect);
  
  CGContextRestoreGState(ctx);
  
  [[UIColor whiteColor] setStroke];
  CGContextSetLineWidth(ctx, disabled ? 0.5 : 1.0);
  CGContextStrokeEllipseInRect(ctx, circleRect);
  
  UIImage* img         = [self tintedImageWithColor:imgColor andBackgroundColor:[UIColor clearColor]];
  [img drawAtPoint:imageOffset];
  
  result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return result;
}

/**
 *
 */
-(UIImage*) dropShadow:(UIColor*)shadowColor
{ UIImage* result = nil;
  
  UIGraphicsBeginImageContext(self.size);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextSetShadowWithColor(ctx, CGSizeMake(2,0), 2.0, shadowColor.CGColor);
  
  CGPoint  imageOffset = CGPointMake(0.0,0.0);
  [self drawAtPoint:imageOffset];
  result = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return result;
}


#pragma mark - Private methods

/**
 *
 */
- (NSString*) cgColorToString:(CGColorRef)cgColorRef
{ const CGFloat *components = CGColorGetComponents(cgColorRef);
 
  int red   = (int)(components[0] * 255);
  int green = (int)(components[1] * 255);
  int blue  = (int)(components[2] * 255);
  int alpha = (int)(components[3] * 255);
  
  return [NSString stringWithFormat:@"#%0.2X%0.2X%0.2X%0.2X", red, green, blue, alpha];
}


@end