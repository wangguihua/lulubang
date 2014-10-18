//  MBConstant.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-4.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAdditions.h"

//--------------------------------------------------------------------------------------------------
#pragma mark-尺寸宏定义

#pragma mark-该屏幕的宽和高仅限于横屏
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kStatusBarHeight 20.0f
#define kNavigationBarHeight 44.0f
#define kNavigationBarLandscapeHeight 33.0f
#define kTabBarHeight 49.0f
#define kContentViewHeight (kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight)
#define kPickerViewHeight 216.0f
#define kToolBarHeight 44.0f
#define kStepViewHeight 25.0f
#define kTextFieldHeight 25.0f
#define kInputViewHeight (kPickerViewHeight + kToolBarHeight)
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
#pragma mark - 方法宏定义（只适用创建ViewController时使用）
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7)
#define CGRECT_NO_NAV(x,y,w,h)   CGRectMake((x), (y), (w), (h + (IsIOS7?20:0)))
#define CGRECT_HAVE_NAV(x,y,w,h) CGRectMake((x), (y), (w), (h + (IsIOS7?64:0)))
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
#pragma mark - 界面字体宏定义(请开发项目前定义好字体大小)
//大标题 40点
#define kBigTitleFont [UIFont boldSystemFontOfSize:20]

//小标题 28点
#define kSmallTitleFont [UIFont boldSystemFontOfSize:14]

//普通文本，正文
#define kNormalTextFont [UIFont boldSystemFontOfSize:13]

//正文按钮字体
#define kButtonTitleFont [UIFont boldSystemFontOfSize:14]
//--------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------
#pragma mark - 颜色宏定义
//#202020
#define kNormalTextColor [UIColor colorWithRed:(32 / 255.0) green:(32 / 255.0) blue:(32 / 255.0) alpha:1]

//#ffffff
#define kWhiteTextColor [UIColor whiteColor]

//#ba001d
#define kRedTextColor [UIColor colorWithRed:(186 / 255.0) green:0 blue:(29 / 255.0) alpha:1]

//#919191
#define kTipTextColor [UIColor colorWithRed:(145 / 255.0) green:(145 / 255.0) blue:(145 / 255.0) alpha:1]

//#c6c6c6
#define kStepViewTextColor [UIColor colorWithRed:(198 / 255.0) green:(198 / 255.0) blue:(198 / 255.0) alpha:1]

//#016622
#define kGreenColor [UIColor colorWithRed:(1 / 255.0) green:(102 / 255.0) blue:(34 / 255.0) alpha:1]
//--------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------
#pragma mark - 按钮位置宏定义
#define kMiddleButtonFrame(__offsetY) CGRectMake(56, __offsetY,208, 40)

#define kLeftButtonFrame(__offsetY) CGRectMake(10, __offsetY, 138, 39)
#define kRightButtonFrame(__offsetY) CGRectMake(172, __offsetY, 138, 39)
//一行三个按钮
#define kLineButton1(__offsetY) CGRectMake(5, __offsetY, 104, 39)
#define kLineButton2(__offsetY) CGRectMake(108, __offsetY, 104, 39)
#define kLineButton3(__offsetY) CGRectMake(211, __offsetY, 104, 39)
//--------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------
#pragma mark - 操作词汇定义
#define kConfirmButtonTitle     @"确定"
#define kCancelButtonTitle      @"取消"
#define kLastButtonTitle        @"上一步"
#define kNextButtonTitle        @"下一步"
#define kCompleteButtonTitle    @"完成"
#define kAcceptButtonTitle      @"接受"
#define kDisAcceptButtonTitle   @"不接受"
#define kMoreTitle              @"更多"
#define kCloseButtonTitle       @"关闭"
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
#define kBooleanTrueString @"1"
#define kBooleanFalseString @"0"
#define kEmptyString @""
//--------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------
#pragma mark - 通知宏定义
#define MBUserDidLoginNotification @"MBUserDidLoginNotification"
#define MBUserDidLogoutNotification @"MBUserDidLogoutNotification"

#define MBSelectViewWillShowNotification @"MBSelectViewWillShowNotification"
#define MBSelectViewWillHideNotification @"MBSelectViewWillHideNotification"
#define MBSelectViewDidShowNotification @"MBSelectViewDidShowNotification"
#define MBSelectViewDidHideNotification @"MBSelectViewDidHideNotification"

#define MBAlertViewDidShowNotification @"MBAlertViewDidShowNotification"
#define MBAlertViewDidHideNotification @"MBAlertViewDidHideNotification"

#define MBLoadingViewDidHideNotification @"MBLoadingViewDidHideNotification"
#define MBExceptionAlertViewDidHideNotification @"MBExceptionAlertViewDidHideNotification"
//--------------------------------------------------------------------------------------------------


@interface MBConstant : NSObject


@end



