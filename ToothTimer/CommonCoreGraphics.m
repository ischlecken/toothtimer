#import "CommonCoreGraphics.h"

/**
 *
 */
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{ CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  CGFloat         locations[] = { 0.0, 1.0 };
  NSArray*        colors      = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef   gradient    = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  CGPoint         startPoint  = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint         endPoint    = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextSaveGState(context);
  CGContextAddRect(context, rect);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}

/**
 *
 */
void drawLinearGradient1(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{ CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  CGFloat         locations[] = { 0.0, 1.0 };
  NSArray*        colors      = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef   gradient    = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  CGPoint         startPoint  = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
  CGPoint         endPoint    = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
  
  CGContextSaveGState(context);
  CGContextAddRect(context, rect);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}


/**
 *
 */
void drawPathGradient(CGContextRef context, CGRect rect, CGPathRef path, CGColorRef startColor, CGColorRef endColor)
{ CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  CGFloat         locations[] = { 0.1, 0.9 };
  NSArray*        colors      = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef   gradient    = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  CGPoint         startPoint  = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGPoint         endPoint    = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
  
  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}

/**
 *
 */
void drawPathGradient1(CGContextRef context, CGRect rect, CGPathRef path, CGColorRef startColor, CGColorRef endColor)
{ CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  CGFloat         locations[] = { 0.1, 0.9 };
  NSArray*        colors      = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef   gradient    = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  CGPoint         startPoint  = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
  CGPoint         endPoint    = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
  
  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}

/**
 *
 */
void drawPathGradient2(CGContextRef context, CGRect rect, CGPathRef path, CGColorRef startColor, CGColorRef endColor)
{ CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  CGFloat         locations[] = { 0.0, 1.0 };
  NSArray*        colors      = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef   gradient    = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  CGPoint         startPoint  = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint         endPoint    = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}

/**
 *
 */
void drawArcGradient(CGContextRef context, CGPoint center,float radius, float r0, float r1, CGColorRef startColor, CGColorRef endColor)
{ CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  CGFloat         locations[] = { 0.0, 1.0 };
  NSArray*        colors      = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef   gradient    = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  
  CGContextSaveGState(context);
  
  CGContextAddArc(context,center.x,center.y,radius,r0,r1,YES);
  CGContextAddLineToPoint(context, center.x, center.y);
  CGContextClosePath(context);
  CGContextClip(context);
  
  CGPoint p1 = CGPointMake(center.x + radius * cos(r1), center.y + radius * sin(r1));
  CGContextDrawLinearGradient(context, gradient, center, p1, 0);
  CGContextRestoreGState(context);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}


/**
 *
 */
void drawCircleGradient(CGContextRef context, CGPoint center,CGFloat radius, CGFloat lineWidth, CGColorRef startColor, CGColorRef endColor)
{ CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  CGFloat         locations[] = { 0.0, 1.0 };
  NSArray*        colors      = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef   gradient    = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  
  CGContextSaveGState(context);
  
  CGContextAddArc(context,center.x, center.y, radius, 0.0, 2.0*M_PI, YES);
  CGContextSetLineWidth(context, lineWidth);
  CGContextSetLineCap(context, kCGLineCapRound);
  CGContextReplacePathWithStrokedPath(context);
  CGContextClip(context);
  
  CGPoint p0 = CGPointMake(center.x-radius-20, center.y);
  CGPoint p1 = CGPointMake(center.x+radius+20, center.y);
  CGContextDrawLinearGradient(context, gradient, p0, p1, 0);
  
  CGContextRestoreGState(context);
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}


/**
 *
 */
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color)
{ CGContextSaveGState(context);
  CGContextSetLineCap(context, kCGLineCapSquare);
  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, 1.0);
  CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
  CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
}

/**
 *
 */
void draw2PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color)
{ CGContextSaveGState(context);
  CGContextSetLineCap(context, kCGLineCapSquare);
  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, 2.0);
  CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
  CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
}

/**
 *
 */
CGRect rectFor1PxStroke(CGRect rect)
{ return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

/**
 *
 */
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{ drawLinearGradient(context, rect, startColor, endColor);
  
  UIColor* glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35];
  UIColor* glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
  CGRect   topHalf     = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
  
  drawLinearGradient(context, topHalf, glossColor1.CGColor, glossColor2.CGColor);
}

/**
 *
 */
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight)
{ CGRect  arcRect    = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - arcHeight, rect.size.width, arcHeight);
  CGFloat arcRadius  = (arcRect.size.height/2) + (pow(arcRect.size.width, 2) / (8*arcRect.size.height));
  CGPoint arcCenter  = CGPointMake(arcRect.origin.x + arcRect.size.width/2, arcRect.origin.y + arcRadius);
  CGFloat angle      = acos(arcRect.size.width / (2*arcRadius));
  CGFloat startAngle = radians(180) + angle;
  CGFloat endAngle   = radians(360) - angle;
  
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddArc(path, NULL, arcCenter.x, arcCenter.y, arcRadius, startAngle, endAngle, 0);
  CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
  CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
  
  return path;
}

/**
 *
 */
CGContextRef newBitmapContextSuetableForSize(CGSize size)
{ CGContextRef    result            = NULL;
  CGColorSpaceRef colorSpace        = CGColorSpaceCreateDeviceRGB();
  int             pixedWidth        = size.width;
  int             pixelHeight       = size.height;
  int             bitmapBytesPerRow = pixedWidth*4;
  void*           bitmapData        = NULL;
  
#if 0
  int bitmapByteCount   = bitmapBytesPerRow*pixelHeight;

  bitmapData = malloc(bitmapByteCount);
  
  memset(bitmapData,0,bitmapByteCount);
#endif
  
  result = CGBitmapContextCreate(bitmapData, pixedWidth, pixelHeight, 8, bitmapBytesPerRow, colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
  
  CGColorSpaceRelease(colorSpace);
  
  if( bitmapData )
    free(bitmapData);
  
  return result;
}