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
#import "HttpWorkHelp.h"
#import "AddAddressInMapViewController.h"

@interface AddressSetViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;

    MBSelectView *_proviceAbout;
    MBSelectView *_shiAbout;
    MBSelectView *_quviceAbout;
    MBTextField *_searchAddTF;
    NSArray *_addList;
    MBProgressHUD* _HUD;
    CLLocationCoordinate2D _toAddre2D;
}
@end


@implementation AddressSetViewController
-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:GETDETAILADDREFROMMAPLIST object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GETDETAILADDREFROMMAPLISTABOUTBTN object:nil];
    
    
    
}
//完成
- (void)selectNameOver
{
    
    NSDictionary * resendDic = @{@"addressDetail":_searchAddTF.text,@"latitude":[NSString stringWithFormat:@"%f",_toAddre2D.latitude],@"longitude":[NSString stringWithFormat:@"%f",_toAddre2D.longitude]};

    
    [[NSNotificationCenter defaultCenter]postNotificationName:GETDETAILADDREFROMMAPLIST object:resendDic userInfo:nil];

    
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
    _geocodesearch.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
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
    [_locService stopUserLocationService];
    
    
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    _toAddre2D = pt;
    
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
        
        _searchAddTF.text = showmeg;
    }else
    {
        MBAlert(@"获取位置信息出错");
    }
    [_HUD hide:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地址设置";
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _HUD = [[MBProgressHUD alloc]initWithView:self.contentView];
    _HUD.labelText = @"定位中...";
    [_HUD hide:YES];
    [self.contentView addSubview:_HUD];
   
    
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
    
    [self getAddressList];
    
}

//获取常用地址列表接口
- (void)getAddressList
{
    

    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=getAddressList&token=%@&m_code=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"])];

    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            _addList = dic[@"list"];
            int hangIndex = _addList.count/3;
            
            
            for (int i=0; i<hangIndex; i++) {
                for (int j=0; j<3; j++) {
                    
                    UIButton*_showAddreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    _showAddreBtn.frame = CGRectMake(kScreenWidth/3*j, 55*i+95, kScreenWidth/3-20, 30);
                    _showAddreBtn.backgroundColor = [UIColor whiteColor];
                    _showAddreBtn.layer.cornerRadius = 3.0f;
                    [_showAddreBtn setTitle:_addList[i*3+j][@"ua_name"] forState:UIControlStateNormal];
                    _showAddreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                    _showAddreBtn.layer.borderWidth=0.5;
                    _showAddreBtn.tag =i*3+j;
                    _showAddreBtn.layer.borderColor=[UIColor grayColor].CGColor;
                    [self.contentView addSubview:_showAddreBtn];
                    [_showAddreBtn addTarget:self action:@selector(addRessBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.contentView addSubview:_showAddreBtn];
                    
                }

            }
            if(_addList.count<3){
            
                for (int i=0; i<_addList.count; i++) {
                    
                    UIButton*_showAddreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    _showAddreBtn.frame = CGRectMake(kScreenWidth/3*i, hangIndex*40+95, kScreenWidth/3-20, 30);
                    _showAddreBtn.backgroundColor = [UIColor whiteColor];
                    _showAddreBtn.layer.cornerRadius = 3.0f;
                    [_showAddreBtn setTitle:_addList[i][@"ua_name"] forState:UIControlStateNormal];
                    _showAddreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                    _showAddreBtn.layer.borderWidth=0.5;
                    [_showAddreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    _showAddreBtn.layer.borderColor=[UIColor grayColor].CGColor;
                    [self.contentView addSubview:_showAddreBtn];
                    [_showAddreBtn addTarget:self action:@selector(addRessBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    _showAddreBtn.tag= i;
                    [self.contentView addSubview:_showAddreBtn];
                }
            }
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
//            MBAlert(@"密码不能为空");
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
    
}
//地址选择
-(void)addRessBtnPressed:(UIButton*)btn
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:GETDETAILADDREFROMMAPLISTABOUTBTN object:_addList[btn.tag] userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//地图查找
-(void)_showAddreBtnPressed{
 
    [_HUD show:YES];
    
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= _shiAbout.value;
    geocodeSearchOption.address = _searchAddTF.text;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
   
    if (error == 0) {
        AddAddressInMapViewController *addre = [[AddAddressInMapViewController alloc]init];
        addre.location = result.location;
        addre.address= result.address;
        [self.navigationController pushViewController:addre animated:YES];

    }else
    {
        MBAlert(@"未找到相对应的信息");
    }
    [_HUD hide:YES];
}
//定位
-(void)locationBtnPressed{

    [_HUD show:YES];
    [_locService startUserLocationService];

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



@end
