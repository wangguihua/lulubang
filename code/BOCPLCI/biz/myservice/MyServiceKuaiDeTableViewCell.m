//
//  MyServiceTableViewCell.m
//  BOCPLCI
//
//  Created by wang on 14-9-26.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "MyServiceKuaiDeTableViewCell.h"

@implementation MyServiceKuaiDeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 225)];
        imageView.layer.borderWidth  = 0.5f;
        imageView.layer.cornerRadius  = 7.0f;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:imageView];
        imageView.alpha=0.6;
        
        UIButton*_showBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _showBtn.frame = CGRectMake(15, 5, 40, 30-5);
        _showBtn.backgroundColor = [UIColor orangeColor];
        _showBtn.layer.cornerRadius = 10.0f;
        [_showBtn setTitle:@"快递" forState:UIControlStateNormal];
        _showBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _showBtn.layer.borderWidth=0.5;
        _showBtn.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:_showBtn];
        
        _serViceLabel  =[[MBLabel alloc]initWithFrame:CGRectMake(40,5, kScreenWidth-180, 30)];
        _serViceLabel.backgroundColor =[UIColor clearColor];
        _serViceLabel.font =kNormalTextFont;
        [self.contentView addSubview:_serViceLabel];
        
        UIButton*vipApply =[UIButton buttonWithType:UIButtonTypeCustom];
        vipApply.frame = CGRectMake(kScreenWidth-180+35, 5, 60, 30-5);
        vipApply.backgroundColor = [UIColor orangeColor];
        vipApply.layer.cornerRadius = 10.0f;
        [vipApply setTitle:@"申请VIP" forState:UIControlStateNormal];
        vipApply.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        vipApply.layer.borderWidth=0.5;
        vipApply.layer.borderColor=[UIColor grayColor].CGColor;
        [vipApply addTarget:self action:@selector(vipAppleSele) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:vipApply];
        
        
        UIButton*offBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        offBtn.frame = CGRectMake(kScreenWidth-180+40+60, 5, 60, 30-5);
        offBtn.backgroundColor = [UIColor orangeColor];
        offBtn.layer.cornerRadius = 10.0f;
        [offBtn setTitle:@"发布" forState:UIControlStateNormal];
        offBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        offBtn.layer.borderWidth=0.5;
        offBtn.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:offBtn];
        [offBtn addTarget:self action:@selector(offBtnPressed) forControlEvents:UIControlEventTouchUpInside];

        UIImageView *sepect = [[UIImageView alloc]initWithFrame:CGRectMake(10, 31+5, kScreenWidth-20, 1)];
        sepect.backgroundColor =[UIColor grayColor];
        [self.contentView addSubview:sepect];
        

        
        UILabel*_delegatLabelTwo  =[[UILabel alloc]initWithFrame:CGRectMake(15, 60+5-30, 60, 30)];
        _delegatLabelTwo.backgroundColor =[UIColor clearColor];
        _delegatLabelTwo.font =[UIFont boldSystemFontOfSize:12];
        _delegatLabelTwo.numberOfLines=2;
        _delegatLabelTwo.textColor = [UIColor grayColor];
        _delegatLabelTwo.text = @"服务时间: ";
        [self.contentView addSubview:_delegatLabelTwo];
        
        _timeFrom  =[[MBLabel alloc]initWithFrame:CGRectMake(70,60+5-30, 80, 30)];
        _timeFrom.backgroundColor =[UIColor clearColor];
        _timeFrom.font =kNormalTextFont;
        [self.contentView addSubview:_timeFrom];
        
        
        UILabel*_delegatLabelTwoTo  =[[UILabel alloc]initWithFrame:CGRectMake(170, 60+5-30, 60, 30)];
        _delegatLabelTwoTo.backgroundColor =[UIColor clearColor];
        _delegatLabelTwoTo.font =[UIFont boldSystemFontOfSize:12];
        _delegatLabelTwoTo.numberOfLines=2;
        _delegatLabelTwoTo.textColor = [UIColor grayColor];
        _delegatLabelTwoTo.text = @"到";
        [self.contentView addSubview:_delegatLabelTwoTo];
        
        
        _timeTo  =[[MBLabel alloc]initWithFrame:CGRectMake(250,60+5-30, 90, 30)];
        _timeTo.backgroundColor =[UIColor clearColor];
        _timeTo.font =kNormalTextFont;
        [self.contentView addSubview:_timeTo];
        
        
        UILabel*_delegatLabelThree  =[[UILabel alloc]initWithFrame:CGRectMake(15, 90+5-30, 60, 30)];
        _delegatLabelThree.backgroundColor =[UIColor clearColor];
        _delegatLabelThree.font =[UIFont boldSystemFontOfSize:12];
        _delegatLabelThree.numberOfLines=2;
        _delegatLabelThree.textColor = [UIColor grayColor];
        _delegatLabelThree.text = @"出发地址: ";
        [self.contentView addSubview:_delegatLabelThree];
        
        _fromAdd  =[[MBLabel alloc]initWithFrame:CGRectMake(70,90+5-30, kScreenWidth-90, 30)];
        _fromAdd.backgroundColor =[UIColor clearColor];
        _fromAdd.font =kNormalTextFont;
        [self.contentView addSubview:_fromAdd];
        
        UILabel*_delegatLabelFour  =[[UILabel alloc]initWithFrame:CGRectMake(15, 120+5-30, 60, 30)];
        _delegatLabelFour.backgroundColor =[UIColor clearColor];
        _delegatLabelFour.font =[UIFont boldSystemFontOfSize:12];
        _delegatLabelFour.numberOfLines=2;
        _delegatLabelFour.textColor = [UIColor grayColor];
        _delegatLabelFour.text = @"目的地址: ";
        [self.contentView addSubview:_delegatLabelFour];
        
        _toAdd  =[[MBLabel alloc]initWithFrame:CGRectMake(70,120+5-30, kScreenWidth-90, 30)];
        _toAdd.backgroundColor =[UIColor clearColor];
        _toAdd.font =kNormalTextFont;
        [self.contentView addSubview:_toAdd];
        
        UIImageView *sepectTwo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 151+5-30, kScreenWidth-20, 1)];
        sepectTwo.backgroundColor =[UIColor grayColor];
        [self.contentView addSubview:sepectTwo];
        
        
        UILabel*_delegatLabelFive  =[[UILabel alloc]initWithFrame:CGRectMake(15, 150+5-30, 60, 30)];
        _delegatLabelFive.backgroundColor =[UIColor clearColor];
        _delegatLabelFive.font =[UIFont boldSystemFontOfSize:12];
        _delegatLabelFive.numberOfLines=2;
        _delegatLabelFive.textColor = [UIColor grayColor];
        _delegatLabelFive.text = @"补充说明: ";
        [self.contentView addSubview:_delegatLabelFive];
        
        _detail  =[[MBLabel alloc]initWithFrame:CGRectMake(70,180+5-30, kScreenWidth-90, 30)];
        _detail.backgroundColor =[UIColor clearColor];
        _detail.font =kNormalTextFont;
        [self.contentView addSubview:_detail];
        
        
    }
    return self;
}

- (void)offBtnPressed
{
    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(driverCellAboutApplyToVIPAboutKuaiDi:)]) {
        [_delegateAbout driverCellAboutApplyToVIPAboutKuaiDi:self];
    }
}
- (void)vipAppleSele
{
    if (_delegateAbout&&[_delegateAbout respondsToSelector:@selector(putAwayToCellAboutKuaiDi:)]) {
        [_delegateAbout putAwayToCellAboutKuaiDi:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
