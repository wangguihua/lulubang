//
//  UserSystemSetCell.h
//  BOCPLCI
//
//  Created by bobo on 14-10-19.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^switchState)(NSString *on);

@interface UserSystemSetCell : UITableViewCell

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *itemUimage;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) switchState switchType;
@property (nonatomic, strong) UIImageView *rightImageView;

@end
