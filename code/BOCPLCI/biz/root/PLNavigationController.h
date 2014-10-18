//
//  PLNavigationController.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-10-24.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLNavigationController : UINavigationController

/*
 * 增加右滑手势返回上一控制器，默认值为NO
 */
@property (nonatomic, unsafe_unretained) BOOL canDragBack;

@end
