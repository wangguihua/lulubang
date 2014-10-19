//
//  PinCheViewController.m
//  BOCPLCI
//
//  Created by IBM on 14-10-11.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "KuaiDiViewController.h"
#import "MBTextField.h"
#import "MBLabel.h"
#import "AddressSetViewController.h"
#import "BMapKit.h"
#import "MBProgressHUD.h"
#import "MBSelectView.h"
#import "MBPresentView.h"
#import "MBAccessoryView.h"
#import "HttpWorkHelp.h"
#import "NSDateUtilities.h"
@interface KuaiDiViewController ()<UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,MBAccessoryViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BMKLocationService* _locService;
    
    UIButton*_addFromBtn;
    UIButton*_addToBtn;
    
    
    NSMutableArray *_addBtnArrayTwo;
    MBTextField *_peopleTF;
    MBTextField *_sayDetailTF;
    UIImageView *_sepeImageTho2Bg;
    BOOL _isZhuanche;
    BOOL _isAuto;
    
    MBLabel*_addFromLabel;
    MBLabel*_addToLabel;
    CLLocationCoordinate2D _addFrom2D;
    CLLocationCoordinate2D _toFrom2D;
    
    
    
    BMKGeoCodeSearch* _geocodesearch;
    MBProgressHUD* _HUD;
    
    UIButton *_timeBtn;//拼车
    MBLabel *_timeLabel;//拼车时间
    NSString *_curTimeStr;
    int _whitchDay;
    MBPresentView *_presentView;
    MBSelectView * _dateSelectView;
    UIDatePicker *_picker;
    UIView* _selectView ;
    
    UIButton *_loginBtnLast;//说明
    UIImage *_sayDetailImage;
    int _m_count;
    BOOL _m_ntop_one;
    BOOL _m_ntop_two;
    BOOL _m_ntop_three;
    
    
}
@end

@implementation KuaiDiViewController

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
    
    _addFrom2D = pt;
    
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
        
        _addFromLabel.text = showmeg;
        [_HUD hide:YES];
        
    }else
    {
        MBAlert(@"定位失败");
    }
    
}

-(void)getAddressDetailAbout:(NSNotification*)notc{
    NSLog(@"%@",[notc object]);
    BMKPointAnnotation *annotia = (BMKPointAnnotation*)[notc object];
    _addToLabel.text =annotia.title;
    
}

-(void)getAddressDetailAboutList:(NSNotification*)notc{
    NSLog(@"%@",[notc object]);
    NSDictionary *dicShow = (NSDictionary*)[notc object];
    _addToLabel.text =MBNonEmptyStringNo_(dicShow[@"addressDetail"]);
    
    
}

-(void)getAddressDetailAboutBtn:(NSNotification*)notc{
    NSLog(@"%@",[notc object]);
    NSDictionary *dicShow = (NSDictionary*)[notc object];
    _addToLabel.text =MBNonEmptyStringNo_(dicShow[@"ua_address"]);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _m_ntop_one =NO;
    _m_ntop_three =NO;
    _m_ntop_two =NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddressDetailAbout:) name:GETDETAILADDREFROMMAP object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddressDetailAboutList:) name:GETDETAILADDREFROMMAPLIST object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddressDetailAboutBtn:) name:GETDETAILADDREFROMMAPLISTABOUTBTN object:nil];
    
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [_locService startUserLocationService];
    
    // Do any additional setup after loading the view.
    _addBtnArrayTwo = [[NSMutableArray alloc]initWithCapacity:2];
    _isZhuanche = NO;
    self.title = @"快递";
    [self initWithView];
    
    _HUD = [[MBProgressHUD alloc]initWithView:self.contentView];
    _HUD.labelText = @"定位中...";
    [_HUD show:YES];
    [self.contentView addSubview:_HUD];
    
}

