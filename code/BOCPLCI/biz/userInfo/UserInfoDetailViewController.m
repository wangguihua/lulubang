//
//  UserInfoDetailViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-23.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserInfoDetailViewController.h"
#import "AsynImageView.h"
#import "ModifNameViewController.h"
#import "ModifPhoneViewController.h"
#import "MBPresentView.h"
#import "MBAccessoryView.h"
#import "HttpWorkHelp.h"
#import "ModiPadViewController.h"
#import "MBSelectView.h"
#import "NSDateUtilities.h"
@interface UserInfoDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MBAccessoryViewDelegate>
{
    MBPresentView*_presentView;
    UIDatePicker *datePicker;
    AsynImageView *_headImageView;
    UILabel *_userNameLabel;
    UIImageView *_sexImageView;
    UILabel *_moneyLabel;
    UITableView *_tableView;
}
@end

@implementation UserInfoDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
            if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_sex"]) isEqualToString:@"0"]) {
                _sexImageView.image =[UIImage imageNamed:@"tag_sex_man.png"];
                
            }else
            {
                _sexImageView.image =[UIImage imageNamed:@"tag_sex_woman.png"];
                
            }
            
            _moneyLabel.text=MBNonEmptyStringNo_(_userInfoAbout[@"m_mobile"]);
            
            NSString *userNamel = MBNonEmptyStringNo_(_userInfoAbout[@"m_name"]);
            CGSize size = [userNamel sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(300, 30)];
            
            _userNameLabel.frame = CGRectMake(90, 15, size.width+10, 30);
            _userNameLabel.text = userNamel;
            
            [_tableView reloadData];
            
        }else{
            MBAlert(@"服务器繁忙，请稍后再试试");
            
        }
        
        
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    [self initWithView];
    [self initWithAllItemsValue];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserInfo];
    
    
    
}
-(void)initWithAllItemsValue{
    
    _tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kContentViewHeight-100+30) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    return 2;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"基本信息";
    }
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr  =@"initWithAllItemsValue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        UIImageView*imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        imageView.tag=1000;
        imageView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:imageView];
        cell.backgroundColor =[UIColor clearColor];
        
        UILabel *showItem =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-200-20-40, 0, 200, 40)];
        showItem.tag=10001;
        showItem.font=kNormalTextFont;
        [cell.contentView addSubview:showItem];
        showItem.backgroundColor =[UIColor clearColor];
        showItem.textAlignment= UITextAlignmentRight;
        
        
        UIImageView*_rightImageView =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-30, 10, 12, 20)];
        _rightImageView.backgroundColor = [UIColor clearColor];
        _rightImageView.image =[UIImage imageNamed:@"tag_right.png"];
        [cell.contentView addSubview:_rightImageView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        MBSelectView*_timeFrom  =[[MBSelectView alloc]initWithFrame:CGRectMake(kScreenWidth-140,7+3, 140, 30)];
        _timeFrom.backgroundColor =[UIColor clearColor];
        _timeFrom.selectType = MBSelectTypeDate;
        [_timeFrom addTarget:self forVauleChangedaction:@selector(birthRateDateChange:)];
        [cell.contentView addSubview:_timeFrom];
        _timeFrom.hidden = YES;
        _timeFrom.tag=999;
        
    }
    UIImageView *imageView =(UIImageView*)[cell.contentView viewWithTag:1000];
    UILabel *showItem =(UILabel*)[cell.contentView viewWithTag:10001];
    showItem.hidden = NO;
    MBSelectView*_timeFrom = (MBSelectView*)[cell.contentView viewWithTag:999];
    _timeFrom.hidden = YES;
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text=@" 昵称";
            imageView.image =[[UIImage imageNamed:@"bg_list_up.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            showItem.text=MBNonEmptyStringNo_(_userInfoAbout[@"m_name"]);
        }
        if (indexPath.row==1) {
            imageView.image =[[UIImage imageNamed:@"bg_list_mid_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];

            cell.textLabel.text=@" 手机号";
            showItem.text=MBNonEmptyStringNo_(_userInfoAbout[@"m_mobile"]);

        } if (indexPath.row==2) {
            imageView.image =[[UIImage imageNamed:@"bg_list_down_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];

            cell.textLabel.text=@" 密码";
            showItem.text=@"*******";

        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            imageView.image =[[UIImage imageNamed:@"bg_list_up.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];

            cell.textLabel.text=@" 性别";
            if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_sex"]) isEqualToString:@"0"]) {
                showItem.text=@"男";

            }else{
                showItem.text=@"女";

            }

        }
        if (indexPath.row==1) {
            imageView.image =[[UIImage imageNamed:@"bg_list_down_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:20];
            showItem.hidden = YES;

            cell.textLabel.text=@" 出生日期";
            showItem.text=MBNonEmptyStringNo_(_userInfoAbout[@"m_birthday"]);
            _timeFrom.hidden = NO;
            _timeFrom.dateValue = [NSDate dateWithString:MBNonEmptyStringNo_(_userInfoAbout[@"m_birthday"])];
            [_timeFrom.button setTitle:MBNonEmptyStringNo_(_userInfoAbout[@"m_birthday"]) forState:UIControlStateNormal];

            if ([_timeFrom.dateValue isEqualToDate:[NSDate date]]) {
                [_timeFrom.button setTitle:@"" forState:UIControlStateNormal];
            }else{
                [_timeFrom.button setTitle:MBNonEmptyStringNo_([[NSDate dateWithString:_userInfoAbout[@"m_birthday"]] dateString]) forState:UIControlStateNormal];

            }

        }
    }
    return cell;
}
-(void)initWithView{
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 90)];
    imageView.layer.borderWidth  = 0.5f;
    imageView.layer.cornerRadius  = 7.0f;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageView];
    imageView.alpha=0.6;
    
    _headImageView =[[AsynImageView alloc]initWithFrame:CGRectMake(15, 10, 70, 70)];
    if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_logo"]) isEqualToString:@""]) {
        _headImageView.image =[UIImage imageNamed:@"tag_default_friend.png"];
        
    }else
    {
        _headImageView.imageURL = [NSString stringWithFormat:@"%@%@",HEADIMAGEURLSTR,MBNonEmptyStringNo_(_userInfoAbout[@"m_logo"])];
    }
    [imageView addSubview:_headImageView];
    _headImageView.layer.borderWidth  = 0.5f;
    _headImageView.layer.cornerRadius  = 7.0f;
    _headImageView.backgroundColor = [UIColor whiteColor];
    _headImageView.layer.borderColor=[UIColor grayColor].CGColor;
    
    NSString *userNamel = MBNonEmptyStringNo_(_userInfoAbout[@"m_name"]);
    CGSize size = [userNamel sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(300, 30)];
    
    _userNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 15, size.width+10, 30)];
    _userNameLabel.text=userNamel;
    _userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    _userNameLabel.backgroundColor =[UIColor clearColor];
    [imageView addSubview:_userNameLabel];
    
    _sexImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(5+_userNameLabel.frame.origin.x+_userNameLabel.frame.size.width, 18, 18, 18)];
    if ([MBNonEmptyStringNo_(_userInfoAbout[@"m_sex"]) isEqualToString:@"0"]) {
        _sexImageView.image =[UIImage imageNamed:@"tag_sex_man.png"];
        
    }else
    {
        _sexImageView.image =[UIImage imageNamed:@"tag_sex_woman.png"];
        
    }
    _sexImageView.backgroundColor =[UIColor clearColor];
    [imageView addSubview:_sexImageView];
    
    
    _moneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 50, kScreenWidth-90, 30)];
    
    _moneyLabel.text=MBNonEmptyStringNo_(_userInfoAbout[@"m_mobile"]);
    _moneyLabel.font = [UIFont boldSystemFontOfSize:16];
    _moneyLabel.backgroundColor =[UIColor clearColor];
    [imageView addSubview:_moneyLabel];
    _moneyLabel.textColor = [UIColor grayColor];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            ModifNameViewController *modifName  = [[ModifNameViewController alloc]init];
            [self.navigationController pushViewController:modifName animated:YES];
        }
        if (indexPath.row==1) {
            ModifPhoneViewController *modifName  = [[ModifPhoneViewController alloc]init];
            [self.navigationController pushViewController:modifName animated:YES];
        }
        if (indexPath.row==2) {
            ModiPadViewController *modifName  = [[ModiPadViewController alloc]init];
            [self.navigationController pushViewController:modifName animated:YES];
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [self _presentView];
        }
        if (indexPath.row==1) {
          
            
        }
    }
}
-(void)birthRateDateChange:(MBSelectView*)datePick
{
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSLog(@"%@",datePick.dateValue);
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setBirthday&token=%@&m_code=%@&m_birthday=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),MBNonEmptyStringNo_([datePick.dateValue dateString])];
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {

        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"日期不能未空");
        }
        
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];

}

