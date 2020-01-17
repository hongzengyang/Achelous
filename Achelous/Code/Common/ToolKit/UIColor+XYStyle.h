//
//  UIColor+XYStyle.h
//  XiaoYingSDK
//
//  Created by 徐新元 on 17/04/2017.
//  Copyright © 2017 QuVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XYStyle)

#pragma mark - color with hex
+ (UIColor*) xycColorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor*) xycColorWithHex:(NSInteger)hexValue;

+ (NSUInteger)xycHexFromColor:(UIColor *)color;

#pragma mark - Common colors
+ (UIColor *)appMainColor;

+ (UIColor *)appTextColor;

@end
