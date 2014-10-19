//
//  AddAddressInMapViewController.m
//  BOCPLCI
//
//  Created by IBM on 14-10-18.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "AddAddressInMapViewController.h"
#import "BMapKit.h"
#import "BMKAnnotation.h"
@interface AddAddressInMapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    BMKPointAnnotation*pointAnnotation;
    BMKAnnotationView* _newAnnotation;
    BMKGeoCodeSearch* _geocodesearch;
    MBProgressHUD* _HUD;

}
@end

@implementation AddAddressInMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];

    [self.contentView addSubview:_mapView];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    self.title = @"地址查询";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectNameOver)];
    


    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = _location;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    _HUD = [[MBProgressHUD alloc]initWithView:self.contentView];
    _HUD.labelText = @"定位中...";
    [_HUD show:YES];
    [self.contentView addSubview:_HUD];

}
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    if (_newAnnotation == nil) {
        _newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        ((BMKPinAnnotationView*)_newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        ((BMKPinAnnotationView*)_newAnnotation).animatesDrop = YES;
        // 设置可拖拽
        ((BMKPinAnnotationView*)_newAnnotation).draggable = YES;
    }
    _newAnnotation.center = _mapView.center;
    return _newAnnotation;
    
}
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{

    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){view.annotation.coordinate.latitude, view.annotation.coordinate.longitude};
    pointAnnotation.coordinate = pt;

    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

    
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@-%@-%@-%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        pointAnnotation.title = showmeg;
    }
    [_HUD hide:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GETDETAILADDREFROMMAP object:nil];
}
//设置完成
-(void)selectNameOver{
    [[NSNotificationCenter defaultCenter]postNotificationName:GETDETAILADDREFROMMAP object:pointAnnotation userInfo:nil];
    NSLog(@"%@",self.navigationController.viewControllers);
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated {
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self;

    pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = _location;
    pointAnnotation.title = _address;
    [_mapView addAnnotation:pointAnnotation];
    


    
}

-(void)viewWillDisappear:(BOOL)animated {
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil;

}
@end
