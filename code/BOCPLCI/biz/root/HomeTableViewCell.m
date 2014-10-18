//
//  HomeTableViewCell.m
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self.contentView addSubview:_itemImageView];
        
        _itemNameLabel  =[[UILabel alloc]initWithFrame:CGRectMake(80, 10, kScreenWidth-80, 30)];
        _itemNameLabel.backgroundColor =[UIColor clearColor];
        _itemNameLabel.font =kNormalTextFont;
        [self.contentView addSubview:_itemNameLabel];
        
        
        _detailNameLabel  =[[UILabel alloc]initWithFrame:CGRectMake(80, 30, kScreenWidth-80, 50)];
        _detailNameLabel.backgroundColor =[UIColor clearColor];
        _detailNameLabel.font =[UIFont boldSystemFontOfSize:12];
        _detailNameLabel.numberOfLines=2;
        _detailNameLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_detailNameLabel];
        
        
    }
    return self;
}
-(void)initHeadItemImageStr:(NSString *)imageStr andItemName:(NSString*)itemStr andLastDetailStr:(NSString*)detailStr{
    _itemImageView.image =[UIImage imageNamed:imageStr];
    _itemNameLabel.text = itemStr;
    _detailNameLabel.text = detailStr;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
