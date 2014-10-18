//
//  MBGuideViewController.m
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBGuideViewController.h"

@interface MBGuideViewController ()

@end

@implementation MBGuideViewController

@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (void)showGuide
{
	if (self.view.superview == nil)
	{
		[MBGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[[self mainWindow] addSubview:[MBGuideViewController sharedGuide].view];
	}
}

- (void)hideGuide
{
	if (self.view.superview != nil)
	{
        float gHeight = [MBGuideViewController sharedGuide].view.frame.size.height;
        [UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[MBGuideViewController sharedGuide].view.frame =
        CGRectOffset([MBGuideViewController sharedGuide].view.frame, 0, gHeight);
		[UIView commitAnimations];
	}
}


- (void)guideHidden
{
	[[[MBGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[MBGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[MBGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[MBGuideViewController sharedGuide] hideGuide];
}

#pragma mark -

+ (MBGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static MBGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.showsVerticalScrollIndicator = NO;
    self.pageScroll.contentSize = CGSizeMake(kScreenWidth * imageNameArray.count, kScreenHeight);
    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 175.f, 35.f)];
            [enterButton setTitle:@"开始使用" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [enterButton setCenter:CGPointMake(self.view.center.x, 417.f)];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor_guide"] forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_press_guide"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