#pragma mark - MBPresentView
- (void)_presentView
{
    _presentView = [[MBPresentView alloc] initHeight:200 withDeleteButton:NO];
    [self.contentView presentView:_presentView];
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 35, (kScreenWidth-40-20-20), 40);
    loginBtn.backgroundColor = [UIColor orangeColor];
    loginBtn.layer.cornerRadius = 7.0f;
    [loginBtn setTitle:@"男" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.layer.borderWidth=0.5;
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [loginBtn addTarget:self action:@selector(getBoy) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *girlBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    girlBtn.frame = CGRectMake(20, 35+40+20, (kScreenWidth-40-20-20), 40);
    girlBtn.backgroundColor = [UIColor orangeColor];
    girlBtn.layer.cornerRadius = 7.0f;
    [girlBtn setTitle:@"女" forState:UIControlStateNormal];
    girlBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    girlBtn.layer.borderWidth=0.5;
    girlBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [girlBtn addTarget:self action:@selector(getGirl) forControlEvents:UIControlEventTouchUpInside];
    
    
    _presentView.contentSubviews = @[loginBtn,girlBtn];

    
}
//选择男孩
-(void)getBoy{
    [self changeSex:@"0"];
}
//选择美女孩
-(void)getGirl{
    [self changeSex:@"1"];
}
-(void)changeSex:(NSString*)boyOrGirl
{

    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setSex&token=%@&m_code=%@&m_sex=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),MBNonEmptyStringNo_(boyOrGirl)];
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
        if ([MBNonEmptyStringNo_(dic[@"state"])isEqualToString:@"0"]) {
            [_presentView removeFromSuperview];
            [self getUserInfo];
        }
        if ([MBNonEmptyStringNo_(dic[@"err-code"])isEqualToString:@"x002"]) {
            MBAlert(@"性别不能未空");
        }

        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];

}
@end
