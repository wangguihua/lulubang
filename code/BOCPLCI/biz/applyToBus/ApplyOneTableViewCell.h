//
//  ApplyOneTableViewCell.h
//  BOCPLCI
//
//  Created by wang on 14-9-25.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyOneTableViewCell : UITableViewCell
{
    UIImageView *_selectOne;
    UILabel *_itemNamel;
    UIButton *_showBtn;
    UILabel *_delegatLabel;
}
@property(nonatomic,assign)id delegateAbout;
- (void)showItemName:(NSString*)itemName isSelect:(BOOL)isSele AndDetailStr:(NSString*)detailStr;
@end

