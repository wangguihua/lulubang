//
//  ModifNameViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-24.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "ModifPhoneViewController.h"
#import "MBTextField.h"
#import "ModifPhoneSecViewController.h"
#import "HttpWorkHelp.h"
@interface ModifPhoneViewController ()
{
    MBTextField *_nameTF;
}
@end

@implementation ModifPhoneViewController

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
    _nameTF.placeholder = @"请输入手机号";
    _nameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_nameTF];
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 65, (kScreenWidth-40), 40);
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
- (void)getCodeBtnPressed
{
    
    if ([MBNonEmptyStringNo_(_nameTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入手机号");
        return;
    }
    if (MBNonEmptyStringNo_(_nameTF.text).length!=11) {
        MBAlert(@"请输入正确的手机号");
        return;
        
    }

    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setMobileOne&token=%@&m_code=%@&m_mobile=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),_nameTF.text];
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
           
            ModifPhoneSecViewController *sencon =[[ModifPhoneSecViewController alloc]init];
            sencon.phoneStr = _nameTF.text;
            [self.navigationController pushViewController:sencon animated:YES];
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
