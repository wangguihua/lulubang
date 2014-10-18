//
//  MBLabel.m
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-6.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBLabel.h"
#import "CMPopTipView.h"
#import "MBConstant.h"

#define MBLabelTipWillShowNotification @"MBLabelTipWillShowNotification"

@interface MBLabel ()<CMPopTipViewDelegate>
{
    CMPopTipView *_tipView;
    UITapGestureRecognizer *_tapGesturer;
    
    UILabel *_paoMDLabel;
    NSTimer *_paoMDTimer;//跑马灯
    
    BOOL hasMore;
}

@end

@implementation MBLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        _tapGesturer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullText)];
        [self addGestureRecognizer:_tapGesturer];
        
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setShowFullTextIfNeeded];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self setShowFullTextIfNeeded];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setShowFullTextIfNeeded];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    [super setNumberOfLines:numberOfLines];
    [self setShowFullTextIfNeeded];
}

-(void)setShowTipType:(MBLabelShowTipType)showTipType{
    _showTipType = showTipType;
    [self setShowFullTextIfNeeded];
}

#pragma mark - 判断是否显示完整
- (void)setShowFullTextIfNeeded{
    
    hasMore = NO;
    
    if (_paoMDLabel) {
        self.textColor = _paoMDLabel.textColor;
        [_paoMDLabel removeFromSuperview];
        _paoMDLabel = nil;
    }
    if (_paoMDTimer) {
        [_paoMDTimer invalidate];
    }
    
    NSInteger numberOfLines = self.numberOfLines;
    if (numberOfLines == 1) {
        float fullWidth = [self.text sizeWithFont:self.font].width;
        if (fullWidth > self.frame.size.width) {
            if (self.showTipType == MBLabelMovingView) {
                
                _paoMDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fullWidth, self.frame.size.height)];
                _paoMDLabel.text = self.text;
                _paoMDLabel.font = self.font;
                _paoMDLabel.textColor = self.textColor;
                _paoMDLabel.backgroundColor = [UIColor clearColor];
                _paoMDLabel.textAlignment = NSTextAlignmentLeft;
                [self addSubview:_paoMDLabel];
                
                self.textColor = [UIColor clearColor];
                
                _paoMDTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.5] interval:0.1 target:self selector:@selector(beginPaoMaDengAnimation) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_paoMDTimer forMode:NSRunLoopCommonModes];
                [_paoMDTimer fire];
            }else{
                hasMore = YES;
            }
        }
    }
    else{
        CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, self.frame.size.height * 2)];
        if (size.height > self.frame.size.height) {
            hasMore = YES;
        }
    }

}

#pragma mark - 气泡显示效果
- (void)showFullText{
    if (hasMore && self.showTipType == MBLabelPopTipView) {
        if (!_tipView) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MBLabelTipWillShowNotification
                                                          object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(hideTipIfNeeded)
                                                         name:MBLabelTipWillShowNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MBLabelTipWillShowNotification object:nil];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(hideTipIfNeeded)
                                                         name:MBUserDidLogoutNotification
                                                       object:nil];
            
            _tipView = [[CMPopTipView alloc] initWithMessage:self.text];
            _tipView.delegate = self;
            _tipView.animation = CMPopTipAnimationPop;
            _tipView.dismissTapAnywhere = YES;
            _tipView.backgroundColor = [UIColor darkGrayColor];
            [_tipView autoDismissAnimated:YES atTimeInterval:3.0];
            [_tipView presentPointingAtView:self inView:self.window animated:YES];
        } else {
            [_tipView dismissAnimated:YES];
            _tipView = nil;
        }

    }
}

- (void)hideTipIfNeeded{
    if (_tipView) {
        [_tipView dismissAnimated:YES];
        _tipView = nil;
    }
}

#pragma mark - 跑马灯动画效果
- (void)beginPaoMaDengAnimation
{
    if (abs(_paoMDLabel.frame.origin.x) < _paoMDLabel.frame.size.width) {
        _paoMDLabel.frame = CGRectOffset(_paoMDLabel.frame, -1, 0);
    }else{
        _paoMDLabel.frame = CGRectMake(self.frame.size.width, 0, _paoMDLabel.frame.size.width, _paoMDLabel.frame.size.height);
    }
}

#pragma mark CMPopTipView Delegate Method
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
    _tipView = nil;
}

- (void)dealloc{
    if (_paoMDLabel) {
        [_paoMDLabel removeFromSuperview];
        _paoMDLabel = nil;
    }
    if (_paoMDTimer) {
        [_paoMDTimer invalidate];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBLabelTipWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBUserDidLogoutNotification
                                                  object:nil];
}




@end
