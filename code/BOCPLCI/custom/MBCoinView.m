//
//  MBCoinView.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.

#import "MBCoinView.h"


@interface MBCoinView (){
    bool displayingPrimary;
}
@end

@implementation MBCoinView

@synthesize primaryView=_primaryView, secondaryView=_secondaryView, spinTime;

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        displayingPrimary = YES;
        spinTime = 1.0;
    }
    return self;
}

- (id) initWithPrimaryView: (UIView *) primaryView andSecondaryView: (UIView *) secondaryView inFrame: (CGRect) frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.primaryView = primaryView;
        self.secondaryView = secondaryView;
        
        displayingPrimary = YES;
        spinTime = 1.0;
    }
    return self;
}

- (void) setPrimaryView:(UIView *)primaryView{
    _primaryView = primaryView;
    
    _primaryView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self roundView: _primaryView];
    _primaryView.userInteractionEnabled = YES;
    [self addSubview: _primaryView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTouched:)];
    gesture.numberOfTapsRequired = 1;
    [_primaryView addGestureRecognizer:gesture];
    [self roundView:self];
}

- (void) setSecondaryView:(UIView *)secondaryView{
    _secondaryView = secondaryView;
    _secondaryView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self roundView: _secondaryView];
    _secondaryView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTouched:)];
    gesture.numberOfTapsRequired = 1;
    [_secondaryView addGestureRecognizer:gesture];
    [self roundView:self];
}

- (void) roundView: (UIView *) view{
    [view.layer setCornerRadius: (self.frame.size.height/2)];
    [view.layer setMasksToBounds:YES];
}

-(IBAction) flipTouched:(id)sender{
    [UIView transitionFromView:(displayingPrimary ? self.primaryView : self.secondaryView)
                        toView:(displayingPrimary ? self.secondaryView : self.primaryView)
                      duration: spinTime
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {                            
                            displayingPrimary = !displayingPrimary;
                        }
                    }
     ];
}

-(void)dealloc
{
    _primaryView    = nil;
    _secondaryView  = nil;
}

@end
