//
//  ModifNameViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-24.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "ModifPhoneSecViewController.h"
#import "MBTextField.h"
#import "MBTimerButton.h"
#import "HttpWorkHelp.h"
@interface ModifPhoneSecViewController ()
{
    MBTextField *_nameTF;
}
@end

@implementation ModifPhoneSecViewController

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
    self.title = @"绑定手机修改";
   
    _nameTF = [[MBTextField alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 35)];
    _nameTF.backgroundColor=[UIColor clearColor];
    _nameTF.placeholder = @"请输入验证码";
    _nameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_nameTF];
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 65, (kScreenWidth-40), 40);
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 7.0f;
    [loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.layer.borderWidth=0.5;
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //在手机交易码的后面是一个按钮，用来发送手机交易码
    MBTimerButton *timerBtn = [MBTimerButton buttonWithType:UIButtonTypeCustom];
    timerBtn.frame = CGRectMake((kScreenWidth-100)/2,120,100,30);
    [timerBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    timerBtn.titleLabel.textAlignment = UITextAlignmentCenter;
    [timerBtn addTarget:self action:@selector(sendSmcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:timerBtn];
    [timerBtn _timerButtonPressed];
    
}

//修改手机
- (void)getCodeBtnPressed
{
    
    if ([MBNonEmptyStringNo_(_nameTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入手机验证码");
        return;
    }
    
    
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setMobileTwo&token=%@&m_code=%@&m_mobile=%@&m_checkcode=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),_phoneStr,MBNonEmptyStringNo_(_nameTF.text)];
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];

        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"手机号不能未空");
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x003"]) {
            MBAlert(@"手机号已经被注册");
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x004"]) {
            MBAlert(@"验证码参数为空");
        }if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x005"]) {
            MBAlert(@"验证码过期失效");
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];

    

}
//获取验证码
-(void)sendSmcBtnAction:(MBTimerButton*)btn
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=getVerifyCode&m_mobile=%@",ROOTURLSTR,MBNonEmptyStringNo_(_phoneStr)];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            MBAlert(@"手机验证码成功发送");
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


@end
