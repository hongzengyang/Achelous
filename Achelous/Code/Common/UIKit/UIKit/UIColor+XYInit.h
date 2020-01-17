//
//  UIColor+XYInit.h
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef XYColorWithHEX
#define XYColorWithHEX(_hex_)   [UIColor xy_colorWithHex:_hex_]
#endif

@interface UIColor (XYInit)

/**
 根据十六进制返回颜色值

 @param hexValue 十六进制值，0xffffff
 @param alphaValue 透明度，0-1.0
 @return 颜色值
 */
+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

/**
 根据十六进制返回颜色值

 @param hexValue hexValue 十六进制值，0xffffff
 @return 颜色值
 */
+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue;

@end

NS_ASSUME_NONNULL_END
