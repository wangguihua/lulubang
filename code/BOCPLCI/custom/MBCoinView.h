//
//  MBCoinView.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.

#import <UIKit/UIKit.h>

@interface MBCoinView : UIView

- (id) initWithPrimaryView: (UIView *) view1 andSecondaryView: (UIView *) view2 inFrame: (CGRect) frame;

@property (nonatomic, retain) UIView *primaryView;
@property (nonatomic, retain) UIView *secondaryView;
@property float spinTime;

@end
