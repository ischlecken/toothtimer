void             drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void             drawLinearGradient1(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void             drawPathGradient(CGContextRef context, CGRect rect, CGPathRef path, CGColorRef startColor, CGColorRef endColor);
void             drawPathGradient1(CGContextRef context, CGRect rect, CGPathRef path, CGColorRef startColor, CGColorRef endColor);
void             drawPathGradient2(CGContextRef context, CGRect rect, CGPathRef path, CGColorRef startColor, CGColorRef endColor);
void             drawArcGradient(CGContextRef context, CGPoint center,float radius, float r0, float r1, CGColorRef startColor, CGColorRef endColor);
void             drawCircleGradient(CGContextRef context, CGPoint center,CGFloat radius, CGFloat lineWidth, CGColorRef startColor, CGColorRef endColor);
CGRect           rectFor1PxStroke(CGRect rect);
void             draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
void             draw2PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
void             drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);
CGContextRef     newBitmapContextSuetableForSize(CGSize size);

static inline double radians (double degrees)
{ return degrees * M_PI/180; }

