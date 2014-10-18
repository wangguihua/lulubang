//
//  PLViewController.m
//  BOCPLCI
//
//  Created by Ivan Li on 13-10-24.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "PLBaseViewController.h"
#import "MBAdditions.h"
@interface PLBaseViewController ()
{
    BOOL                _isScrollUp;
    BOOL                _isAlertViewShowing;
}

@end

@implementation PLBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }else if (MBOSVersion() < 5.0){
        self.navigationController.navigationBar.tintColor = HEX(@"#c20b0d");
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.multipleTouchEnabled = NO;
    self.view.exclusiveTouch = YES;
    
    //输入框自动上移
    _contentView = [[MBBaseScrollView alloc] init];
    _contentView.frame = [self contentRect];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:nil];
    
    
}

#pragma mark -
- (CGRect)contentRect{
    CGFloat contentHeight = kScreenHeight - kStatusBarHeight;
    if (self.tabBarController) {
        contentHeight -= kTabBarHeight;
    }
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        contentHeight -= kNavigationBarHeight;
        
        return CGRECT_HAVE_NAV(0, 0, kScreenWidth, contentHeight);
    }
    return CGRECT_NO_NAV(0, 0, kScreenWidth, contentHeight);
}

- (void)setContentView:(MBBaseScrollView *)contentView{
    [_contentView removeFromSuperview];
    _contentView = contentView;
    _contentView.frame = [self contentRect];
    [self.view insertSubview:_contentView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_selectViewWillShow)
                                                 name:MBSelectViewWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_selectViewWillHide)
                                                 name:MBSelectViewWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_alertViewDidShow)
                                                 name:MBAlertViewDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_alertViewDidHide)
                                                 name:MBAlertViewDidHideNotification
                                               object:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view.window endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBSelectViewWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBSelectViewWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBAlertViewDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBAlertViewDidHideNotification
                                                  object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIKeyboard Manage
- (void)_keyboardWillShow{
    [self scrollUp];
}

- (void)_keyboardWillHide{
    [self scrollBack];
}

- (void)_selectViewWillShow{
    [self scrollUp];
}

- (void)_selectViewWillHide{
    if (_isScrollUp) {
        [_contentView contentSizeToFit];
        _isScrollUp = NO;
    }
    [_contentView scrollToTopAnimated:NO];
}

- (void)scrollUp{
    UIView *responder = [self.view.window findFirstResponder];
    if (!_isScrollUp) {
        _contentView.contentSize = CGSizeMake(kScreenWidth, self.contentView.contentSize.height + kInputViewHeight);
        _isScrollUp = YES;
    }
    CGRect rect = [self.contentView convertRect:responder.frame fromView:responder.superview];
    CGFloat distance = 0;
    if (MBIsPad()) {
        distance = rect.origin.y - 160 > 0 ? rect.origin.y - 160 : 0;
    } else {
        distance = rect.origin.y - 80 > 0 ? rect.origin.y - 80 : 0;
    }
    
    [self.contentView setContentOffset:CGPointMake(0, distance) animated:YES];
}

- (void)scrollBack{
    if (_isScrollUp) {
        [_contentView contentSizeToFit];
        _isScrollUp = NO;
    }
    [_contentView scrollToBottomAnimated:YES];
}


- (void)_alertViewDidShow{
    _isAlertViewShowing = YES;
}

- (void)_alertViewDidHide{
    _isAlertViewShowing = NO;
}

#pragma mark - 弹出/消失ModalViewController
- (void)modalPresent:(UIViewController *)controller
{
    if (MBOSVersion() > 5) {
        [self presentViewController:controller animated:YES completion:nil];
    }else
        [self presentModalViewController:controller animated:YES];
}

- (void)modalDismiss:(BOOL)animated
{
    if (MBOSVersion() > 5) {
        [self dismissViewControllerAnimated:animated completion:nil];
    }else
        [self dismissModalViewControllerAnimated:animated];
}




@end
