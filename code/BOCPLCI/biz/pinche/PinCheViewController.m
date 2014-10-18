//
//  PinCheViewController.m
//  BOCPLCI
//
//  Created by IBM on 14-10-11.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "PinCheViewController.h"
#import "MBTextField.h"
#import "MBLabel.h"
#import "AddressSetViewController.h"
#import "BMapKit.h"
@interface PinCheViewController ()<UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;

    UIButton*_addFromBtn;
    UIButton*_addToBtn;
    NSMutableArray *_addBtnArray;
    NSMutableArray *_addBtnArrayTwo;
    MBTextField *_peopleTF;
    MBTextField *_sayDetailTF;
    UIImageView *_sepeImageTho2Bg;
    BOOL _isZhuanche;
    BOOL _isAuto;
    
    MBLabel*_addFromLabel;
    MBLabel*_addToLabel;
    
    BMKGeoCodeSearch* _geocodesearch;

}
@end

@implementation PinCheViewController

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

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [_locService startUserLocationService];

    // Do any additional setup after loading the view.
    _addBtnArray = [[NSMutableArray alloc]initWithCapacity:2];
    _addBtnArrayTwo = [[NSMutableArray alloc]initWithCapacity:2];
    _isZhuanche = NO;
    self.title = @"拼车";
    [self initWithView];
    
}

//目的地 原
-(void)addFromBtnPressed{
    
    AddressSetViewController * addRess = [[AddressSetViewController alloc]init];
    [self.navigationController pushViewController:addRess animated:YES];
}
//地址转换
-(void)changeAddBtnPressed{
    
    
}

