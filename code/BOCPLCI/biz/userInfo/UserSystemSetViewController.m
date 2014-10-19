//
//  UserSystemSetViewController.m
//  BOCPLCI
//
//  Created by bobo on 14-10-19.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserSystemSetViewController.h"
#import "UserSystemSetCell.h"
#import "ZSYPopoverListView.h"
#import "UserFeedbackViewController.h"
#import "HttpWorkHelp.h"

@interface UserSystemSetViewController ()

@end

@implementation UserSystemSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统设置";
    _rowCount = 6;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sysSetRangeNoti:) name:@"sysSetRange" object:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_rowCount == 6) {
            _nameArr = @[@"分享位置",@"接受消息",@"接受消息范围",@"语音播报",@"声音提醒",@"震动提醒"];
        }
        
        if (_rowCount == 5) {
            _nameArr = @[@"分享位置",@"接受消息",@"语音播报",@"声音提醒",@"震动提醒"];
        }
        
        return _rowCount;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInde = @"cellInde";
    UserSystemSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInde];
    if (cell == nil) {
        cell = [[UserSystemSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (indexPath.section==0) {
        
        cell.itemUimage.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.itemNameLabel.text = _nameArr[indexPath.row];
        
        if (indexPath.row==0) {
            
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_up.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            
            NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"分享位置"];
            if ([type isEqualToString:@"on"]) {
                cell.switchBtn.selected = YES;
            }else{
                cell.switchBtn.selected = NO;
            }
            
            cell.switchType = ^(NSString *on){
                
                if ([on isEqualToString:@"on"]) {
                    [self systemLocShare:@"0" indexPach:indexPath];
                }
                if ([on isEqualToString:@"off"]) {
                    [self systemLocShare:@"1" indexPach:indexPath];
                }

            };
            
        }else if (indexPath.row==1) {
            
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_mid_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            
            NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"接受消息"];
            if ([type isEqualToString:@"on"]) {
                cell.switchBtn.selected = YES;
            }else{
                cell.switchBtn.selected = NO;
            }
            
            cell.switchType = ^(NSString *on){
                if ([on isEqualToString:@"on"]) {
                    [self systemReceiveInfo:@"0" indexPach:indexPath];
                    _rowCount = 6;

                }else if([on isEqualToString:@"off"]){
                    [self systemReceiveInfo:@"1" indexPach:indexPath];
                    _rowCount = 5;
                }
            };

        }else if (indexPath.row==2) {
            
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_mid_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            
            if (_rowCount == 5) {
                cell.switchBtn.hidden = NO;
                _rangeLabel.hidden = YES;
                _downimage.hidden = YES;
                cell.switchBtn.enabled = NO;
            }
            
            if (_rowCount == 6) {
                cell.switchBtn.hidden = YES;
                _rangeLabel.hidden = NO;
                _downimage.hidden = NO;
                cell.switchBtn.enabled = YES;

                if (_rangeLabel) {
                    [_rangeLabel removeFromSuperview];
                }
                _rangeLabel =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-111, 5, 70, 30)];
                _rangeLabel.font = [UIFont boldSystemFontOfSize:16];
                _rangeLabel.backgroundColor =[UIColor clearColor];
                _rangeLabel.textAlignment = NSTextAlignmentRight;
                _rangeLabel.text = @"5000米";
                [cell.contentView addSubview:_rangeLabel];
                
                if (_downimage) {
                    [_downimage removeFromSuperview];
                }
                _downimage =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40, 12, 20, 12)];
                _downimage.backgroundColor = [UIColor clearColor];
                _downimage.image = [UIImage imageNamed:@"tag_bottom.png"];
                [cell.contentView addSubview:_downimage];
            }
        
        }else if (indexPath.row==3) {
            
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_mid_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            
            NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"接受消息"];
            if ([type isEqualToString:@"on"]) {
                cell.switchBtn.enabled = YES;
            }else{
                cell.switchBtn.enabled = NO;
            }
            
            NSString *types = [[NSUserDefaults standardUserDefaults] valueForKey:@"语音播报"];
            if ([types isEqualToString:@"on"]) {
                cell.switchBtn.selected = YES;
            }else{
                cell.switchBtn.selected = NO;
            }
            
            cell.switchType = ^(NSString *on){
                
                if ([on isEqualToString:@"on"]) {
                    [self systemVoiceBroadcast:@"0" indexPach:indexPath];
                }
                
                if ([on isEqualToString:@"off"]) {
                    [self systemVoiceBroadcast:@"1" indexPach:indexPath];
                    
                }
                
            };
            

        }else if (indexPath.row==4) {
            
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_mid_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];

            
            if (_rowCount == 5) {
                cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_down_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];

            }
            
            NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"接受消息"];
            if ([type isEqualToString:@"on"]) {
                cell.switchBtn.enabled = YES;
            }else{
                cell.switchBtn.enabled = NO;
            }
            
            NSString *types = [[NSUserDefaults standardUserDefaults] valueForKey:@"声音提醒"];
            if ([types isEqualToString:@"on"]) {
                cell.switchBtn.selected = YES;
            }else{
                cell.switchBtn.selected = NO;
            }

            cell.switchType = ^(NSString *on){
                
                if ([on isEqualToString:@"on"]) {
                    [self systemSoundReminder:@"0" indexPach:indexPath];
                }
                
                if ([on isEqualToString:@"off"]) {
                    [self systemSoundReminder:@"1" indexPach:indexPath];
                }
                
            };


        }else{
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_down_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            if (_rowCount == 6) {
                cell.itemNameLabel.frame = CGRectMake(15, 5, kScreenWidth-220, 30);
                cell.switchBtn.hidden = NO;
            }
            
            NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"接受消息"];
            if ([type isEqualToString:@"on"]) {
                cell.switchBtn.enabled = YES;
            }else{
                cell.switchBtn.enabled = NO;
            }
            
            NSString *types = [[NSUserDefaults standardUserDefaults] valueForKey:@"震动提醒"];
            if ([types isEqualToString:@"on"]) {
                cell.switchBtn.selected = YES;
            }else{
                cell.switchBtn.selected = NO;
            }
            
            cell.switchType = ^(NSString *on){
                
                if ([on isEqualToString:@"on"]) {
                    [self systemShakingReminder:@"0" indexPach:indexPath];
                }
                
                if ([on isEqualToString:@"off"]) {
                    [self systemShakingReminder:@"1" indexPach:indexPath];
                    
                }
                
            };

            
        }
        
    }
    
    if (indexPath.section==1) {
        
        cell.switchBtn.hidden = YES;
        cell.rightImageView.hidden = NO;
        cell.itemUimage.hidden = NO;
        
        if (indexPath.row==0) {
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_up.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            
            cell.itemUimage.image = [UIImage imageNamed:@"feedback_tag.png"];
            cell.itemNameLabel.frame = CGRectMake(40, 3, kScreenWidth-220, 30);
            cell.itemNameLabel.text = @"建议与反馈";
            
        }else{
            cell.bgImageView.image =[[UIImage imageNamed:@"bg_list_down_normal.9.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:40];
            
            cell.itemUimage.image = [UIImage imageNamed:@"setting_tag.png"];
            cell.itemNameLabel.frame = CGRectMake(40, 3, kScreenWidth-220, 30);
            cell.itemNameLabel.text = @"版本检测";
            

        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&
        indexPath.row == 2 &&
        _rowCount == 6) {
        
        ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 250, 270)];
        [listView show];

    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        UserFeedbackViewController *feedbackViewController = [[UserFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
    }
    
    
}

- (void)sysSetRangeNoti:(NSNotification *)noti
{
    _rangeLabel.text = noti.object;
    
#warning 此处需要修改
    [self systemReceiveRange:0 indexPach:nil];
}

#pragma mark - http
//分享位置
- (void)systemLocShare:(NSString *)type indexPach:(NSIndexPath *)indexPach
{
    
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setSystem&token=%@&m_code=%@&m_loc_share=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),type];
    
    NSLog(@"urlStr -- %@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        UserSystemSetCell *cell = (UserSystemSetCell *)[_tableView cellForRowAtIndexPath:indexPach];
        if ([type isEqualToString:@"0"]) {
            cell.switchBtn.selected = YES;
            [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:@"分享位置"];
        }
        
        if ([type isEqualToString:@"1"]) {
            cell.switchBtn.selected = NO;
            [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:@"分享位置"];
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
}

//接受消息
- (void)systemReceiveInfo:(NSString *)type indexPach:(NSIndexPath *)indexPach
{
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setSystem&token=%@&m_code=%@&m_receive_info=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),type];
    
    NSLog(@"urlStr -- %@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        UserSystemSetCell *cell = (UserSystemSetCell *)[_tableView cellForRowAtIndexPath:indexPach];
        if ([type isEqualToString:@"0"]) {
            cell.switchBtn.selected = YES;
            [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:@"接受消息"];
            [_tableView reloadData];
            
        }
        
        if ([type isEqualToString:@"1"]) {
            cell.switchBtn.selected = NO;
            [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:@"接受消息"];
            [_tableView reloadData];
            
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];

}

//接受消息范围
- (void)systemReceiveRange:(NSString *)type indexPach:(NSIndexPath *)indexPach
{
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setSystem&token=%@&m_code=%@&m_receive_range=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),type];
    
    NSLog(@"urlStr -- %@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
//        UserSystemSetCell *cell = (UserSystemSetCell *)[_tableView cellForRowAtIndexPath:indexPach];
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
}

