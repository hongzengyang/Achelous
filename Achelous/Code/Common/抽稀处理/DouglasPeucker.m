//
//  DouglasPeucker.m
//  DouglasPeuckerDemo
//
//  Created by 杨磊 on 2018/7/18.
//

#import "DouglasPeucker.h"

const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

@implementation DouglasPeucker

/**
 * 道格拉斯算法，处理coordinateList序列
 * 先将首末两点加入points序列中，然后在coordinateList序列找出距离首末点连线距离的最大距离值dmax并与阈值threshold进行比较，
 * 若大于阈值则将这个点加入points序列，重新遍历points序列。否则将两点间的所有点(coordinateList)移除
 * OOSportNode是经纬度model
 * @return 返回经过道格拉斯算法后得到的点的序列
 */
- (NSArray*)douglasAlgorithm:(NSArray <OOSportNode *>*)coordinateList threshold:(CGFloat)threshold{
    // 将首末两点加入到序列中
    NSMutableArray *points = [NSMutableArray array];
    NSMutableArray *list = [NSMutableArray arrayWithArray:coordinateList];
    
    [points addObject:list[0]];
    [points addObject:coordinateList[coordinateList.count - 1]];
    
    for (NSInteger i = 0; i<points.count - 1; i++) {
        NSUInteger start = (NSUInteger)[list indexOfObject:points[i]];
        NSUInteger end = (NSUInteger)[list indexOfObject:points[i+1]];
        if ((end - start) == 1) {
            continue;
        }
        NSString *value = [self getMaxDistance:list startIndex:start endIndex:end threshold:threshold];
        NSString *dist = [value componentsSeparatedByString:@","][0];
        CGFloat maxDist = [dist floatValue];
        
        //大于限差 将点加入到points数组
        if (maxDist >= threshold) {
            NSInteger position = [[value componentsSeparatedByString:@","][1] integerValue];
            [points insertObject:list[position] atIndex:i+1];
            // 将循环变量i初始化,即重新遍历points序列
            i = -1;
        }else {
            /**
             * 将两点间的点全部删除
             */
            NSInteger removePosition = start + 1;
            for (NSInteger j = 0; j < end - start - 1; j++) {
                [list removeObjectAtIndex:removePosition];
            }
        }
    }
    
    return points;
}
/**
 * 根据给定的始末点，计算出距离始末点直线的最远距离和点在coordinateList列表中的位置
 * @param startIndex 遍历coordinateList起始点
 * @param endIndex 遍历coordinateList终点
 * @return maxDistance + "," + position 返回最大距离+"," + 在coordinateList中位置
 */
- (NSString *)getMaxDistance:(NSArray <OOSportNode *>*)coordinateList startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex threshold:(CGFloat)threshold{
    
    CGFloat maxDistance = -1;
    NSInteger position = -1;
    CGFloat distance = [self getDistance:coordinateList[startIndex] lastEntity:coordinateList[endIndex]];
    
    for(NSInteger i = startIndex; i < endIndex; i++){
        CGFloat firstSide = [self getDistance:coordinateList[startIndex] lastEntity:coordinateList[i]];
        if(firstSide < threshold){
            continue;
        }
        
        CGFloat lastSide = [self getDistance:coordinateList[endIndex] lastEntity:coordinateList[i]];
        if(lastSide < threshold){
            continue;
        }
        
        // 使用海伦公式求距离
        CGFloat p = (distance + firstSide + lastSide) / 2.0;
        CGFloat dis = sqrt(p * (p - distance) * (p - firstSide) * (p - lastSide)) / distance * 2;
        
        if(dis > maxDistance){
            maxDistance = dis;
            position = i;
        }
    }
    
    NSString *strMaxDistance = [NSString stringWithFormat:@"%f,%ld", maxDistance,position];
    return strMaxDistance;
}

// 两点间距离公式
- (CGFloat)getDistance:(OOSportNode *)firstEntity lastEntity:(OOSportNode *)lastEntity
{
    double firstLatitude = [firstEntity getLatitude];
    double firstLongitude = [firstEntity getLongitude];
    double secondLatitude = [lastEntity getLatitude];
    double secondLongitude = [firstEntity getLongitude];
    
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:firstLatitude longitude:firstLongitude];
    CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:secondLatitude longitude:secondLongitude];
    
    CGFloat  distance  = [firstLocation distanceFromLocation:lastLocation];
    return  distance;
}


///////////
///////////
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsCoordinate
{
    CLLocationCoordinate2D adjustLoc;
    if([self isLocationOutOfChina:wgsCoordinate]){
        adjustLoc = wgsCoordinate;
    }else{
        double adjustLat = [self transformLatWithX:wgsCoordinate.longitude - 105.0 withY:wgsCoordinate.latitude - 35.0];
        double adjustLon = [self transformLonWithX:wgsCoordinate.longitude - 105.0 withY:wgsCoordinate.latitude - 35.0];
        double radLat = wgsCoordinate.latitude / 180.0 * pi;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        adjustLoc.latitude = wgsCoordinate.latitude + adjustLat;
        adjustLoc.longitude = wgsCoordinate.longitude + adjustLon;
    }
    return adjustLoc;
}

//判断是不是在中国
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)coordinate
{
    if (coordinate.longitude < 72.004 || coordinate.longitude > 137.8347 || coordinate.latitude < 0.8293 || coordinate.latitude > 55.8271)
        return YES;
    return NO;
}

+(double)transformLatWithX:(double)x withY:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+(double)transformLonWithX:(double)x withY:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

@end
