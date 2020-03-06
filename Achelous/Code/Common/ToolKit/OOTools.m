//
//  OOTools.m
//  Achelous
//
//  Created by hzy on 2020/3/4.
//  Copyright © 2020 hzy. All rights reserved.
//

#import "OOTools.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"//数字和字母和下划线

@implementation OOTools
+ (BOOL)checkPassword:(NSString *)password {
    if (password.length < 6 || password.length > 15) {
        return NO;
    }
    
    BOOL result = YES;
    for (int i = 0; i < password.length; i++) {
        NSString *temp = [password substringWithRange:NSMakeRange(i, 1)];
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[temp componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![temp isEqualToString:filtered]) {
            result = NO;
            break;
        }
    }
    return result;
}

@end
