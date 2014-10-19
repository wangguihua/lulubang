//
//  UserSystemSetViewController.h
//  BOCPLCI
//
//  Created by bobo on 14-10-19.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "PLBaseViewController.h"

@interface UserSystemSetViewController : PLBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_rangeLabel;
    UIImageView *_downimage;
    NSInteger _rowCount;
    NSArray *_nameArr;
}
@end
