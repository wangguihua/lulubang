//
//  UserFeedbackViewController.m
//  BOCPLCI
//
//  Created by bobo on 14-10-19.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserFeedbackViewController.h"
#import "MBTextView.h"
#import "HttpWorkHelp.h"

@interface UserFeedbackViewController ()
{
    MBTextView *_textView;
}
@end

@implementation UserFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    
    _textView = [[MBTextView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 130)];
    _textView.placeholder = @"请输入反馈信息内容";
    _textView.layer.borderWidth  = 0.5f;
    _textView.layer.cornerRadius  = 7.0f;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_textView];
    
    UIButton *comitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comitBtn.frame = CGRectMake(10, _textView.frame.origin.y + _textView.frame.size.height +15, kScreenWidth-20, 40);
    comitBtn.backgroundColor = [UIColor orangeColor];
    comitBtn.layer.cornerRadius = 7.0f;
    comitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    comitBtn.layer.borderWidth=0.5;
    comitBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [comitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [comitBtn addTarget:self action:@selector(comitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:comitBtn];
    
}

//登录
-(void)comitBtnAction
{
    
    [_textView resignFirstResponder];
    
    if ([MBNonEmptyStringNo_(_textView.text) isEqualToString:@""]) {
        MBAlert(@"意见反馈不能为空!");
        return;
    }
    
    NSDictionary *userInfo  = [[NSUserDefaults standardUserDefaults]valueForKey:TOOKNANDCODEINFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@?c=app&a=addFeedback&token=%@&m_code=%@&m_feedback=%@",ROOTURLSTR,MBNonEmptyStringNo_(userInfo[@"m_token"]),MBNonEmptyStringNo_(userInfo[@"m_code"]),MBNonEmptyStringNo_(_textView.text)];
    
    NSLog(@"urlStr -- %@",urlStr);
    
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodedString);
    
    [[HttpWorkHelp ShareData]httpGet:^(NSDictionary *dic) {
        
        if (MBNonEmptyStringNo_(dic[@"x002"])) {
            MBAlert(@"反馈信息今日已提交，不能重复提交！");
        }
        
        
    } andUrlName:encodedString andHTTPType:@"GET" withDic:nil andFailCallBack:^(NSDictionary *dic) {
        MBAlert(@"服务器繁忙，请稍后再试试");
    }];
    
    
    
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
