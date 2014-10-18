//
//  MyServiceFabuViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-28.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "MyServiceFabuViewController.h"
#import "MySerViceFaBuKuaiDiViewController.h"
@interface MyServiceFabuViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyServiceFabuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"UITableViewCellAbout";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 40)];
        imageView.layer.borderWidth  = 0.5f;
        imageView.layer.cornerRadius  = 7.0f;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.borderColor=[UIColor grayColor].CGColor;
        [cell.contentView addSubview:imageView];
        imageView.alpha=0.6;
        
        UIImageView*_rightImageView =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-30, 10, 12, 20)];
        _rightImageView.backgroundColor = [UIColor clearColor];
        _rightImageView.image =[UIImage imageNamed:@"tag_right.png"];
        [cell.contentView addSubview:_rightImageView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSString *showText =@"";
    if (indexPath.row==0) {
        showText = @"拼车";
    }
    ;
    if (indexPath.row==1) {
        showText = @"快递";
    }
    ;
    if (indexPath.row==2) {
        showText = @"代驾";
    }
    cell.textLabel.text = showText;
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择服务类型";
    UITableView *tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentViewHeight+49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor =[UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        MySerViceFaBuKuaiDiViewController *kuaidiFaBu = [[MySerViceFaBuKuaiDiViewController alloc]init];
        [self.navigationController pushViewController:kuaidiFaBu animated:YES];
    }
}


@end
