//
//  UserInfoViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-22.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AsynImageView.h"
#import "UserInfoTableViewCell.h"
#import "UserInfoDetailViewController.h"
#import "ApplyToOneViewController.h"
#import "MyServiceViewController.h"
#import "HttpWorkHelp.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UserInfoTableViewCellDelegate>

@end

@implementation UserInfoViewController

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
    self.title = @"个人中心";
    [self getUserInfo];
}
#pragma mark UITableView Delegate And UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        static NSString * cellStr = @"UserInfoTableViewCell_one";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.delegateAbout=self;
        }
        NSLog(@"%@",MBNonEmptyStringNo_(_userInfoAbout[@"m_rz_idcard"]));
        if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_rz_idcard"]) isEqualToString:@"3"]||[MBNonEmptyStringNo_(_userInfoAbout[@"m_rz_idcard"]) isEqualToString:@"0"]) {
            
            [cell initWithItemImageName:@"tag_account_amount.png" itemNameLabel:@"申请成为服务商家" andTwoName:@"" andShowRightImage:NO andShowRightBtn:YES andShowIndex:indexPath.section];

            
        }if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_rz_idcard"]) isEqualToString:@"1"]) {
            
            [cell initWithItemImageName:@"tag_account_amount.png" itemNameLabel:@"申请成为认证服务商家" andTwoName:@"" andShowRightImage:NO andShowRightBtn:YES andShowIndex:indexPath.section];

        }
        if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_rz_idcard"]) isEqualToString:@"2"]) {
            
            [cell initWithItemImageName:@"tag_account_amount.png" itemNameLabel:@"认证服务商家" andTwoName:@"" andShowRightImage:NO andShowRightBtn:NO andShowIndex:indexPath.section];

        }

        return cell;
    }
    if (indexPath.section==1) {
        static NSString * cellStr = @"UserInfoTableViewCell_two";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.delegateAbout=self;

            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        [cell initWithItemImageName:@"icon_send_rece.png" itemNameLabel:@"我的服务" andTwoName:@"我的需求" andShowRightImage:YES andShowRightBtn:NO andShowIndex:indexPath.section];
        return cell;
    }
    
    if (indexPath.section==2) {
        static NSString * cellStr = @"UserInfoTableViewCell_three";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.delegateAbout=self;

            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        [cell initWithItemImageName:@"icon_recharge.png" itemNameLabel:@"我要充值" andTwoName:@"我要提现" andShowRightImage:YES andShowRightBtn:NO andShowIndex:indexPath.section];
        return cell;
    }

    if (indexPath.section==3) {
        static NSString * cellStr = @"UserInfoTableViewCell_four";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.delegateAbout=self;

            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        [cell initWithItemImageName:@"icon_address.png" itemNameLabel:@"常用地址管理" andTwoName:@"" andShowRightImage:YES andShowRightBtn:NO andShowIndex:indexPath.section] ;
        return cell;
    }
    if (indexPath.section==4) {
        static NSString * cellStr = @"UserInfoTableViewCell_five";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.delegateAbout=self;

            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        [cell initWithItemImageName:@"share_tag.png" itemNameLabel:@"分享给朋友" andTwoName:@"邀请好友" andShowRightImage:YES andShowRightBtn:NO andShowIndex:indexPath.section];
        
        return cell;
    }
    if (indexPath.section==5) {
        static NSString * cellStr = @"UserInfoTableViewCell_fiveabout";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.delegateAbout=self;

            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        
        [cell initWithItemImageName:@"info_tag.png" itemNameLabel:@"关于路路帮" andTwoName:@"" andShowRightImage:YES andShowRightBtn:NO andShowIndex:indexPath.section];
            
        
        return cell;
    }
    if (indexPath.section==6) {
        static NSString * cellStr = @"UserInfoTableViewCell_foursix";
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.delegateAbout=self;

            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        [cell initWithItemImageName:@"setting_tag.png" itemNameLabel:@"系统设置" andTwoName:@"" andShowRightImage:YES andShowRightBtn:NO andShowIndex:indexPath.section];
        return cell;
    }


    return nil;
}
-(void)oneBtnPressed:(UserInfoTableViewCell *)one
{
    if (one.showIndex==1) {
        MyServiceViewController *myService = [[MyServiceViewController alloc]init];
        [self.navigationController pushViewController:myService animated:YES];
    }
}