//语音播报
- (void)systemVoiceBroadcast:(NSString *)type indexPach:(NSIndexPath *)indexPach
{
    
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setSystem&token=%@&m_code=%@&m_loc_share=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),type];
    
    NSLog(@"urlStr -- %@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        UserSystemSetCell *cell = (UserSystemSetCell *)[_tableView cellForRowAtIndexPath:indexPach];
        if ([type isEqualToString:@"0"]) {
            cell.switchBtn.selected = YES;
            [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:@"语音播报"];
        }
        
        if ([type isEqualToString:@"1"]) {
            cell.switchBtn.selected = NO;
            [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:@"语音播报"];
        }
        
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
}

//声音提醒
- (void)systemSoundReminder:(NSString *)type indexPach:(NSIndexPath *)indexPach
{
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setSystem&token=%@&m_code=%@&m_sound_reminder=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),type];
    
    NSLog(@"urlStr -- %@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        UserSystemSetCell *cell = (UserSystemSetCell *)[_tableView cellForRowAtIndexPath:indexPach];
        if ([type isEqualToString:@"0"]) {
            cell.switchBtn.selected = YES;
            [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:@"声音提醒"];
        }
        
        if ([type isEqualToString:@"1"]) {
            cell.switchBtn.selected = NO;
            [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:@"声音提醒"];
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
}

//震动提醒
- (void)systemShakingReminder:(NSString *)type indexPach:(NSIndexPath *)indexPach
{
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=setSystem&token=%@&m_code=%@&m_shaking_reminder=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),type];
    
    NSLog(@"urlStr -- %@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        UserSystemSetCell *cell = (UserSystemSetCell *)[_tableView cellForRowAtIndexPath:indexPach];
        if ([type isEqualToString:@"0"]) {
            cell.switchBtn.selected = YES;
            [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:@"震动提醒"];
        }
        
        if ([type isEqualToString:@"1"]) {
            cell.switchBtn.selected = NO;
            [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:@"震动提醒"];
        }
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
