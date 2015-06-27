
@interface UIImage (Tint)

-(UIImage*) tintedGradientImageWithColor:(UIColor *)tintColor andBackgroundColor:(UIColor*)backgroundColor;
-(UIImage*) tintedImageWithColor:(UIColor *)tintColor andBackgroundColor:(UIColor*)backgroundColor;

-(UIImage*) circleImageWithSize:(CGSize)size andColor:(UIColor*)circleColor isDisabled:(BOOL)disabled;
-(UIImage*) dropShadow:(UIColor*)shadowColor;
@end