//目的地 原
-(void)addFromBtnPressed{
    
    AddressSetViewController * addRess = [[AddressSetViewController alloc]init];
    [self.navigationController pushViewController:addRess animated:YES];
}
//地址转换
-(void)changeAddBtnPressed{
    
    NSString *temStr = _addFromLabel.text;
    _addFromLabel.text = _addToLabel.text;
    _addToLabel.text = temStr;
    
}

//拼车时间
-(void)pinCheBtnPressed{
    
    _presentView = nil;
    
    _presentView = [[MBPresentView alloc] initHeightForData:400 withDeleteButton:NO];
    [self.contentView presentView:_presentView];
    
    UIButton *oneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    oneBtn.frame = CGRectMake(20, 35, (kScreenWidth-40-20-20), 40);
    oneBtn.backgroundColor = [UIColor orangeColor];
    oneBtn.layer.cornerRadius = 7.0f;
    [oneBtn setTitle:@"今天" forState:UIControlStateNormal];
    oneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    oneBtn.layer.borderWidth=0.5;
    oneBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [oneBtn addTarget:self action:@selector(getDateAbout:) forControlEvents:UIControlEventTouchUpInside];
    oneBtn.tag=1000;
    
    
    UIButton *twoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    twoBtn.frame = CGRectMake(20, 35+40+20, (kScreenWidth-40-20-20), 40);
    twoBtn.backgroundColor = [UIColor orangeColor];
    twoBtn.layer.cornerRadius = 7.0f;
    [twoBtn setTitle:@"明天" forState:UIControlStateNormal];
    twoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    twoBtn.layer.borderWidth=0.5;
    twoBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [twoBtn addTarget:self action:@selector(getDateAbout:) forControlEvents:UIControlEventTouchUpInside];
    twoBtn.tag=1001;
    
    
    
    UIButton *threeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    threeBtn.frame = CGRectMake(20, 35+40+20+60, (kScreenWidth-40-20-20), 40);
    threeBtn.backgroundColor = [UIColor orangeColor];
    threeBtn.layer.cornerRadius = 7.0f;
    [threeBtn setTitle:@"后天" forState:UIControlStateNormal];
    threeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    threeBtn.layer.borderWidth=0.5;
    threeBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [threeBtn addTarget:self action:@selector(getDateAbout:) forControlEvents:UIControlEventTouchUpInside];
    threeBtn.tag=1002;
    
    
    UIButton *fourBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    fourBtn.frame = CGRectMake(20, 35+40+20+120, (kScreenWidth-40-20-20), 40);
    fourBtn.backgroundColor = [UIColor orangeColor];
    fourBtn.layer.cornerRadius = 7.0f;
    [fourBtn setTitle:@"大后天" forState:UIControlStateNormal];
    fourBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    fourBtn.layer.borderWidth=0.5;
    fourBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [fourBtn addTarget:self action:@selector(getDateAbout:) forControlEvents:UIControlEventTouchUpInside];
    fourBtn.tag=1003;
    
    _presentView.contentSubviews = @[oneBtn,twoBtn,threeBtn,fourBtn];
    
    
    
    
}

