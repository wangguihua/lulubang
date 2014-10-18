//
//  MBLabel.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-6.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//内容显示不完时，显示完整的方式
typedef enum{
    MBLabelPopTipView,//气泡提示
    MBLabelMovingView,//跑马灯
} MBLabelShowTipType;

@interface MBLabel : UILabel


@property (nonatomic, unsafe_unretained) MBLabelShowTipType showTipType;

@end
