//
//  NSArray+XYContainerConvertor.m
//  XYH5SDK
//
//  Created by 林冰杰 on 2019/7/18.
//

#import "NSArray+XYContainerConvertor.h"
#import "XYContainerConvertor.H"

@implementation NSArray (XYContainerConvertor)

- (NSString *)xyStringAtIndex:(NSInteger)index {
    return [XYContainerConvertor xyStringWithArray:self atIndex:index];
}

- (NSNumber *)xyNumberAtIndex:(NSInteger)index {
    return [XYContainerConvertor xyNumberWithArray:self atIndex:index];
}

- (NSDictionary *)xyDictionaryAtIndex:(NSInteger)index {
    return [XYContainerConvertor xyDictWithArray:self atIndex:index];
}

- (NSArray *)xyArrayAtIndex:(NSInteger)index {
    return [XYContainerConvertor xyArrayWithArray:self atIndex:index];
}

@end