-(void)accessoryViewDidPressedDoneButton:(MBAccessoryView *)view
{
 
    [_selectView removeFromSuperview];
    _curTimeStr = [NSString stringWithFormat:@"%@ %@",_curTimeStr,[_picker.date timeString]];
    
    if (_whitchDay==0) {
        _timeLabel.text = [NSString stringWithFormat:@"今天%@",[_picker.date timeString]];

    }
    if (_whitchDay==1) {
        _timeLabel.text = [NSString stringWithFormat:@"明天天%@",[_picker.date timeString]];
        
    }
    if (_whitchDay==2) {
        _timeLabel.text = [NSString stringWithFormat:@"后天%@",[_picker.date timeString]];
        
    }
    if (_whitchDay==3) {
        _timeLabel.text = [NSString stringWithFormat:@"大后天%@",[_picker.date timeString]];
        
    }
    
    NSLog(@"%@",_picker.date);
}
-(void)getDateAbout:(UIButton*)btn
{
    [_presentView removeFromSuperview];
   
    NSDate *curDate = [NSDate date];
    _whitchDay = btn.tag-1000;
    _curTimeStr = @"";
    
    _curTimeStr = [[curDate daysLater:btn.tag-1000] dateString];
    
    _selectView = nil;
   _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kToolBarHeight + kPickerViewHeight)];
    _selectView.backgroundColor = [UIColor whiteColor];
    
    MBAccessoryView *accessoryView = [[MBAccessoryView alloc] initWithDelegate:self];

    [_selectView addSubview:accessoryView];
    _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolBarHeight, kScreenWidth, kPickerViewHeight)];
    _picker.datePickerMode = UIDatePickerModeTime;
    [_selectView addSubview:_picker];
    
    [self.contentView.window addSubview:_selectView];
    
    
    [UIView animateWithDuration:0.26 animations:^{
        _selectView.transform = CGAffineTransformMakeTranslation(0, -(kToolBarHeight + kPickerViewHeight));
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MBSelectViewDidShowNotification object:self];
        finished = YES;
    }];
    

    
}

