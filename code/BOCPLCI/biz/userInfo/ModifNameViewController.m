//
//  ModifNameViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-24.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "ModifNameViewController.h"
#import "MBTextField.h"
#import "HttpWorkHelp.h"
@interface ModifNameViewController ()
{
    MBTextField *_nameTF;
}
@end

@implementation ModifNameViewController

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
    self.title = @"昵称修改";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectNameOver)];
    
    _nameTF = [[MBTextField alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth-20, 35)];
    _nameTF.backgroundColor=[UIColor clearColor];
    _nameTF.placeholder = @"请输入昵称";
    _nameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_nameTF];
}

//完成修改
- (void)selectNameOver
{
    
    if ([MBNonEmptyStringNo_(_nameTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入昵称");
        return;
    }
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];

    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setUserName&token=%@&m_code=%@&m_name=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),MBNonEmptyStringNo_(_nameTF.text)];

    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];

        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"昵称不能未空");
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x003"]) {
            MBAlert(@"昵称已经被使用");
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
}


@end
