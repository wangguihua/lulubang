//
//  MBTextView.m
//  Demo
//
//  Created by llbt on 14-4-1.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "MBTextView.h"
#import "MBConstant.h"

@implementation MBTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _accessoryView = [[MBAccessoryView alloc] initWithDelegate:self];
        self.inputAccessoryView = _accessoryView;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 30)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = kTipTextColor;
        [self addSubview:_label];
        
        self.delegate = self;
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _label.text = placeholder;
}

- (void)accessoryViewDidPressedCancelButton:(MBAccessoryView *)view
{
    [self resignFirstResponder];
    if (_textViewDelegate && [_textViewDelegate respondsToSelector:@selector(textViewDidCancelEditing:)]) {
        [_textViewDelegate textViewDidCancelEditing:self];
    }
    
    if (_lastText.length == 0) {
        self.text = nil;
        _label.hidden = NO;
    }
    self.text = _lastText;
}

- (void)accessoryViewDidPressedDoneButton:(MBAccessoryView *)view
{
    [self resignFirstResponder];
    if (_textViewDelegate && [_textViewDelegate respondsToSelector:@selector(textViewDidFinishEditing:)]) {
        [_textViewDelegate textViewDidFinishEditing:self];
    }
    
    _lastText = self.text;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _label.hidden = NO;
    }else{
        _label.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
