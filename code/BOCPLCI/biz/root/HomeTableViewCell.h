//
//  HomeTableViewCell.h
//  BOCPLCI
//
//  Created by wang on 14-9-21.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
{
    UIImageView *_itemImageView;
    UILabel *_itemNameLabel;
    UILabel *_detailNameLabel;
}
-(void)initHeadItemImageStr:(NSString *)imageStr andItemName:(NSString*)itemStr andLastDetailStr:(NSString*)detailStr;
@end
