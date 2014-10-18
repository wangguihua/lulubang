//
//  AppDelegate.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-10-24.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager; 
}
@property (strong, nonatomic) UIWindow *window;

@end
