//
//  MyServiceTableViewCell.h
//  BOCPLCI
//
//  Created by wang on 14-9-26.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLabel.h"
@interface MyServiceDrivierTableViewCell : UITableViewCell
{
    MBLabel *_serViceLabel;
    UILabel *_priceOf;
    UILabel *_timeFrom;
    UILabel *_timeTo;
    UILabel *_fromAdd;
    UILabel *_toAdd;
    MBLabel *_detail;
}
@property(assign,nonatomic)id delegateAbout;
@end

@protocol MyServiceDriVierTableViewCellDelegate <NSObject>

-(void)driverCellAboutApplyToVIP:(MyServiceDrivierTableViewCell*)cell;
-(void)putAwayToCell:(MyServiceDrivierTableViewCell*)cell;


@end