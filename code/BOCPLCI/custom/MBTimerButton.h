//
//  MBTimerButton.h
//  BOCMBCI
//
//  Created by Tracy E on 13-4-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
/**
 *自定义倒计时Button，默认从60开始
 */
#import <UIKit/UIKit.h>

@interface MBTimerButton : UIButton

@property (nonatomic, unsafe_unretained) NSInteger timeInterval;
-(void)_timerButtonPressed;
@end
