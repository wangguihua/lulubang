//
//  MBGuideViewController.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBGuideViewController : UIViewController
{
    UIScrollView *_pageScroll;
}

@property (nonatomic, strong) UIScrollView *pageScroll;

+ (MBGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end

