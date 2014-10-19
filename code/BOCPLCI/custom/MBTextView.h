//
//  MBTextView.h
//  Demo
//
//  Created by llbt on 14-4-1.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAccessoryView.h"

@class MBTextView;
@protocol MBTextViewDelegate <NSObject>

- (void)textViewDidCancelEditing:(MBTextView *)textView;
- (void)textViewDidFinishEditing:(MBTextView *)textView;

@end

@interface MBTextView : UITextView<UITextViewDelegate>
{
    NSString *_lastText;
    UILabel *_label;
}
@property (nonatomic, weak) id<MBTextViewDelegate>textViewDelegate;
@property (nonatomic, strong) MBAccessoryView *accessoryView;
@property (nonatomic, strong) NSString *placeholder;

@end
