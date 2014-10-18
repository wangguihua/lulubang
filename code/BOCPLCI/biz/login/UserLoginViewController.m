//
//  UserLoginViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBTextField.h"
#import "UserReginOneViewController.h"
#import "RepadOneViewController.h"
#import "HttpWorkHelp.h"
@interface UserLoginViewController ()
{
    MBTextField *_userNameTF;
    MBTextField *_padTF;
    UIButton *_autoLoginBtn;
    BOOL _isAuto;
}
@end

@implementation UserLoginViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户登录";
    [self initWithView];
    
}


-(void)initWithView{

    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 90)];
    imageView.layer.borderWidth  = 0.5f;
    imageView.layer.cornerRadius  = 7.0f;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageView];
    imageView.alpha=0.6;
    
    UIImageView *spectViewImage  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 55, kScreenWidth-20, 1)];
    spectViewImage.backgroundColor =[UIColor grayColor];
    spectViewImage.alpha = 0.4;
    [self.contentView addSubview:spectViewImage];
    
    UIImageView *userNameImage  = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 25, 25)];
    userNameImage.image =[UIImage imageNamed:@"tab_person.png"];
    [self.contentView addSubview:userNameImage];
    
    _userNameTF = [[MBTextField alloc]initWithFrame:CGRectMake(50, 15, kScreenWidth-50, 45)];
    [self.contentView addSubview:_userNameTF];
    _userNameTF.placeholder = @"请输入手机号";
    
    UIImageView *padImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(15, 23+45, 25, 25)];
    padImageView.image =[UIImage imageNamed:@"tab_password.png"];
    [self.contentView addSubview:padImageView];
    
    _padTF = [[MBTextField alloc]initWithFrame:CGRectMake(50, 13+45, kScreenWidth-50, 45)];
    [self.contentView addSubview:_padTF];
    _padTF.placeholder = @"请输入6-16位密码";
    _padTF.secureTextEntry = YES;
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, 105, (kScreenWidth-30)/2, 40);
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 7.0f;
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.layer.borderWidth=0.5;
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *reginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    reginBtn.frame = CGRectMake(10+(kScreenWidth-30)/2+10, 105, (kScreenWidth-30)/2, 40);
    reginBtn.backgroundColor = [UIColor whiteColor];
    reginBtn.layer.cornerRadius = 7.0f;
    [reginBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    reginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    reginBtn.layer.borderWidth=0.5;
    reginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    reginBtn.titleLabel.textColor = kNormalTextColor;
    [reginBtn setTitleColor:kNormalTextColor forState:UIControlStateHighlighted];
    [reginBtn setTitleColor:kNormalTextColor forState:UIControlStateSelected];
    [reginBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    [self.contentView addSubview:reginBtn];
    [reginBtn addTarget:self action:@selector(regtinBtnBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
    NSString *showImage;
    _isAuto = [[[NSUserDefaults standardUserDefaults]valueForKey:STATUEABOUTUSER]boolValue];
    if (_isAuto) {
        showImage = @"tag_selected.png";
    } else {
        showImage = @"tag_not_selected.png";
        
        
    }
    
    _autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _autoLoginBtn.frame = CGRectMake(20, 155, 20, 20);
    [self.contentView addSubview:_autoLoginBtn];
    [_autoLoginBtn setBackgroundImage:[UIImage imageNamed:showImage] forState:UIControlStateNormal];
    [_autoLoginBtn addTarget:self action:@selector(autoLoginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(45, 143, 60, 42)];
    label.text = @"自动登录";
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    
    
    UILabel *forPadlabel =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 143, 80, 42)];
    forPadlabel.text = @"忘记密码?";
    forPadlabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:forPadlabel];
    forPadlabel.textColor = [UIColor grayColor];
    forPadlabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    UIButton*forPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forPwdBtn.frame = CGRectMake(kScreenWidth-100, 143, 80, 42);
    [self.contentView addSubview:forPwdBtn];
    [forPwdBtn addTarget:self action:@selector(forpawdBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
}

//登录
-(void)loginBtnBtnPressed:(UIButton*)btn
{
    
    
    if ([MBNonEmptyStringNo_(_userNameTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入手机号");
        return;
    }
    if ([MBNonEmptyStringNo_(_padTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入登录密码");
        return;
    }

    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=login&m_mobile=%@&m_pwd=%@",ROOTURLSTR,MBNonEmptyStringNo_(_userNameTF.text),MBNonEmptyStringNo_(_padTF.text)];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults]setValue:dic forKey:TOOKNANDCODEINFO];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:STATUEABOUTUSER];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"帐号或密码不正确");
        }
       
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];

    

}

//注册
-(void)regtinBtnBtnPressed:(UIButton*)btn
{
    UserReginOneViewController *regOne  =[[UserReginOneViewController alloc]init];
    [self.navigationController pushViewController:regOne animated:YES];
}
//忘记密码
-(void)forpawdBtnPressed{
    RepadOneViewController *regOne  =[[RepadOneViewController alloc]init];
    [self.navigationController pushViewController:regOne animated:YES];
    
}
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



@end
