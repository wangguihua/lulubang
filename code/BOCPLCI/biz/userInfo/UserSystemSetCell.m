//
//  UserSystemSetCell.m
//  BOCPLCI
//
//  Created by bobo on 14-10-19.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserSystemSetCell.h"

@implementation UserSystemSetCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _bgImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_bgImageView];
        self.backgroundColor =[UIColor clearColor];
        
        _itemUimage =[[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 20, 20)];
        _itemUimage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_itemUimage];
        
        _itemNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth-220, 30)];
        _itemNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemNameLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_itemNameLabel];
        
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchBtn.frame = CGRectMake(self.frame.size.width-80, 7.5, 60, 25);
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"tag_setting_no.png"] forState:UIControlStateNormal];
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"tag_setting_yes"] forState:UIControlStateSelected];
        [_switchBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_switchBtn];

        _rightImageView =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-30, 8, 12, 20)];
        _rightImageView.backgroundColor = [UIColor clearColor];
        _rightImageView.image =[UIImage imageNamed:@"tag_right.png"];
        _rightImageView.hidden = YES;
        [self.contentView addSubview:_rightImageView];

    }
    
    return self;
}

- (void)switchBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (_switchType) {
            _switchType(@"on");
        }
    }else {
        if (_switchType) {
            _switchType(@"off");
        }
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
