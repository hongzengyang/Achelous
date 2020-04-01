//
//  OOUserMgr.h
//  Achelous
//
//  Created by hzy on 2020/1/13.
//  Copyright © 2020 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OOUserInfo : NSObject

@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *Uzw;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, copy) NSString *AreaCode;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *ADNM;

@end

@interface OOUserMgr : NSObject
+ (OOUserMgr *)sharedMgr;

- (BOOL)isLogin;
- (OOUserInfo *)loginUserInfo;
- (void)logout;

- (void)loginWithAccount:(NSString *)account password:(NSString *)password completeBlock:(OOCompleteBlock)completeBlock;

- (void)refreshUserInfoWithCompleteHandle:(void(^)(BOOL complete))completeHandle;

@end

NS_ASSUME_NONNULL_END
