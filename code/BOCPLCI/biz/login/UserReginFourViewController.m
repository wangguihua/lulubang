//
//  UserReginOneViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserReginFourViewController.h"
#import "HelpViewController.h"
@interface UserReginFourViewController ()

@end

@implementation UserReginFourViewController

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
        if (i==3) {
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
        if (i==3) {
            labelItenOne.textColor = [UIColor blackColor];
            
        }else{
            
            labelItenOne.textColor = [UIColor grayColor];
            
        }
    }
    

    UILabel *labelItenOne =[[UILabel alloc]initWithFrame:CGRectMake(0,70,kScreenWidth,25)];
    labelItenOne.text = @"注册成功";
    labelItenOne.backgroundColor = [UIColor clearColor];
    labelItenOne.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:labelItenOne];
    labelItenOne.font = [UIFont boldSystemFontOfSize:17];
    labelItenOne.textColor = [UIColor greenColor];
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 100, (kScreenWidth-40), 40);
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 7.0f;
    [loginBtn setTitle:@"进入App" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.layer.borderWidth=0.5;
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *techinBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    techinBtn.frame = CGRectMake(20, 150, (kScreenWidth-40), 40);
    techinBtn.backgroundColor = [UIColor orangeColor];
    techinBtn.layer.cornerRadius = 7.0f;
    [techinBtn setTitle:@"帮助教程" forState:UIControlStateNormal];
    techinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    techinBtn.layer.borderWidth=0.5;
    techinBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:techinBtn];
    [techinBtn addTarget:self action:@selector(getCodeTechBtnPressed) forControlEvents:UIControlEventTouchUpInside];

}


//进入App
-(void)getCodeBtnPressed{

    NSLog(@"%@",self.navigationController.viewControllers);
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}
//帮助教程
-(void)getCodeTechBtnPressed{

    HelpViewController *helper = [[HelpViewController alloc]init];
    [self.navigationController pushViewController:helper animated:YES];
}
@end
