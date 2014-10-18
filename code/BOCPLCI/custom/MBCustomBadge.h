//
//  MBCustomBadge.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-7.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
/*
 创建徽标
 */
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MBCustomBadge : UIView {
	// 显示内容
	NSString *badgeText;
    // 内容颜色
	UIColor *badgeTextColor;
    // 内容背景色
	UIColor *badgeInsetColor;
    // 边框的颜色
	UIColor *badgeFrameColor;
	BOOL badgeFrame;
	BOOL badgeShining;
	CGFloat badgeCornerRoundness;
	CGFloat badgeScaleFactor;
}

@property(nonatomic,retain) NSString *badgeText;
@property(nonatomic,retain) UIColor *badgeTextColor;
@property(nonatomic,retain) UIColor *badgeInsetColor;
@property(nonatomic,retain) UIColor *badgeFrameColor;

@property(nonatomic,readwrite) BOOL badgeFrame;
@property(nonatomic,readwrite) BOOL badgeShining;

@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;

/**
 * 创建对象的两个方法
 * badgeString 徽标显示内容，当该值为0时徽标不显示
 * stringColor 徽标内容的颜色
 * insetColor 徽标背景色
 * badgeFrameYesNo 要不要显示边框
 * scale 徽标的显示比例，正常比例为1.0f
 * shining 阴影
 */
+ (MBCustomBadge *) customBadgeWithString:(NSString *)badgeString;
+ (MBCustomBadge *) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;

/**
 * 设置徽标的显示内容
 */
- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end
