//
//  MBLoadingView.h
//  BOCMBCI
//
//  Created by Tracy E on 13-5-28.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
// 正在通讯时弹出
#import <UIKit/UIKit.h>

@interface MBLoadingView : UIView {
    UIActivityIndicatorView *_activityIndicatorView;
}
@property (nonatomic, unsafe_unretained) BOOL canCancel;
@property (nonatomic, strong) NSOperation *requestOperation;
- (void)show;
- (void)hide;

@end