//目的地
-(void)addToBtnPressed{
    AddressSetViewController * addRess = [[AddressSetViewController alloc]init];
    [self.navigationController pushViewController:addRess animated:YES];
    
}
-(void)initWithView{
    
    MBBaseScrollView *baseView = [[MBBaseScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentViewHeight+49)];
    [self.contentView addSubview:baseView];
    
    UIImageView*_imageViewThree =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 112-39)];
    _imageViewThree.layer.borderWidth  = 0.5f;
    _imageViewThree.layer.cornerRadius  = 7.0f;
    _imageViewThree.backgroundColor = [UIColor whiteColor];
    _imageViewThree.layer.borderColor=[UIColor grayColor].CGColor;
    [baseView addSubview:_imageViewThree];
    _imageViewThree.alpha=0.6;
    _imageViewThree.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamelTwo2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelTwo2.backgroundColor =[UIColor clearColor];
    _itemNamelTwo2.font =kNormalTextFont;
    _itemNamelTwo2.text = @"出发地址: ";
    _itemNamelTwo2.textColor = [UIColor grayColor];
    [_imageViewThree addSubview:_itemNamelTwo2];
    
    
    _addFromLabel = [[MBLabel alloc]initWithFrame:CGRectMake(70, 0, kScreenWidth-120, 40)];
    _addFromLabel.numberOfLines=2;
    _addFromLabel.font = kNormalTextFont;
    [_imageViewThree addSubview:_addFromLabel];
    
    _addFromBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addFromBtn.frame = CGRectMake(70, 8, kScreenWidth-90-30, 30);
    [_addFromBtn addTarget:self action:@selector(addFromBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _addFromBtn.backgroundColor = [UIColor clearColor];
    [_imageViewThree addSubview:_addFromBtn];
    
    
    UIImageView *sepeImageTho =[[UIImageView alloc]initWithFrame:CGRectMake(0, 36, kScreenWidth-20-20-5, 1)];
    sepeImageTho.backgroundColor = [UIColor grayColor];
    [_imageViewThree addSubview:sepeImageTho];
    sepeImageTho.alpha=0.6;
    
    UIButton *changeAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    changeAdd.frame = CGRectMake(kScreenWidth-20-22, 22, 20, 20);
    [changeAdd setImage:[UIImage imageNamed:@"change_places.png"] forState:UIControlStateNormal];
    [changeAdd addTarget:self action:@selector(changeAddBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_imageViewThree addSubview:changeAdd];
    
    UILabel*_delegatLabelTwo2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 30+5+3, 60, 30)];
    _delegatLabelTwo2.backgroundColor =[UIColor clearColor];
    _delegatLabelTwo2.font =[UIFont boldSystemFontOfSize:12];
    _delegatLabelTwo2.numberOfLines=2;
    _delegatLabelTwo2.textColor = [UIColor grayColor];
    _delegatLabelTwo2.text = @"目的地址: ";
    [_imageViewThree addSubview:_delegatLabelTwo2];
    
    
    _addToLabel = [[MBLabel alloc]initWithFrame:CGRectMake(70, 38, kScreenWidth-120, 40)];
    _addToLabel.font = kNormalTextFont;
    _addToLabel.numberOfLines=2;
    [_imageViewThree addSubview:_addToLabel];
    
    _addToBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addToBtn addTarget:self action:@selector(addToBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _addToBtn.frame = CGRectMake(70, 41, kScreenWidth-90-30, 30);
    [_imageViewThree addSubview:_addToBtn];
    
    
    UIImageView*_imageViewTwo =[[UIImageView alloc]initWithFrame:CGRectMake(10, 90, kScreenWidth-20, 112/2-20)];
    _imageViewTwo.layer.borderWidth  = 0.5f;
    _imageViewTwo.layer.cornerRadius  = 7.0f;
    _imageViewTwo.backgroundColor = [UIColor whiteColor];
    _imageViewTwo.layer.borderColor=[UIColor grayColor].CGColor;
    [baseView addSubview:_imageViewTwo];
    _imageViewTwo.alpha=0.6;
    _imageViewTwo.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamelTwo22  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelTwo22.backgroundColor =[UIColor clearColor];
    _itemNamelTwo22.font =kNormalTextFont;
    _itemNamelTwo22.text = @"取件时间: ";
    _itemNamelTwo22.textColor = [UIColor grayColor];
    [_imageViewTwo addSubview:_itemNamelTwo22];
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.frame = CGRectMake(70, 8, kScreenWidth-90-30, 30);
    [_timeBtn addTarget:self action:@selector(pinCheBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _timeBtn.backgroundColor = [UIColor clearColor];
    
    
    
    
    _timeLabel = [[MBLabel alloc]initWithFrame:CGRectMake(70, 0, kScreenWidth-120, 40)];
    _timeLabel.font = kNormalTextFont;
    _timeLabel.numberOfLines=2;
    [_imageViewTwo addSubview:_timeLabel];
    
    [_imageViewTwo addSubview:_timeBtn];

    _curTimeStr =[[NSDate date]dateTimeString];
    _timeLabel.text = [NSString stringWithFormat:@"今天%@",[[NSDate date]timeString]];
    
        
        
    
    UIImageView*_imageViewTwoLast =[[UIImageView alloc]initWithFrame:CGRectMake(10, 220, kScreenWidth-20, 112)];
    _imageViewTwoLast.layer.borderWidth  = 0.5f;
    _imageViewTwoLast.layer.cornerRadius  = 7.0f;
    _imageViewTwoLast.backgroundColor = [UIColor whiteColor];
    _imageViewTwoLast.layer.borderColor=[UIColor grayColor].CGColor;
    [baseView addSubview:_imageViewTwoLast];
    _imageViewTwoLast.alpha=0.6;
    _imageViewTwoLast.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamelTwo22Last  =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 60, 30)];
    _itemNamelTwo22Last.backgroundColor =[UIColor clearColor];
    _itemNamelTwo22Last.font =kNormalTextFont;
    _itemNamelTwo22Last.text = @"注意事项: ";
    _itemNamelTwo22Last.textColor = [UIColor grayColor];
    [_imageViewTwoLast addSubview:_itemNamelTwo22Last];
    
    
    UIImageView *sepeImageTho2Last =[[UIImageView alloc]initWithFrame:CGRectMake(0, 56, kScreenWidth-20, 1)];
    sepeImageTho2Last.backgroundColor = [UIColor grayColor];
    [_imageViewTwoLast addSubview:sepeImageTho2Last];
    sepeImageTho2Last.alpha=0.6;
    
    
    UILabel*_itemNamelTwo222Last  =[[UILabel alloc]initWithFrame:CGRectMake(10, 65, 60, 30)];
    _itemNamelTwo222Last.backgroundColor =[UIColor clearColor];
    _itemNamelTwo222Last.font =kNormalTextFont;
    _itemNamelTwo222Last.text = @"说明内容: ";
    _itemNamelTwo222Last.textColor = [UIColor grayColor];
    [_imageViewTwoLast addSubview:_itemNamelTwo222Last];
    
    NSArray *showDetail = @[@"带小孩",@"带货物多",@"老人病人"];
    for (int i=0; i<3; i++) {
        UIView *viewABOUT  =[[UIView alloc]initWithFrame:CGRectMake(70+(kScreenWidth-100)/3*i, 10, (kScreenWidth-100)/3-2, 33)];
        viewABOUT.backgroundColor = HEX(@"#fffaf0");
        [_imageViewTwoLast addSubview:viewABOUT];
        
        UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(70+(kScreenWidth-100)/3*i, 10, (kScreenWidth-100)/3-2, 33);
        loginBtn.backgroundColor = [UIColor clearColor];
        loginBtn.layer.cornerRadius = 3.0f;
        [loginBtn setTitle:[NSString stringWithFormat:@"%@",showDetail[i]] forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        loginBtn.layer.borderWidth=0.5;
        loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
        [_imageViewTwoLast addSubview:loginBtn];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(getCodeBtnPressedTwoAbout:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtnArrayTwo addObject:loginBtn];
        loginBtn.tag=1000+i;
        
    }
    
    _sayDetailTF = [[MBTextField alloc]initWithFrame:CGRectMake(70, 65, (kScreenWidth-100)/3-2-20, 33)];
    _sayDetailTF.backgroundColor=[UIColor clearColor];
    _sayDetailTF.borderStyle=UITextBorderStyleNone;
    [_imageViewTwoLast addSubview:_sayDetailTF];
    
    
    UIImageView *sepeImageTho222 =[[UIImageView alloc]initWithFrame:CGRectMake(70, 95, (kScreenWidth-130), 1)];
    sepeImageTho222.backgroundColor = [UIColor grayColor];
    [_imageViewTwoLast addSubview:sepeImageTho222];
    
    
    _loginBtnLast =[UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtnLast.frame = CGRectMake(kScreenWidth-60, 65, 34, 34);
    
    [_imageViewTwoLast addSubview:_loginBtnLast];
    [_loginBtnLast setBackgroundImage:[UIImage imageNamed:@"bg_add_image.png"] forState:UIControlStateNormal];
    [_loginBtnLast addTarget:self action:@selector(addDetailAboutImage:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *showImage;
    _isAuto = NO;
    if (_isAuto) {
        showImage = @"tag_selected.png";
    } else {
        showImage = @"tag_not_selected.png";
        
        
    }
    
    UIButton*_autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _autoLoginBtn.frame = CGRectMake(20, 350, 20, 20);
    [baseView addSubview:_autoLoginBtn];
    [_autoLoginBtn setBackgroundImage:[UIImage imageNamed:showImage] forState:UIControlStateNormal];
    [_autoLoginBtn addTarget:self action:@selector(autoLoginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(45, 340, 160, 42)];
    label.text = @"申请VIP服务并同意";
    label.backgroundColor = [UIColor clearColor];
    [baseView addSubview:label];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    
    UIButton*forPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forPwdBtn.frame = CGRectMake(kScreenWidth-140, 340, 130, 42);
    [baseView addSubview:forPwdBtn];
    forPwdBtn.titleLabel.font= kNormalTextFont;
    [forPwdBtn setTitle:@"<<拼车协议>>" forState:UIControlStateNormal];
    [forPwdBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [forPwdBtn addTarget:self action:@selector(forpawdBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 385, (kScreenWidth-40), 40);
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 7.0f;
    [loginBtn setTitle:@"发布" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.layer.borderWidth=0.5;
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [baseView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(getCodeBtnPressedFaBu) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView contentSizeToFit];
}
//发布
-(void)getCodeBtnPressedFaBu{
    
    
    if ([MBNonEmptyStringNo_(_addFromLabel.text) isEqualToString:@""]) {
        MBAlert(@"出发地址不能为空");
        return;
    }
    if ([MBNonEmptyStringNo_(_addToLabel.text) isEqualToString:@""]) {
        MBAlert(@"目的地址不能为空");
        return;
    }
    
    if (!_isAuto) {
        MBAlert(@"必须同意协议");
        return;
    }
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];

    int m_countAbout=0;
    if (_m_count==0) {
        m_countAbout = [_peopleTF.text intValue];
    }else
    {
        m_countAbout = _m_count;
    }
    
    NSString * m_from_geopoint = [NSString stringWithFormat:@"%f,%f",_addFrom2D.latitude,_addFrom2D.longitude];
    
    NSString * m_to_geopoint = [NSString stringWithFormat:@"%f,%f",_toFrom2D.latitude,_toFrom2D.longitude];
    int m_baoche=0;
    if (_isZhuanche) {
        m_baoche=1;
    }else
    {
        m_baoche=0;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=addPinche&token=%@&m_code=%@&m_from_area=%@&m_to_area=%@&m_from_geopoint=%@&m_to_geopoint=%@&m_count=%d&m_baoche=%d&m_bcsm=%@&map_names=name1.jpg&m_ntop_one=%d&m_ntop_two=%d&m_ntop_three=%d&m_time=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),MBNonEmptyStringNo_(_addFromLabel.text),MBNonEmptyStringNo_(_addToLabel.text),m_from_geopoint,m_to_geopoint,m_countAbout,m_baoche,_sayDetailTF.text,_m_ntop_one,_m_ntop_two,_m_ntop_three,_curTimeStr];
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"这三天内未选标交易的信息已经有15条");
        }
    
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x602"]) {
            MBAlert(@"在异地登陆");
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
    
    
}
//同意申请vip
- (void)autoLoginBtnPressed:(UIButton*)btn
{
    _isAuto = !_isAuto;
    NSString *showImage;
    if (_isAuto) {
        showImage = @"tag_selected.png";
    } else {
        showImage = @"tag_not_selected.png";
    }
    [btn setBackgroundImage:[UIImage imageNamed:showImage] forState:UIControlStateNormal];
    
}
//服务协议
-(void)forpawdBtnPressed{
    
}
-(void)addDetailAboutImage:(UIButton*)btn
{
    UIActionSheet *shee = [[UIActionSheet alloc]initWithTitle:@"设置上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择本地照片" otherButtonTitles:@"拍照", nil];
    [shee showInView:self.contentView];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==2) {
        return;
    }
    UIImagePickerControllerSourceType sourceType ;
    if (buttonIndex==0) {
        //本地照片
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    if (buttonIndex==1) {
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [_loginBtnLast setImage:info[@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    _sayDetailImage =info[@"IImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)getCodeBtnPressedTwoAbout:(UIButton*)btn
{
    for (int i=0; i<_addBtnArrayTwo.count; i++) {
        UIButton *show = (UIButton*)_addBtnArrayTwo[i];
        [show setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
        
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"] forState:UIControlStateNormal];
    if (btn.tag==1000) {
        _m_ntop_one=YES;
        _m_ntop_two =NO;
        _m_ntop_three = NO;
    }
    if (btn.tag==1001) {
        _m_ntop_one=NO;
        _m_ntop_two =YES;
        _m_ntop_three = NO;
    }
    if (btn.tag==1002) {
        _m_ntop_one=NO;
        _m_ntop_two =NO;
        _m_ntop_three = YES;
    }
}
-(void)getCodeBtnPressedZhuChe:(UIButton*)btn
{
    _isZhuanche = !_isZhuanche;
    if (_isZhuanche) {
        [btn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"] forState:UIControlStateNormal];
        
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
        
    }
}


@end
