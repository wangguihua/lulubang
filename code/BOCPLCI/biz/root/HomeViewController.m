//
//  HomeViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "UserLoginViewController.h"
#import "HomeTableViewCell.h"
#import "UserInfoViewController.h"
#import "AFHTTPClient.h"
#import "JSONKit.h"
#import "AFJSONUtilities.h"
#import "MBLoadingView.h"
#import "MBAlertView.h"
#import "PinCheViewController.h"
#import "KuaiDiViewController.h"
@interface HomeViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_fabuBtn;
    UIButton *_needBtn;
    UIPageControl *_pageCOntroller;
    NSTimer *_timer;
    NSInteger _showCurIndex;
    UIScrollView *_showScroView;
    
    NSArray *_itemImageNameArray;
    NSArray *_itemNameArray;
    NSArray *_detailNameArray;
}
@end

@implementation HomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//获取广告
-(void)getAdData{
    
    
    
    NSDictionary *sendInfo = @{
                               @"m_eara":MBNonEmptyStringNo_(@""),
                               };
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=getAdv",ROOTURLSTR];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __block MBLoadingView *loadingView =[[MBLoadingView alloc] init];
    [loadingView show];
    //userno=cp@weikucun.com 显示超市  密码：ppp123456
    AFHTTPClient *bClient = [AFHTTPClient clientWithBaseURL:
                             [NSURL URLWithString:encodedString]];
    [bClient postPath:nil parameters:sendInfo success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         [loadingView hide];
         NSError *error=nil;
         NSDictionary *resonseDic = AFJSONDecode(responseObject, &error);
         NSLog(@"%@",resonseDic);
         
         if ([resonseDic[@"status"] isEqualToString:@"200"]) {
             
             NSMutableArray *_dataArray = [NSMutableArray arrayWithCapacity:2];
             
             [ _dataArray addObjectsFromArray:resonseDic[@"data"][@"items"] ];
             NSLog(@"%@",resonseDic);
            
             
         }
     }
             failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [loadingView hide];
         
     }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _itemImageNameArray = @[@"icon_pinche.png",@"icon_yunhuo.png",@"icon_daijia.png",@"icon_publishs.png"];
    _itemNameArray = @[@"拼车 专车",@"快递 物流",@"代驾",@"参与服务"];
    _detailNameArray = @[@"出租车、私家车、客车.同城拼车、长途拼车、接送机场车站.",@"同城快递、跑腿代购、搬家搬运、全国快递、物流托运",@"酒后代驾、商务代驾、旅游代驾、司机外派",@"优质服务需要您的参与!诚招各地代理商!"];
    _showCurIndex = 0;
    // Do any additional setup after loading the view.
    [self initHottomBar];
    [self initWithAdView];
    [self initWithAllItemsValue];
    [self getAdData];
    
}
#pragma mark UITableView Delegate And UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellStr = @"HomeTableViewCell";
    HomeTableViewCell *cell = (HomeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    [cell initHeadItemImageStr:_itemImageNameArray[indexPath.row] andItemName:_itemNameArray[indexPath.row] andLastDetailStr:_detailNameArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        PinCheViewController *pinChe  = [[PinCheViewController alloc]init];
        [self.navigationController pushViewController:pinChe animated:YES];
    }
    if (indexPath.row==1) {
        KuaiDiViewController *kuaide  = [[KuaiDiViewController alloc]init];
        [self.navigationController pushViewController:kuaide animated:YES];
    }
}
-(void)initWithAllItemsValue{

    UITableView *tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kContentViewHeight-100) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.contentView addSubview:tableView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initHeadBtn];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageCOntroller.currentPage = scrollView.contentOffset.x/kScreenWidth;
}
//广告位
-(void)initWithAdView
{
    _showScroView  =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _showScroView.contentSize = CGSizeMake(kScreenWidth*5, 100);
    _showScroView.pagingEnabled = YES;
    _showScroView.delegate = self;
    [self.contentView addSubview:_showScroView];
    for (int i=0; i<5; i++) {
        UIImageView *imageView  =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 100)];
        imageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        [_showScroView addSubview:imageView];
    }
    _pageCOntroller = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth-100, 80, 100, 20)];
    _pageCOntroller.numberOfPages = 5;
    [self.contentView addSubview:_pageCOntroller];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(timerCountDown)
                                            userInfo:nil
                                             repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
-(void)timerCountDown
{
    
    if (_showCurIndex>=4) {
        _showCurIndex=0;
        [_showScroView scrollRectToVisible:CGRectMake(_showCurIndex*kScreenWidth, 0, kScreenWidth, 100) animated:NO];

    }else{
        _showCurIndex++;
        [_showScroView scrollRectToVisible:CGRectMake(_showCurIndex*kScreenWidth, 0, kScreenWidth, 100) animated:YES];

    }
}
-(void)initHeadBtn
{
    BOOL _userIsInOrOut = [[[NSUserDefaults standardUserDefaults]valueForKey:STATUEABOUTUSER]boolValue];
    if (_userIsInOrOut) {
        
        UIBarButtonItem *leftBtn  =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_account.png"] style:UIBarButtonItemStylePlain target:self action:@selector(seePelpleDetail)];
        self.navigationItem.leftBarButtonItem = leftBtn;
        
        UIBarButtonItem *rigthBtn  =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_msg.png"] style:UIBarButtonItemStylePlain target:self action:@selector(seeMessageDetail)];
        self.navigationItem.rightBarButtonItem = rigthBtn;
        
        
    } else {
        
        UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(userLongBtnPerssed)];
        self.navigationItem.leftBarButtonItem=leftBtn;
    }

}

//个人中心
-(void)seePelpleDetail{
    
    UserInfoViewController *userInfo  = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:userInfo animated:YES];
}
//查看信息
-(void)seeMessageDetail{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:STATUEABOUTUSER];

}
-(void)userLongBtnPerssed
{
    UserLoginViewController *user =[[UserLoginViewController alloc]init];
    [self.navigationController pushViewController:user animated:YES];
}
-(void)initHottomBar
{
    NSArray *itmeName = @[@"发布",@"需求"];
    NSArray *itemImageName = @[@"icon_home.png",@"icon_demand.png"];
    for (int i=0; i<itemImageName.count; i++) {
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2*i, kContentViewHeight+49-49, kScreenWidth/2, 49)];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        
        if (i==0) {
            _fabuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _fabuBtn.backgroundColor = [UIColor orangeColor];
            _fabuBtn.frame = CGRectMake(0, 0, kScreenWidth/2, 49);
            [view addSubview:_fabuBtn];
            [_fabuBtn addTarget:self action:@selector(fabuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==1) {
            _needBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _needBtn.backgroundColor = [UIColor orangeColor];
            _needBtn.alpha=0.5;
            _needBtn.frame = CGRectMake(0, 0, kScreenWidth/2, 49);
            [view addSubview:_needBtn];
            [_needBtn addTarget:self action:@selector(needBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        }

        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth/2-42)/2, 12, 21, 21)];
        imageView.image =[UIImage imageNamed:itemImageName[i]];
        [view addSubview:imageView];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth/2+22)/2, 3, 60, 42)];
        label.text = itmeName[i];
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        
    }
}
//发布
- (void)fabuBtnPressed
{
    _needBtn.alpha=0.5;
    _fabuBtn.alpha=1;

  
}

//需求
- (void)needBtnPressed
{
    _needBtn.alpha=1;
    _fabuBtn.alpha=0.5;
    
}



@end
