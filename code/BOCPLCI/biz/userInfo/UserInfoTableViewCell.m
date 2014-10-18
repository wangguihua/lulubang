//
//  UserInfoTableViewCell.m
//  BOCPLCI
//
//  Created by wang on 14-9-22.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 40)];
        imageView.layer.borderWidth  = 0.5f;
        imageView.layer.cornerRadius  = 7.0f;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:imageView];
        imageView.alpha=0.6;
        
        _itemUimage =[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 20, 20)];
        _itemUimage.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_itemUimage];
        
        
        _itemNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 15, kScreenWidth-100, 30)];
        _itemNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemNameLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_itemNameLabel];

        UIButton *oneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(0, 15, 100, 40);
        [oneBtn addTarget:self action:@selector(oneBtnPressedAbout) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:oneBtn];
        
        
        _itemTWONameLabel =[[UILabel alloc]initWithFrame:CGRectMake(50+150, 15, kScreenWidth-80-100, 30)];
        _itemTWONameLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemTWONameLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_itemTWONameLabel];
        
        UIButton *twoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        twoBtn.frame = CGRectMake(100, 15, 100, 40);
        [twoBtn addTarget:self action:@selector(twoBtnBtnPressedAbout) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:twoBtn];
        
        
        _rightImageView =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-30, 20, 12, 20)];
        _rightImageView.backgroundColor = [UIColor whiteColor];
        _rightImageView.image =[UIImage imageNamed:@"tag_right.png"];
        [self.contentView addSubview:_rightImageView];
        
        
        _showBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _showBtn.frame = CGRectMake(kScreenWidth-100, 20-2, 80, 25);
        _showBtn.backgroundColor = [UIColor orangeColor];
        _showBtn.layer.cornerRadius = 7.0f;
        [_showBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        _showBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _showBtn.layer.borderWidth=0.5;
        _showBtn.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:_showBtn];
        [_showBtn addTarget:self action:@selector(threeBtnBtnPressedAbout) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return self;
}
-(void)oneBtnPressedAbout{

    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(oneBtnPressed:)]) {
        [_delegateAbout oneBtnPressed:self];
    }
}

-(void)twoBtnBtnPressedAbout{
    
    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(twoBtnPressed:)]) {
        [_delegateAbout twoBtnPressed:self];
    }
}


-(void)threeBtnBtnPressedAbout{
    
    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(threeBtnPressed:)]) {
        [_delegateAbout threeBtnPressed:self];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)initWithItemImageName:(NSString*)imageStr itemNameLabel:(NSString*)itemName andTwoName:(NSString*)twoName andShowRightImage:(BOOL)isShow andShowRightBtn:(BOOL)showBtn andShowIndex:(int)showAbout
{
    _showIndex = showAbout;
    _itemUimage.image = [UIImage imageNamed:imageStr];
    _itemNameLabel.text = itemName;
    _itemTWONameLabel.text = twoName;
    _rightImageView.hidden = !isShow;
    _showBtn.hidden= !showBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
