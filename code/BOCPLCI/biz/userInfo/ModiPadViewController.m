//
//  ModifNameViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-24.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "ModiPadViewController.h"
#import "MBTextField.h"
#import "HttpWorkHelp.h"
@interface ModiPadViewController ()
{
    MBTextField *_nameTF;
    MBTextField *_nameTwoTF;
}
@end

@implementation ModiPadViewController

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
    self.title = @"密码修改";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectNameOver)];
    
    _nameTF = [[MBTextField alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth-20, 35)];
    _nameTF.backgroundColor=[UIColor clearColor];
    _nameTF.placeholder = @"请输入新密码";
    _nameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_nameTF];
    
    _nameTwoTF = [[MBTextField alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth-20, 35)];
    _nameTwoTF.backgroundColor=[UIColor clearColor];
    _nameTwoTF.placeholder = @"请输入确认密码";
    _nameTwoTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_nameTwoTF];
    
}

//完成修改
- (void)selectNameOver
{

    if ([MBNonEmptyStringNo_(_nameTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入新密码");
        return;
    }if ([MBNonEmptyStringNo_(_nameTwoTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入确认密码");
        return;
    }if (![MBNonEmptyStringNo_(_nameTF.text) isEqualToString:MBNonEmptyStringNo_(_nameTwoTF.text)]) {
        MBAlert(@"两次输入密码不一致");
        return;
    }
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setPassword&token=%@&m_code=%@&m_password=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),_nameTwoTF.text];
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"密码不能为空");
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];

    
}



@end
