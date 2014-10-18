//
//  UserInfoTableViewCell.h
//  BOCPLCI
//
//  Created by wang on 14-9-22.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell
{
    UIImageView*_itemUimage;
    UILabel *_itemNameLabel;
    UILabel *_itemTWONameLabel;
    UIImageView *_rightImageView;
    UIButton *_showBtn;
}
@property(nonatomic,assign)id delegateAbout;
@property(nonatomic,assign)int showIndex;
-(void)initWithItemImageName:(NSString*)imageStr itemNameLabel:(NSString*)itemName andTwoName:(NSString*)twoName andShowRightImage:(BOOL)isShow andShowRightBtn:(BOOL)showBtn andShowIndex:(int)showAbout;
@end


@protocol UserInfoTableViewCellDelegate <NSObject>

-(void)oneBtnPressed:(UserInfoTableViewCell*)one;
-(void)twoBtnPressed:(UserInfoTableViewCell*)two;
-(void)threeBtnPressed:(UserInfoTableViewCell*)three;

@end