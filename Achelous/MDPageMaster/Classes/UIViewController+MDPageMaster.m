//
//  UIViewController+MDPageMaster.m
//  MDPageMaster
//
//  Created by lizitao on 2018/5/4.
//

#import "UIViewController+MDPageMaster.h"

@implementation UIViewController (MDPageMaster)

+ (BOOL)isSingleton
{
    //考虑到VivaVideo中大部分页面都是栈中唯一的，因此设为YES；子类可重写设为NO，例如Webview
    return YES;
}

- (void)handleWithURLAction:(MDUrlAction *)urlAction
{
    
}

@end
