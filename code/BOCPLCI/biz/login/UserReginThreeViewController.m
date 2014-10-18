//
//  UserReginOneViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserReginThreeViewController.h"
#import "MBTextField.h"
#import "UserReginFourViewController.h"
#import "HttpWorkHelp.h"
@interface UserReginThreeViewController ()
{
    MBTextField *_useNameTF;
    MBTextField *_newPadTF;
    MBTextField *_reNewPadTF;

}
@end

@implementation UserReginThreeViewController

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
    self.navigationItem.hidesBackButton=YES;
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
        if (i==2) {
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
        if (i==2) {
            labelItenOne.textColor = [UIColor blackColor];
            
        }else{
            
            labelItenOne.textColor = [UIColor grayColor];
            
        }
    }
    
    _useNameTF = [[MBTextField alloc]initWithFrame:CGRectMake(20, 80, kScreenWidth-40, 35)];
    _useNameTF.backgroundColor=[UIColor clearColor];
    _useNameTF.placeholder = @"会员昵称:";
    _useNameTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_useNameTF];
    

    _newPadTF = [[MBTextField alloc]initWithFrame:CGRectMake(20, 80+50, kScreenWidth-40, 35)];
    _newPadTF.backgroundColor=[UIColor clearColor];
    _newPadTF.placeholder = @"设置密码:";
    _newPadTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_newPadTF];
    
    
    _reNewPadTF = [[MBTextField alloc]initWithFrame:CGRectMake(20, 80+35+60, kScreenWidth-40, 35)];
    _reNewPadTF.backgroundColor=[UIColor clearColor];
    _reNewPadTF.placeholder = @"确认密码:";
    _reNewPadTF.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_reNewPadTF];
    
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 220, (kScreenWidth-40), 40);
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 7.0f;
    [loginBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.layer.borderWidth=0.5;
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    

}


//免费注册
-(void)getCodeBtnPressed{

    if ([MBNonEmptyStringNo_(_useNameTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入昵称");
        return;
    }
    if ([MBNonEmptyStringNo_(_newPadTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入新密码");
        return;
    }if ([MBNonEmptyStringNo_(_reNewPadTF.text) isEqualToString:@""]) {
        MBAlert(@"请输入确认密码");
        return;
    }if (![MBNonEmptyStringNo_(_newPadTF.text) isEqualToString:MBNonEmptyStringNo_(_reNewPadTF.text)]) {
        MBAlert(@"两次输入密码不一致");
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=regMemberThree&m_mobile=%@&m_username=%@&m_password=%@",ROOTURLSTR,_phoneStr,MBNonEmptyStringNo_(_useNameTF.text),MBNonEmptyStringNo_(_newPadTF.text)];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);

        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            UserReginFourViewController *fourSetp  =[[UserReginFourViewController alloc]init];
            [self.navigationController pushViewController:fourSetp animated:YES];
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"手机号不能未空");
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x003"]) {
            MBAlert(@"手机号已经被注册");
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x004"]) {
            MBAlert(@"手机号未经过验证");
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x005"]) {
            MBAlert(@"昵称不能为空");
        }if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x006"]) {
            MBAlert(@"昵称已经被使用");
        }if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x007"]) {
            MBAlert(@"密码不能为空");
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];

    
    

}


@end
