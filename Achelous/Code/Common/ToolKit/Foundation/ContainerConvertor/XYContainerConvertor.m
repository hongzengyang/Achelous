//
//  XYContainerConvertor.M
//  AliyunOSSiOS
//
//  Created by 林冰杰 on 2019/7/18.
//

#import "XYContainerConvertor.h"

// 判断类型
#define XYContainerConvertorCheckType(INSTANCE, TYPE) \
[INSTANCE isKindOfClass:TYPE] ? INSTANCE : nil

@implementation XYContainerConvertor

#pragma mark - Dictionary
+ (NSString *)xyStringWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSString *string = XYContainerConvertorCheckType(dict[key], NSString.class);
    if (string) return string;
    NSNumber *number = XYContainerConvertorCheckType(dict[key], NSNumber.class);
    if (number) return [NSString stringWithFormat:@"%@", number];
    return nil;
}

+ (NSString *)xyNonnullStringWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSString *string = [self xyStringWithDictionary:dict forKey:key];
    return string? string:@"";
}

+ (NSNumber *)xyNumberWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSNumber *number = XYContainerConvertorCheckType(dict[key], NSNumber.class);
    if (number) return number;
    NSString *string = XYContainerConvertorCheckType(dict[key], NSString.class);
    if (string) return @([string intValue]);
    return nil;
}

+ (NSDictionary *)xyDictWithDictionary:(NSDictionary *)dict forkey:(id)key {
    return XYContainerConvertorCheckType(dict[key], NSDictionary.class);
}

+ (NSArray *)xyArrayWithDictionary:(NSDictionary *)dict forkey:(id)key {
    return XYContainerConvertorCheckType(dict[key], NSArray.class);
}

#pragma mark - Array
+ (NSString *)xyStringWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    
    NSString *string = XYContainerConvertorCheckType(array[index], NSString.class);
    if (string) return string;
    NSNumber *number = XYContainerConvertorCheckType(array[index], NSNumber.class);
    if (number) return [NSString stringWithFormat:@"%@", number];
    return nil;
}

+ (NSNumber *)xyNumberWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    
    NSNumber *number = XYContainerConvertorCheckType(array[index], NSNumber.class);
    if (number) return number;
    NSString *string = XYContainerConvertorCheckType(array[index], NSString.class);
    if (string) return @([string intValue]);
    return nil;
}

+ (NSDictionary *)xyDictWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    return XYContainerConvertorCheckType(array[index], NSDictionary.class);
}

+ (NSArray *)xyArrayWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    return XYContainerConvertorCheckType(array[index], NSArray.class);
}

#pragma mark - judge self type
+ (NSArray *)xyArrayWithObject:(id)array {
    return XYContainerConvertorCheckType(array, NSArray.class);
}

+ (NSDictionary *)xyDictWithObject:(id)dict {
    return XYContainerConvertorCheckType(dict, NSDictionary.class);
}

@end