//目的地
-(void)addToBtnPressed{
    AddressSetViewController * addRess = [[AddressSetViewController alloc]init];
    [self.navigationController pushViewController:addRess animated:YES];
    
}
-(void)initWithView{
    
    UIImageView*_imageViewThree =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 112-39)];
    _imageViewThree.layer.borderWidth  = 0.5f;
    _imageViewThree.layer.cornerRadius  = 7.0f;
    _imageViewThree.backgroundColor = [UIColor whiteColor];
    _imageViewThree.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_imageViewThree];
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
    
    
    _addToLabel = [[MBLabel alloc]initWithFrame:CGRectMake(70, 38, kScreenWidth-120, 30)];
    _addToLabel.font = kNormalTextFont;
    [_imageViewThree addSubview:_addToLabel];
    
    _addToBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addToBtn addTarget:self action:@selector(addToBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _addToBtn.frame = CGRectMake(70, 41, kScreenWidth-90-30, 30);
    [_imageViewThree addSubview:_addToBtn];
    
    
    UIImageView*_imageViewTwo =[[UIImageView alloc]initWithFrame:CGRectMake(10, 90, kScreenWidth-20, 112)];
    _imageViewTwo.layer.borderWidth  = 0.5f;
    _imageViewTwo.layer.cornerRadius  = 7.0f;
    _imageViewTwo.backgroundColor = [UIColor whiteColor];
    _imageViewTwo.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_imageViewTwo];
    _imageViewTwo.alpha=0.6;
    _imageViewTwo.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamelTwo22  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelTwo22.backgroundColor =[UIColor clearColor];
    _itemNamelTwo22.font =kNormalTextFont;
    _itemNamelTwo22.text = @"拼车时间: ";
    _itemNamelTwo22.textColor = [UIColor grayColor];
    [_imageViewTwo addSubview:_itemNamelTwo22];
    

    UIImageView *sepeImageTho2 =[[UIImageView alloc]initWithFrame:CGRectMake(0, 36, kScreenWidth-20, 1)];
    sepeImageTho2.backgroundColor = [UIColor grayColor];
    [_imageViewTwo addSubview:sepeImageTho2];
    sepeImageTho2.alpha=0.6;
    
    
    UILabel*_itemNamelTwo222  =[[UILabel alloc]initWithFrame:CGRectMake(10, 55, 60, 30)];
    _itemNamelTwo222.backgroundColor =[UIColor clearColor];
    _itemNamelTwo222.font =kNormalTextFont;
    _itemNamelTwo222.text = @"拼车人数: ";
    _itemNamelTwo222.textColor = [UIColor grayColor];
    [_imageViewTwo addSubview:_itemNamelTwo222];
    
    for (int i=0; i<3; i++) {
        UIView *viewABOUT  =[[UIView alloc]initWithFrame:CGRectMake(70+(kScreenWidth-100)/3*i, 40, (kScreenWidth-100)/3-2, 33)];
        viewABOUT.backgroundColor = HEX(@"#fffaf0");
        [_imageViewTwo addSubview:viewABOUT];
        
        UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(70+(kScreenWidth-100)/3*i, 40, (kScreenWidth-100)/3-2, 33);
        loginBtn.backgroundColor = [UIColor clearColor];
        loginBtn.layer.cornerRadius = 3.0f;
        [loginBtn setTitle:[NSString stringWithFormat:@"%d人",i+1] forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        loginBtn.layer.borderWidth=0.5;
        loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
        [_imageViewTwo addSubview:loginBtn];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.tag=i+1;
        [loginBtn addTarget:self action:@selector(getCodeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtnArray addObject:loginBtn];
        
    }
    
    for (int i=0; i<3; i++) {
        UIView *viewABOUT  =[[UIView alloc]initWithFrame:CGRectMake(70+(kScreenWidth-100)/3*i, 75, (kScreenWidth-100)/3-2, 33)];
        viewABOUT.backgroundColor = HEX(@"#fffaf0");
        [_imageViewTwo addSubview:viewABOUT];
        
        if(i==0){
        
            UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(70+(kScreenWidth-100)/3*i, 75, (kScreenWidth-100)/3-2, 33);
            loginBtn.backgroundColor = [UIColor clearColor];
            loginBtn.layer.cornerRadius = 3.0f;
            [loginBtn setTitle:[NSString stringWithFormat:@"%d人",i+1+3] forState:UIControlStateNormal];
            loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            loginBtn.layer.borderWidth=0.5;
            loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
            [_imageViewTwo addSubview:loginBtn];
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            loginBtn.tag=i+1+3;
            [loginBtn addTarget:self action:@selector(getCodeBtnPressedTwo:) forControlEvents:UIControlEventTouchUpInside];
            [_addBtnArray addObject:loginBtn];
        }
        if (i==1) {
            

            
            _sepeImageTho2Bg =[[UIImageView alloc]initWithFrame:CGRectMake(70+(kScreenWidth-100)/3*i, 75, (kScreenWidth-100)/3-2, 33)];
            _sepeImageTho2Bg.backgroundColor = [UIColor clearColor];
            _sepeImageTho2Bg.image = [UIImage imageNamed:@"tv_unselect_bg.9.png"];
            [_imageViewTwo addSubview:_sepeImageTho2Bg];
            
            _peopleTF = [[MBTextField alloc]initWithFrame:CGRectMake(70+(kScreenWidth-100)/3*i, 75, (kScreenWidth-100)/3-2-20, 33)];
            _peopleTF.backgroundColor=[UIColor clearColor];
            _peopleTF.borderStyle=UITextBorderStyleNone;
            _peopleTF.keyboardType = UIKeyboardTypeNumberPad;
            [_imageViewTwo addSubview:_peopleTF];
            _peopleTF.delegate=self;
            _peopleTF.textAlignment = UITextAlignmentCenter;
            UILabel *count =[[UILabel alloc]initWithFrame:CGRectMake(70+(kScreenWidth-100)/3*i+(kScreenWidth-100)/3-2-20, 75, 20, 33)];
            count.text = @"人";
            [_imageViewTwo addSubview:count];

            UIImageView *sepeImageTho22 =[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-100)/3*i+70, 105, (kScreenWidth-100)/3-2-20, 1)];
            sepeImageTho22.backgroundColor = [UIColor grayColor];
            [_imageViewTwo addSubview:sepeImageTho22];
            sepeImageTho22.alpha=0.6;
         

            
        }
        if(i==2){
            
            UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(70+(kScreenWidth-100)/3*i, 75, (kScreenWidth-100)/3-2, 33);
            loginBtn.backgroundColor = [UIColor clearColor];
            loginBtn.layer.cornerRadius = 3.0f;
            [loginBtn setTitle:@"专车" forState:UIControlStateNormal];
            loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            loginBtn.layer.borderWidth=0.5;
            loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
            [_imageViewTwo addSubview:loginBtn];
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            loginBtn.tag=i+1+3;
            [loginBtn addTarget:self action:@selector(getCodeBtnPressedZhuChe:) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    
    
    UIImageView*_imageViewTwoLast =[[UIImageView alloc]initWithFrame:CGRectMake(10, 220, kScreenWidth-20, 112)];
    _imageViewTwoLast.layer.borderWidth  = 0.5f;
    _imageViewTwoLast.layer.cornerRadius  = 7.0f;
    _imageViewTwoLast.backgroundColor = [UIColor whiteColor];
    _imageViewTwoLast.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_imageViewTwoLast];
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
        
    }
    
    _sayDetailTF = [[MBTextField alloc]initWithFrame:CGRectMake(70, 65, (kScreenWidth-100)/3-2-20, 33)];
    _sayDetailTF.backgroundColor=[UIColor clearColor];
    _sayDetailTF.borderStyle=UITextBorderStyleNone;
    _sayDetailTF.keyboardType = UIKeyboardTypeNumberPad;
    [_imageViewTwoLast addSubview:_sayDetailTF];

    
    UIImageView *sepeImageTho222 =[[UIImageView alloc]initWithFrame:CGRectMake(70, 95, (kScreenWidth-130), 1)];
    sepeImageTho222.backgroundColor = [UIColor grayColor];
    [_imageViewTwoLast addSubview:sepeImageTho222];
    
    
    UIButton *loginBtnLast =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtnLast.frame = CGRectMake(kScreenWidth-60, 65, 34, 34);
   
    [_imageViewTwoLast addSubview:loginBtnLast];
    [loginBtnLast setBackgroundImage:[UIImage imageNamed:@"bg_add_image.png"] forState:UIControlStateNormal];
    [loginBtnLast addTarget:self action:@selector(addDetailAboutImage:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *showImage;
    _isAuto = NO;
    if (_isAuto) {
        showImage = @"tag_selected.png";
    } else {
        showImage = @"tag_not_selected.png";
        
        
    }
    
    UIButton*_autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _autoLoginBtn.frame = CGRectMake(20, 350, 20, 20);
    [self.contentView addSubview:_autoLoginBtn];
    [_autoLoginBtn setBackgroundImage:[UIImage imageNamed:showImage] forState:UIControlStateNormal];
    [_autoLoginBtn addTarget:self action:@selector(autoLoginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(45, 340, 160, 42)];
    label.text = @"申请VIP服务并同意";
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    
    UIButton*forPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forPwdBtn.frame = CGRectMake(kScreenWidth-140, 340, 130, 42);
    [self.contentView addSubview:forPwdBtn];
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
    [self.contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView contentSizeToFit];
}
//发布
-(void)getCodeBtnPressed{
    
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
    
}
-(void)getCodeBtnPressedTwoAbout:(UIButton*)btn
{
    for (int i=0; i<_addBtnArrayTwo.count; i++) {
        UIButton *show = (UIButton*)_addBtnArrayTwo[i];
        [show setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
        
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"] forState:UIControlStateNormal];
    
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
-(void)getCodeBtnPressed:(UIButton*)btn
{
    for (int i=0; i<_addBtnArray.count; i++) {
        UIButton *show = (UIButton*)_addBtnArray[i];
        [show setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];

    }
    [btn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"] forState:UIControlStateNormal];
    _sepeImageTho2Bg.image = [UIImage imageNamed:@"tv_unselect_bg.9.png"];

}
-(void)getCodeBtnPressedTwo:(UIButton*)btn
{
    for (int i=0; i<_addBtnArray.count; i++) {
        UIButton *show = (UIButton*)_addBtnArray[i];
        [show setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
        
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"] forState:UIControlStateNormal];
    _sepeImageTho2Bg.image = [UIImage imageNamed:@"tv_unselect_bg.9.png"];

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length>0) {
        _sepeImageTho2Bg.image = [UIImage imageNamed:@"tv_select_bg.9.png"];
        for (int i=0; i<_addBtnArray.count; i++) {
            UIButton *show = (UIButton*)_addBtnArray[i];
            [show setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
            
        }
    }
}
@end
