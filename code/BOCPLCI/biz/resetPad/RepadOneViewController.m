//
//  UserReginOneViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "RepadOneViewController.h"
#import "MBTextField.h"
#import "RepadTwoViewController.h"
#import "HttpWorkHelp.h"
@interface RepadOneViewController ()
{
    MBTextField *_phoneTF;


}
@end

@implementation RepadOneViewController

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
    self.title = @"密码重置";
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

    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=getCheckCode&m_mobile=%@",ROOTURLSTR,MBNonEmptyStringNo_(_phoneTF.text)];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            RepadTwoViewController *regTwo  =[[RepadTwoViewController alloc]init];
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


@end
