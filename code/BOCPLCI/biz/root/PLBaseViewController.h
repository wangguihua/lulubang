//
//  PLViewController.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-10-24.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBBaseScrollView.h"

@interface PLBaseViewController : UIViewController

@property (nonatomic, strong) MBBaseScrollView *contentView;

- (void)modalPresent:(UIViewController *)controller;    //弹出ModalViewController
- (void)modalDismiss:(BOOL)animated;                    //消失ModalViewController

@end
