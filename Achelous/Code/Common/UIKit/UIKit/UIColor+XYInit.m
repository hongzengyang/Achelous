//
//  UIColor+XYInit.m
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import "UIColor+XYInit.h"

@implementation UIColor (XYInit)

+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue {
    return [UIColor xy_colorWithHEX:hexValue alpha:1.0];
}

@end
