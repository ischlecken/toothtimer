#ifndef COMMON_H
#define COMMON_H

#define _LSTR(_str)                   NSLocalizedString(_str, @"")
#define _NSLOG_SELECTOR               NSLog(@"0x%x %@ %@",(int)self,[self class],NSStringFromSelector(_cmd))
#define _NSLOG_FRAME(msg,frame)       NSLog(@"0x%x %@ %@ %@(%f,%f,%f,%f)",(int)self,[self class],NSStringFromSelector(_cmd),msg,frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
#define _NSLOG(format,...)            NSLog(@"0x%x %@ %@: " format,(int)self,[self class],NSStringFromSelector(_cmd), ##__VA_ARGS__)

#define _NSNULL(a)                    (a!=nil ? a : [NSNull null])

#define _RAD2DEG(x)                   ((x)*180.0/M_PI)
#define _DEG2RAD(x)                   (M_PI*(x)/180.0)

#define _ISIPHONE                     ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
#define _ISIPAD                       ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
#define _ISPORTRAIT                   (UIDeviceOrientationIsPortrait(self.interfaceOrientation))

#define _CONTAINS(str1, str2)         ([str1 rangeOfString: str2 ].location != NSNotFound)
#define _STATUSBAR_HEIGHT             ([UIApplication sharedApplication].statusBarHidden ? 0 : [UIApplication sharedApplication].statusBarFrame.size.height)
#endif
