//
//  MYAlertView.m
//  BOCPLCI
//
//  Created by Ivan Li on 13-10-24.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBAlertView.h"
#import "MBConstant.h"

@implementation MBAlertView

- (void)show{
    [super show];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_dismiss)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];
}

- (void)_dismiss{
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
}

@end
