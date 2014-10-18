//
//  AddressSetViewController.m
//  BOCPLCI
//
//  Created by IBM on 14-10-12.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "AddressSetViewController.h"
#import "JSONKit.h"
#import "MBSelectView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MBTextField.h"
#import "BMapKit.h"
@interface AddressSetViewController ()<BMKLocationServiceDelegate>
{
    BMKLocationService* _locService;

    MBSelectView *_proviceAbout;
    MBSelectView *_shiAbout;
    MBSelectView *_quviceAbout;
    MBTextField *_searchAddTF;
}
@end

@implementation AddressSetViewController
//完成
- (void)selectNameOver
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSDictionary *)allPlacesInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryAndCity" ofType:@"txt"];
    NSStringEncoding coding = NSUTF8StringEncoding;
    NSString *infoString = [NSString stringWithContentsOfFile:path usedEncoding:&coding error:nil];
    NSDictionary *result = [infoString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return result;
}
- (NSArray *)allProvinces
{
    NSArray *array = nil;
    NSDictionary *allPlaces = [self allPlacesInfo];
    array = allPlaces[@"top"];
    return array;
}
- (NSString *)getProvinceCodeWithProvinceName:(NSString *)privName
{
    NSArray * allProcinInfo = [self allProvinces];
    for ( int i=0; i<allProcinInfo.count; i++) {
        NSDictionary *dicOfProOne = allProcinInfo[i];
        NSString *oneValeStr = dicOfProOne[@"name"];
        if ([oneValeStr isEqualToString:privName]) {
            return MBNonEmptyString(dicOfProOne[@"code"]);
        }
    }
    return @"";
}
- (NSArray *)allCitiesWithProvinceCode:(NSString *)proCode
{
    NSArray *array = nil;
    if (MBIsStringWithAnyText(proCode)) {
        array = [[self allPlacesInfo] objectForKey:proCode];
    }
    return array;
}
-(NSMutableArray *)getContentAboutTownOfOneProvinceWithProVinceName:(NSString *)privName andWithOneKey:(NSString *)keyStr
{
    NSArray *arry=[self allCitiesWithProvinceCode:[self getProvinceCodeWithProvinceName:privName]];
    NSMutableArray *oneArr = [NSMutableArray arrayWithCapacity:2];
    for ( int i=0; i<arry.count; i++) {
        NSString *oneValeStr = arry[i][keyStr];
        [oneArr addObject:oneValeStr];
    }
    return oneArr;
}
-(void)viewWillAppear:(BOOL)animated {
   
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
   
    _locService.delegate = nil;
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地址设置";
    _locService = [[BMKLocationService alloc]init];

    [_locService startUserLocationService];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectNameOver)];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryAndCity" ofType:@"txt"];
    NSStringEncoding coding = NSUTF8StringEncoding;
    NSString *infoString = [NSString stringWithContentsOfFile:path usedEncoding:&coding error:nil];
    NSDictionary *result = [infoString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSLog(@"%@",result[@"top"]);
    
    NSArray *allProvice  = result[@"top"];
    NSMutableArray *proviceCity  = [NSMutableArray arrayWithCapacity:2];
    for (int i=0; i<allProvice.count; i++) {
        NSDictionary *dicAbout = allProvice[i];
        [proviceCity addObject:MBNonEmptyStringNo_(dicAbout[@"name"])];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, (kScreenWidth-20), 35)];
    [self.contentView addSubview:imageView];
    imageView.layer.borderWidth=0.5;
    imageView.layer.borderColor=[UIColor grayColor].CGColor;
    imageView.layer.cornerRadius = 5.0f;
    imageView.userInteractionEnabled = YES;
    for (int i=0;i<2;i++) {
        UIImageView *imageViewSep = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3*(i+1), 0, 1, 35)];
        imageViewSep.backgroundColor = [UIColor grayColor];
        [imageView addSubview:imageViewSep];
        
    }
    for (int i=0;i<3;i++) {
        
        
        if (i==0) {
            _proviceAbout = [[MBSelectView alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3*i, 5, (kScreenWidth-20)/3, 30)];
            _proviceAbout.selectType = MBSelectTypeNormal;
            _proviceAbout.backgroundColor = [UIColor clearColor];
            [imageView addSubview:_proviceAbout];
            [_proviceAbout addTarget:self forVauleChangedaction:@selector(proviceAboutChange:)];
            _proviceAbout.options = proviceCity;
        }
        if (i==1) {
            _shiAbout = [[MBSelectView alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3*i, 5, (kScreenWidth-20)/3, 30)];
            _shiAbout.selectType = MBSelectTypeNormal;
            _shiAbout.backgroundColor = [UIColor clearColor];
            [imageView addSubview:_shiAbout];
            [_shiAbout addTarget:self forVauleChangedaction:@selector(shiAboutChange:)];
            _shiAbout.options =[self getContentAboutTownOfOneProvinceWithProVinceName:_proviceAbout.value andWithOneKey:@"name"];

        }
        if (i==2) {
            _quviceAbout = [[MBSelectView alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3*i, 5, (kScreenWidth-20)/3, 30)];
            _quviceAbout.selectType = MBSelectTypeNormal;
            _quviceAbout.backgroundColor = [UIColor clearColor];
            [imageView addSubview:_quviceAbout];
            [_quviceAbout addTarget:self forVauleChangedaction:@selector(quAboutChange:)];
            _quviceAbout.options = proviceCity;
        }
        UIImageView *imageViewSep = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3*(i+1)-17, 16, 15, 8)];
        imageViewSep.backgroundColor = [UIColor clearColor];
        imageViewSep.image = [UIImage imageNamed:@"bg_search_addr_down.png"];
        [imageView addSubview:imageViewSep];
        
    }

    
   UIButton* _showBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _showBtn.frame = CGRectMake(10, 55, 15, 25);
    [_showBtn setImage:[UIImage imageNamed:@"icon_location.png"] forState:UIControlStateNormal];
    [_showBtn addTarget:self action:@selector(locationBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showBtn];
    
    
    _searchAddTF = [[MBTextField alloc]initWithFrame:CGRectMake(30, 55, kScreenWidth-60-50, 30)];
    _searchAddTF.backgroundColor=[UIColor clearColor];
    _searchAddTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_searchAddTF];
    
    
    UIButton*_showAddreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _showAddreBtn.frame = CGRectMake(kScreenWidth-70, 55, 65, 30);
    _showAddreBtn.backgroundColor = [UIColor orangeColor];
    _showAddreBtn.layer.cornerRadius = 3.0f;
    [_showAddreBtn setTitle:@"地图查找" forState:UIControlStateNormal];
    _showAddreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _showAddreBtn.layer.borderWidth=0.5;
    _showAddreBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_showAddreBtn];
    [_showAddreBtn addTarget:self action:@selector(_showAddreBtnPressed) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *spectImageViewe  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth, 1)];
    spectImageViewe.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:spectImageViewe];
    
}

