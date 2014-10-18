//
//  UserReginOneViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserReginOneViewController.h"
#import "MBTextField.h"
#import "UserReginTwoViewController.h"
#import "AFHTTPClient.h"
#import "JSONKit.h"
#import "AFJSONUtilities.h"
#import "MBLoadingView.h"
#import "MBAlertView.h"
#import "HttpWorkHelp.h"
@interface UserReginOneViewController ()
{
    MBTextField *_phoneTF;
    UIButton *_isAgreeBtn;
    BOOL _isAuto;

}
@end

@implementation UserReginOneViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户注册";
    [self initWithView];
}
-(void)initWithView
{
    NSArray *itemName =@[@"输入手机号",@"输入验证码",@"设置密码",@"注册成功"];
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
    imageView.image =[UIImage imageNamed:@"steps_conent_bg.png"];
    [self.contentView addSubview:imageView];
    float spectValue = (kScreenWidth-25*4)/8;
    for (int i=0; i<itemName.count; i++) {
        UIImageView *itemOneImae  =[[UIImageView alloc]initWithFrame:CGRectMake(spectValue+(spectValue+25+spectValue)*i, 5, 25, 25)];
        [self.contentView addSubview:itemOneImae];
        if (i==0) {
            itemOneImae.image = [UIImage imageNamed:@"steps_bg_on.png"];

        }else{
        
            itemOneImae.image = [UIImage imageNamed:@"steps_bg.png"];

        }
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0,0,25,25)];
        label.text = [NSString stringWithFormat:@"%d",i+1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [itemOneImae addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        
        
        UILabel *labelItenOne =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4*i,30,kScreenWidth/4,25)];
        labelItenOne.text = itemName[i];
        labelItenOne.backgroundColor = [UIColor clearColor];
        labelItenOne.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:labelItenOne];
        labelItenOne.font = [UIFont boldSystemFontOfSize:12];
        if (i==0) {
            labelItenOne.textColor = [UIColor blackColor];
            
        }else{
            
            labelItenOne.textColor = [UIColor grayColor];
            
        }
    }
    
    _phoneTF = [[MBTextField alloc]initWithFrame:CGRectMake(20, 80, kScreenWidth-40, 35)];
    _phoneTF.backgroundColor=[UIColor clearColor];
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_phoneTF];
    
    
    NSString *showImage;
    _isAuto = YES;
    if (_isAuto) {
        showImage = @"tag_selected.png";
    } else {
        showImage = @"tag_not_selected.png";
        
        
    }
    
    _isAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _isAgreeBtn.frame = CGRectMake(20, 130, 20, 20);
    [self.contentView addSubview:_isAgreeBtn];
    [_isAgreeBtn setBackgroundImage:[UIImage imageNamed:showImage] forState:UIControlStateNormal];
    [_isAgreeBtn addTarget:self action:@selector(autoLoginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *labelArrge =[[UILabel alloc]initWithFrame:CGRectMake(45,122,80,35)];
    labelArrge.text = @"同意并接受";
    labelArrge.backgroundColor = [UIColor clearColor];
    labelArrge.textColor = [UIColor blackColor];
    labelArrge.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:labelArrge];
    labelArrge.font = [UIFont boldSystemFontOfSize:15];
    
    
    UIButton*seeAgremtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeAgremtn.frame = CGRectMake(110, 124, 200, 30);
    [seeAgremtn setTitle:@"<<注册服务条款>>" forState:UIControlStateNormal];
    [self.contentView addSubview:seeAgremtn];
    seeAgremtn.titleLabel.font =[UIFont boldSystemFontOfSize:15];
    [seeAgremtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [seeAgremtn addTarget:self action:@selector(seeAgremtnBtnPressed) forControlEvents:UIControlEventTouchUpInside];

    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 160, (kScreenWidth-40), 40);
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 7.0f;
    [loginBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.layer.borderWidth=0.5;
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//获取验证码
-(void)getCodeBtnPressed{

    
    if ([MBNonEmptyStringNo_(_phoneTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入手机号");
        return;
    }
    if (MBNonEmptyStringNo_(_phoneTF.text).length!=11) {
        MBAlert(@"请输入正确的手机号");
        return;

    }
    if (_isAuto==NO) {
        MBAlert(@"请接收注册协议");
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=regMemberOne&m_mobile=%@",ROOTURLSTR,MBNonEmptyStringNo_(_phoneTF.text)];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            UserReginTwoViewController *regTwo  =[[UserReginTwoViewController alloc]init];
            regTwo.phoneStr = _phoneTF.text;
            [self.navigationController pushViewController:regTwo animated:YES];
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"手机号不能未空");
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x003"]) {
            MBAlert(@"手机号已经被注册");
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
}
//条款
-(void)seeAgremtnBtnPressed{
    
}
//同意协议
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
