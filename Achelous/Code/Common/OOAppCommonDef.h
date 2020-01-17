//
//  OOAppCommonDef.h
//  Achelous
//
//  Created by hzy on 2019/12/24.
//  Copyright © 2019 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef OOAppCommonDef_h
#define OOAppCommonDef_h

typedef void(^OOCompleteBlock)(BOOL complete);

#define SAFE_TOP                         [OOAPPMgr sharedMgr].safeTopArea
#define SAFE_BOTTOM                      [OOAPPMgr sharedMgr].safeBottomArea

#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height


#define PREF_KEY_NETWORK_AVAILABLE_STATE_CHANGE                              @"pref_key_network_available_state_change"
#define PREF_KEY_USER_LOGIN_SUCCESS               @"pref_key_user_login_success"
#define PREF_KEY_USER_LOGOUT                      @"pref_key_user_logout"


#endif /* OOAppCommonDef_h */
