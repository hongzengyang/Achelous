//
//  NSString+XYMD5.m
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import "NSString+XYMD5.h"
#import "NSData+XYMD5.h"

@implementation NSString (XYMD5)

- (NSString *)xy_MD5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xy_MD5String];
}

@end
