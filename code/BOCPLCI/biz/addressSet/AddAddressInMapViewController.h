//
//  AddAddressInMapViewController.h
//  BOCPLCI
//
//  Created by IBM on 14-10-18.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "PLBaseViewController.h"
#import "MBProgressHUD.h"

@interface AddAddressInMapViewController :PLBaseViewController
{
    BMKMapView* _mapView;
}
///地理编码位置
@property (nonatomic) CLLocationCoordinate2D location;
///地理编码地址
@property (nonatomic,retain) NSString* address;
@end
