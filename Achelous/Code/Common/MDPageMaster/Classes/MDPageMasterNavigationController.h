//
//  MDPageMasterNavigationController.h
//  MDPageMaster
//
//  Created by lizitao on 2018/5/7.
//

#import <UIKit/UIKit.h>
#import "MDUrlAction.h"

@interface MDPageMasterNavigationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController withAnimation:(BOOL)animated;

- (void)popToViewController:(UIViewController *)viewController withAnimation:(BOOL)animated;

- (void)pushViewController:(UIViewController *)viewController withTransition:(MDNaviTransition *)naviTransition;

- (void)popToViewController:(UIViewController *)viewController withTransition:(MDNaviTransition *)naviTransition;

- (void)popCurrentViewControllerWithTransition:(MDNaviTransition *)naviTransition;

- (void)popToHomeViewControllerWithTransition:(MDNaviTransition *)naviTransition;

@end