//地图查找
-(void)_showAddreBtnPressed{
    
}
//定位
-(void)locationBtnPressed{

    
}
//区改变
-(void)quAboutChange:(MBSelectView*)select{
}
-(void)uploadCity:(NSArray*)array
{
    _quviceAbout.options =array;
    
    if (array.count>0) {
        _quviceAbout.value = array[0];
        _quviceAbout.userInteractionEnabled=YES;
        
    }else
    {
        _quviceAbout.value = @" ";
        _quviceAbout.userInteractionEnabled=NO;
        
        
    }
    
}
-(void)getCiryArray
{
    NSArray *array =[self getcontentAboutAreaOfOneProvinceCode:[self getProvinceCodeWithProvinceName:_proviceAbout.value] andTownName:_shiAbout.value andWithOneKey:@"name"];
    [self performSelectorOnMainThread:@selector(uploadCity:) withObject:array waitUntilDone:NO];
    
}
//市改变
-(void)shiAboutChange:(MBSelectView*)select{
    NSThread *newThread =[[NSThread alloc]initWithTarget:self selector:@selector(getCiryArray) object:nil];
    [newThread start];
}
//省会改变
-(void)proviceAboutChange:(MBSelectView*)select{
    NSThread *newThread =[[NSThread alloc]initWithTarget:self selector:@selector(getProvinceArray) object:nil];
    [newThread start];
}
-(void)getProvinceArray
{
    NSArray *array = [self getContentAboutTownOfOneProvinceWithProVinceName:_proviceAbout.value andWithOneKey:@"name"];
    
    [self performSelectorOnMainThread:@selector(uploadProviece:) withObject:array waitUntilDone:NO];
    
}
- (NSString *)getTownCodeWithTownName:(NSString *)townName andProVinceCode:(NSString *)proCode
{
    NSArray *array =[self allCitiesWithProvinceCode:proCode];
    for ( int i=0; i<array.count; i++) {
        NSDictionary *dicOfProOne = array[i];
        NSString *oneValeStr = dicOfProOne[@"name"];
        if ([oneValeStr isEqualToString:townName]) {
            return MBNonEmptyString(dicOfProOne[@"code"]);
        }
    }
    return @"";
}
- (NSArray *)allTownsWithCityCode:(NSString *)cityCode
{
    NSArray *array = nil;
    if (MBIsStringWithAnyText(cityCode)) {
        array = [[self allPlacesInfo] objectForKey:cityCode];
    }
    return array;
}
- (NSMutableArray *)getcontentAboutAreaOfOneProvinceCode:(NSString *)proCode andTownName:(NSString *)townName andWithOneKey:(NSString *)keyStr{
    
    NSString *townCode = [self getTownCodeWithTownName:townName andProVinceCode:proCode];
    NSArray *array =[self allTownsWithCityCode:townCode];
    NSMutableArray *oneArr = [NSMutableArray arrayWithCapacity:2];
    for ( int i=0; i<array.count; i++) {
        NSString *oneValeStr = array[i][keyStr];
        [oneArr addObject:oneValeStr];
    }
    return oneArr;
}
-(void)uploadProviece:(NSArray *)array
{
    _shiAbout.options =array;
    
    if (array.count>0) {
        _shiAbout.value = array[0];
        _shiAbout.userInteractionEnabled=YES;
        
        
    }else
    {
        _shiAbout.value = @" ";
        _shiAbout.userInteractionEnabled=NO;
        
        
    }
    _quviceAbout.options = nil;
    
    NSArray *arrayOfIEDS =[self getcontentAboutAreaOfOneProvinceCode:[self getProvinceCodeWithProvinceName:_proviceAbout.value] andTownName:_shiAbout.value andWithOneKey:@"name"];
    _quviceAbout.options =arrayOfIEDS;
    
    if (array.count>0) {
        _quviceAbout.value = arrayOfIEDS[0];
        _quviceAbout.userInteractionEnabled=YES;
        
    }else
    {
        _quviceAbout.value = @" ";
        _quviceAbout.userInteractionEnabled=NO;
        
    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
