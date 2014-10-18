//
//  MyServiceViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-26.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "MyServiceViewController.h"
#import "MyServiceDrivierTableViewCell.h"
#import "MyServiceKuaiDeTableViewCell.h"
#import "MyServicePinCheTableViewCell.h"
#import "MySerViceDrivViewController.h"
#import "MySerViceKuaiDiViewController.h"
#import "MySerVicePinCheViewController.h"
#import "MyServiceFabuViewController.h"
@interface MyServiceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *loginBtn;
    UIButton *fabuBtn;
    UIImageView *_btnSpeImageView;
    UITableView *_tableView;
    NSArray *_onSallArray;
    NSArray *_offSallArray;
    NSArray *_curShowArray;
}
@end

@implementation MyServiceViewController

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
    self.title = @"服务列表";
    UIBarButtonItem*settingBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(selectNameOver)];
    
    UIBarButtonItem*fabuBtnRigh = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(faBuButton)];
    self.navigationItem.rightBarButtonItems = @[settingBtn,fabuBtnRigh];
    
    _onSallArray = @[@"1",@"2",@"3"];
    _offSallArray = @[@"1",@"2"];
    _curShowArray = _onSallArray;
    [self initWithHeadVie];
    
}
//设置
-(void)selectNameOver{}
//发布
-(void)faBuButton{
    MyServiceFabuViewController *myFabu = [[MyServiceFabuViewController alloc]init];
    [self.navigationController pushViewController:myFabu animated:YES];
}

-(void)initWithHeadVie{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, kScreenWidth+20, 40)];
    imageView.image = [UIImage imageNamed:@"bg_tab_bar_normal2.9.png"];
    [self.contentView addSubview:imageView];
    
    
    loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, kScreenWidth/2, 40);
    loginBtn.backgroundColor = [UIColor clearColor];
    [loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"上架服务" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    fabuBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    fabuBtn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 40);
    fabuBtn.backgroundColor = [UIColor clearColor];
    [fabuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fabuBtn setTitle:@"下架服务" forState:UIControlStateNormal];
    fabuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:fabuBtn];
    [fabuBtn addTarget:self action:@selector(fabuBtnBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _btnSpeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth/2, 1)];
    _btnSpeImageView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_btnSpeImageView];
    
    
    _tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kContentViewHeight+9) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _curShowArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        
        static NSString *cellStr = @"MyServiceDrivierTableViewCell";
        MyServiceDrivierTableViewCell *cell = (MyServiceDrivierTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[MyServiceDrivierTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    if (indexPath.row==1) {
        static NSString *cellStr = @"MyServiceKuaiDeTableViewCell";
        MyServiceKuaiDeTableViewCell *cell = (MyServiceKuaiDeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[MyServiceKuaiDeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    if (indexPath.row==2) {
        static NSString *cellStr = @"MyServicePinCheTableViewCell";
        MyServicePinCheTableViewCell *cell = (MyServicePinCheTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[MyServicePinCheTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id curCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([curCell isKindOfClass:[MyServiceDrivierTableViewCell class]]) {
        //代驾
        MySerViceDrivViewController *driver = [[MySerViceDrivViewController alloc]init];
        [self.navigationController pushViewController:driver animated:YES];
    }
    if ([curCell isKindOfClass:[MyServicePinCheTableViewCell class]]) {
        //拼车
        MySerVicePinCheViewController*driver = [[MySerVicePinCheViewController alloc]init];
        [self.navigationController pushViewController:driver animated:YES];
    }
    if ([curCell isKindOfClass:[MyServiceKuaiDeTableViewCell class]]) {
        //快递
        MySerViceKuaiDiViewController *driver = [[MySerViceKuaiDiViewController alloc]init];
        [self.navigationController pushViewController:driver animated:YES];
    }
}
//上架服务
-(void)getCodeBtnPressed{
    
    [UIView animateWithDuration:0.15 animations:^{
        _btnSpeImageView.frame= CGRectMake(0, 39, kScreenWidth/2, 1);
    } completion:^(BOOL finished) {
        [loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [fabuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _curShowArray = _onSallArray;
        [_tableView reloadData];
        
    }];
   
    
}
//下载服务
-(void)fabuBtnBtnPressed{

    [UIView animateWithDuration:0.15 animations:^{
        _btnSpeImageView.frame= CGRectMake(kScreenWidth/2, 39, kScreenWidth/2, 1);
    } completion:^(BOOL finished) {
        [fabuBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _curShowArray = _offSallArray;
        [_tableView reloadData];
    }];
}
@end
