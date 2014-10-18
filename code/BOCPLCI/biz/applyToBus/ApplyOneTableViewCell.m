//
//  ApplyOneTableViewCell.m
//  BOCPLCI
//
//  Created by wang on 14-9-25.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "ApplyOneTableViewCell.h"

@implementation ApplyOneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization cod2
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 80)];
        imageView.layer.borderWidth  = 0.5f;
        imageView.layer.cornerRadius  = 7.0f;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:imageView];
        imageView.alpha=0.6;
        
        _selectOne =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        _selectOne.image =[UIImage imageNamed:@"steps_bg.png"];
        [imageView addSubview:_selectOne];
        
        _itemNamel  =[[UILabel alloc]initWithFrame:CGRectMake(35, 5, kScreenWidth-180, 30)];
        _itemNamel.backgroundColor =[UIColor clearColor];
        _itemNamel.font =kNormalTextFont;
        [imageView addSubview:_itemNamel];
        
        
        _delegatLabel  =[[UILabel alloc]initWithFrame:CGRectMake(10, 30, kScreenWidth-40, 50)];
        _delegatLabel.backgroundColor =[UIColor clearColor];
        _delegatLabel.font =[UIFont boldSystemFontOfSize:12];
        _delegatLabel.numberOfLines=2;
        _delegatLabel.textColor = [UIColor grayColor];
        [imageView addSubview:_delegatLabel];
        
        _showBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _showBtn.frame = CGRectMake(kScreenWidth-40-20-20-10, 10, 60, 30);
        _showBtn.backgroundColor = [UIColor orangeColor];
        _showBtn.layer.cornerRadius = 10.0f;
        [_showBtn setTitle:@"申请" forState:UIControlStateNormal];
        _showBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _showBtn.layer.borderWidth=0.5;
        _showBtn.layer.borderColor=[UIColor grayColor].CGColor;
        [imageView addSubview:_showBtn];
        

        
    }
    return self;
}

- (void)showItemName:(NSString*)itemName isSelect:(BOOL)isSele AndDetailStr:(NSString*)detailStr
{
    // Initialization code
    _itemNamel.text = itemName;
    _delegatLabel.text = detailStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