-(void)twoBtnPressed:(UserInfoTableViewCell *)two
{
    
}
-(void)threeBtnPressed:(UserInfoTableViewCell *)three
{
    ApplyToOneViewController *appOne  = [[ApplyToOneViewController alloc]init];
    [self.navigationController pushViewController:appOne animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(void)initWithAllItemsValue{
    
    UITableView *tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kContentViewHeight-100+30) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor =[UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
    
}
-(void)getUserInfo
{
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];

    
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=getMember&token=%@&m_code=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"])];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
           
            _userInfoAbout = [[NSDictionary alloc]initWithDictionary:dic];
            
            [self initWithView];
            
        }else{
            MBAlert(@"服务器繁忙，请稍后再试试");

        }
        
        
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
        [self initWithView];
    }];

}
-(void)initWithView{
    

    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 90)];
    imageView.layer.borderWidth  = 0.5f;
    imageView.layer.cornerRadius  = 7.0f;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageView];
    imageView.alpha=0.6;
    
    AsynImageView *headImageView =[[AsynImageView alloc]initWithFrame:CGRectMake(15, 10, 70, 70)];
    
    if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_logo"]) isEqualToString:@""]) {
        headImageView.image =[UIImage imageNamed:@"tag_default_friend.png"];

    }else
    {
        headImageView.imageURL = [NSString stringWithFormat:@"%@%@",HEADIMAGEURLSTR,MBNonEmptyStringNo_(_userInfoAbout[@"m_logo"])];
    }
    [imageView addSubview:headImageView];
    headImageView.layer.borderWidth  = 0.5f;
    headImageView.layer.cornerRadius  = 7.0f;
    headImageView.backgroundColor = [UIColor whiteColor];
    headImageView.layer.borderColor=[UIColor grayColor].CGColor;
    
    NSString *userNamel = MBNonEmptyStringNo_(_userInfoAbout[@"m_name"]);
    CGSize size = [userNamel sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(300, 30)];
    UILabel *userNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 15, size.width+10, 30)];
    userNameLabel.text=userNamel;
    userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    userNameLabel.backgroundColor =[UIColor clearColor];
    [imageView addSubview:userNameLabel];
    
    UIImageView *sexImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(5+userNameLabel.frame.origin.x+userNameLabel.frame.size.width, 18, 18, 18)];
    if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_sex"]) isEqualToString:@"0"]) {
        sexImageView.image =[UIImage imageNamed:@"tag_sex_man.png"];
        
    }else
    {
        sexImageView.image =[UIImage imageNamed:@"tag_sex_woman.png"];

    }
    sexImageView.backgroundColor =[UIColor clearColor];
    [imageView addSubview:sexImageView];
    
    
    UILabel *moneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 50, kScreenWidth-90, 30)];
    moneyLabel.text = [NSString stringWithFormat:@"账户余额:%@元",MBNonEmptyStringNo_(_userInfoAbout[@"m_rmb"])];
    moneyLabel.font = [UIFont boldSystemFontOfSize:16];
    moneyLabel.backgroundColor =[UIColor clearColor];
    [imageView addSubview:moneyLabel];
    moneyLabel.textColor = [UIColor grayColor];
    
    
    UIImageView *startImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(20+userNameLabel.frame.origin.x+userNameLabel.frame.size.width+40, 22, 80, 15)];
    startImageView.image =[UIImage imageNamed:@"tag_good_star.png"];
    startImageView.backgroundColor =[UIColor clearColor];
    [imageView addSubview:startImageView];
    
    int index = 3.5;
    UIView *showStarView  =[[UIView alloc]initWithFrame:CGRectMake(20+userNameLabel.frame.origin.x+userNameLabel.frame.size.width+40+80-(5-index)/5.0*80, 22, (5-index)/5.0*80, 15)];
    showStarView.backgroundColor =[UIColor whiteColor];
    [imageView addSubview:showStarView];
    
    UIButton *showMoreDeital =[UIButton buttonWithType:UIButtonTypeCustom];
    showMoreDeital.frame = imageView.frame;
    [self.contentView addSubview:showMoreDeital];
    [showMoreDeital addTarget:self action:@selector(showmoreAboutUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self initWithAllItemsValue];

}

//查看个人信息
- (void)showmoreAboutUserInfo
{
    UserInfoDetailViewController *userinfo = [[UserInfoDetailViewController alloc]init];
    userinfo.userInfoAbout = _userInfoAbout;
    [self.navigationController pushViewController:userinfo animated:YES];
}



@end
