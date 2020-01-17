//
//  OOServerApiName.h
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户登录
static NSString *const kApi_user_Iuserlogin = @"/api/api/Iuserlogin";

//巡查相关
static NSString *const kApi_patrol_returnhk         = @"/api/api/returnhk";
static NSString *const kApi_patrol_Beginxc          = @"/api/api/Beginxc";
static NSString *const kApi_patrol_Endxc            = @"/api/api/Endxc";
static NSString *const kApi_patrol_Upgps            = @"/api/api/Upgps";
static NSString *const kApi_patrol_ImgUpload        = @"/api/api/ImgUpload";
static NSString *const kApi_patrol_Xclist           = @"/api/api/Xclist";
static NSString *const kApi_patrol_Xczblist         = @"/api/api/Xczblist";
static NSString *const kApi_patrol_Upsjinfo         = @"/api/api/Upsjinfo";
static NSString *const kApi_patrol_getUserInfo      = @"/api/api/getUserInfo";
static NSString *const kApi_patrol_updateXcStatus   = @"/api/api/updateXcStatus";


//菜单列表接口
static NSString *const kApi_patrol_Appmenu   = @"/api/api/Appmenu";

//地理相关
//static NSString *const kApi_patrol_Appmenu   = @"/api/api/Appmenu";
//static NSString *const kApi_patrol_Appmenu   = @"/api/api/Appmenu";


@interface OOServerApiName : NSObject

@end
