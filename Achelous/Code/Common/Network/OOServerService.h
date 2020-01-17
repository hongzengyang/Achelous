//
//  OOServerService.h
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOServerApiName.h"

typedef void (^OO_SERVER_BLOCK)(BOOL success, id response);

NS_ASSUME_NONNULL_BEGIN

@interface OOServerService : NSObject

+ (OOServerService *)sharedInstance;

//多了客户端业务选项参数 比如 是否需要缓存 而且如果发现存在缓存就同步返回
- (NSDictionary *)postWithUrlKey:(NSString *)urlKey
                      parameters:(NSDictionary *)parameters
                         options:(NSDictionary *)options
                           block:(OO_SERVER_BLOCK)block;

//- (NSDictionary *)getWithUrlKey:(NSString *)urlKey
//                     parameters:(NSDictionary *)parameters
//                        options:(NSDictionary *)options
//                          block:(OO_SERVER_BLOCK)block;

@end

NS_ASSUME_NONNULL_END
