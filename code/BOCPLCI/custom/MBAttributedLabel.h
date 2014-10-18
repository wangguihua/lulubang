//
//  MBAttributedLabel.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
// 自定义label，实现字体颜色大小样式可不一致
/**************************Example*************************************
 
 MBAttributedLabel *label = [[MBAttributedLabel alloc] initWithFrame:CGRectMake(20, 20, 250, 40)];
 label.text = @"一定要先给text赋值，然后再加属性";
 label.backgroundColor = [UIColor clearColor];
 [self.view addSubview:label];
 
 // 设置this为红色
 [label setColor:[UIColor redColor] fromIndex:0 length:4];
 
 // 设置is为黄色
 [label setColor:[UIColor blueColor] fromIndex:5 length:2];
 
 // 设置this字体为加粗16号字
 [label setFont:[UIFont boldSystemFontOfSize:17] fromIndex:0 length:4];
 
 // 给this加上下划线
 [label setStyle:kCTUnderlineStyleDouble fromIndex:0 length:4];

 **********************************************************************/

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface MBAttributedLabel : UILabel{
    NSMutableAttributedString          *_attString;
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;

@end
