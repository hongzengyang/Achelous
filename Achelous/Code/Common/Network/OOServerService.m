//
//  OOServerService.m
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import "OOServerService.h"
#import <AFNetworking/AFNetworking.h>
#import "OOServerApiName.h"

static NSMutableArray<Class> *URLProtocols;

NSString *urlEncode(NSString *paramString) {
    if (![paramString length]) return @"";
    CFStringRef static const charsToEscape = CFSTR("!*'();:@&=+$,/?%#[]");
    CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef) paramString,
                                                                        NULL,
                                                                        charsToEscape,
                                                                        kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *) escapedString;
}

@implementation OOServerService

+ (OOServerService *)sharedInstance {
    static OOServerService *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[OOServerService alloc] init];
    });
    return shared;
}

- (void)postWithUrlKey:(NSString *)urlKey
                      parameters:(NSDictionary *)parameters
                         options:(NSDictionary *)options
                           block:(OO_SERVER_BLOCK)block {
    //1. manager init
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self initHttpManager:manager urlKey:urlKey];
    //
    NSString *baseUrl = [self baseUrl];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl,urlKey];
    
    NSString *urll= [[NSURL URLWithString:fullUrl relativeToURL:manager.baseURL] absoluteString];
    
    [manager POST:urll parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block != nil) {
            NSInteger code = 0;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                code = [[dic valueForKey:@"code"] integerValue];
            }
            
//            [self checkErroeCode401:code];
            
            block(nil, code, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSInteger errorCode = 999;
        
        NSDictionary *errorInfo = error.userInfo;
        if (errorInfo && [errorInfo isKindOfClass:NSDictionary.class]) {
            NSData *errorData = errorInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            
            if (errorData) {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                if (jsonDict && [jsonDict isKindOfClass:NSDictionary.class]) {
                    NSString *keyErrorCode = @"errorCode";
                    if (jsonDict[keyErrorCode]) {
                        errorCode = [jsonDict[keyErrorCode] integerValue];
                    }
                }
            }
        }
        
//        [self checkErroeCode401:errorCode];
        
        if(block != nil) {
            block(nil, errorCode, error);
        }
    }];
}

- (void)getWithUrlKey:(NSString *)urlKey
           parameters:(NSDictionary *)parameters
              options:(NSDictionary *)options
                block:(OO_SERVER_BLOCK)block {
    //1. manager init
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self initHttpManager:manager urlKey:urlKey];
    
    NSString *baseUrl = [self baseUrl];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl,urlKey];
    
    NSString *urll= [[NSURL URLWithString:fullUrl relativeToURL:manager.baseURL] absoluteString];
    
    //    //设置缓存策略
    //    if ([options[XY_VIVA_SERVICE_OPTIONS_IS_NEED_CACHE] boolValue]) {
    //        [manager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    //    }else {
    //        [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //    }
    
    [manager GET:urll parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block != nil) {
            NSInteger code = 0;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                code = [[dic valueForKey:@"code"] integerValue];
            }
            
//            [self checkErroeCode401:code];
            
            block(nil, code, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger errorCode = 999;
        
        NSDictionary *errorInfo = error.userInfo;
        if (errorInfo && [errorInfo isKindOfClass:NSDictionary.class]) {
            NSData *errorData = errorInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                if (jsonDict && [jsonDict isKindOfClass:NSDictionary.class]) {
                    NSString *keyErrorCode = @"errorCode";
                    NSString *keyErrorMessage = @"errorMessage";
                    
                    if (jsonDict[keyErrorCode]) {
                        errorCode = [jsonDict[keyErrorCode] integerValue];
                    }
                }
            }
        }
        
//        [self checkErroeCode401:errorCode];
        
        if(block != nil) {
            block(nil, errorCode, error);
        }
    }];
}

#pragma mark -- manager init
-(void)initHttpManager:(AFHTTPSessionManager *)manager urlKey:(NSString *)urlKey {
    if (1 == 1) {
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    }else {
        manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.completionGroup = dispatch_group_create();
    manager.completionQueue = dispatch_queue_create([[NSString stringWithFormat:@"task.%@", self] UTF8String], NULL);
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    //2. security policy
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    manager.securityPolicy = securityPolicy;
    
    //3. header fileds
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];

    [headerFields setValue:@"application/json" forKey:@"Accept"];
    
    if (1 == 1) {
        [headerFields setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    }else {
        [headerFields setValue:@"application/json" forKey:@"Content-Type"];
    }

    [headerFields setValue:@"gzip" forKey:@"Accept-Encoding"];
    
//    if ([[XYMiniUserInfoMgr sharedMgr] loginUserInfo]) {
//        XYMiniUserInfo *user = [[XYMiniUserInfoMgr sharedMgr] loginUserInfo];
//        [headerFields setValue:user.token forKey:@"U-Token"];
//
//        NSString *uid = [NSString stringWithFormat:@"%ld",(long)user.uid];
//        [headerFields setValue:uid forKey:@"Uid"];
//    }
    [headerFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    [manager.requestSerializer setTimeoutInterval:30];
}

- (NSString *)baseUrl {
    return @"http://wd.km363.com";
}


@end
