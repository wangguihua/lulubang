//
//  ApplyToOneViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-25.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "ApplyToOneViewController.h"
#import "ApplyOneTableViewCell.h"
#import "AppUploadIDCardViewController.h"
#import "AppUploadCarCardViewController.h"
#import "AppUploadCarStyleCardViewController.h"
#import "AppUploadOperationViewController.h"
@interface ApplyToOneViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_itemArray;
    NSArray *_detailArray;
}
@end

@implementation ApplyToOneViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initWithAllItemsValue{
    
    UITableView *tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentViewHeight+49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor =[UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr  = @"ApplyOneTableViewCell";
    ApplyOneTableViewCell *cell =(ApplyOneTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[ApplyOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell showItemName:_itemArray[indexPath.row] isSelect:YES AndDetailStr:_detailArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _itemArray = @[@"身份认证",@"驾照认证",@"车型认证",@"公司信息认证"];
    _detailArray = @[@"用于提升账号的安全性和信任级别。认证后的有卖家记录的账号不能修改认证信息。",@"用于提升账号的安全性和信任级别。认证后的有卖家记录的账号不能修改认证信息。",@"用于提升账号的安全性和信任级别。认证后的有卖家记录的账号不能修改认证信息。",@"用于提升账号的安全性和信任级别。认证后的有卖家记录的账号不能修改认证信息。"];
    self.title = @"认证商家申请";
    [self initWithAllItemsValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        AppUploadIDCardViewController *IDCard = [[AppUploadIDCardViewController alloc]init];
        [self.navigationController pushViewController:IDCard animated:YES];
    }
    if (indexPath.row==1) {
        AppUploadCarCardViewController *IDCard = [[AppUploadCarCardViewController alloc]init];
        [self.navigationController pushViewController:IDCard animated:YES];
    }
    if (indexPath.row==2) {
        AppUploadCarStyleCardViewController *IDCard = [[AppUploadCarStyleCardViewController alloc]init];
        [self.navigationController pushViewController:IDCard animated:YES];
    }
    if (indexPath.row==3) {
        AppUploadOperationViewController *IDCard = [[AppUploadOperationViewController alloc]init];
        [self.navigationController pushViewController:IDCard animated:YES];
    }

}

@end
