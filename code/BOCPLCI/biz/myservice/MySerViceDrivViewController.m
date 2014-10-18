//
//  MySerViceDrivViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-26.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "MySerViceDrivViewController.h"
#import "MBTextField.h"
#import "MBSelectView.h"
@interface MySerViceDrivViewController ()
{
    MBTextField *_nameTF;
    MBTextField *_priceTF;
    MBTextField *_qunHaoTF;
    MBSelectView *_timeFrom;
    MBSelectView *_timeTo;
 
    MBSelectView *_addFromBtn;
    MBSelectView *_addToBtn;
    MBTextField *_sayDetail;



}
@end

@implementation MySerViceDrivViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//完成修改
- (void)selectNameOver
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改代驾服务";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectNameOver)];
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 40)];
    imageView.layer.borderWidth  = 0.5f;
    imageView.layer.cornerRadius  = 7.0f;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageView];
    imageView.alpha=0.6;
    imageView.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamel  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamel.backgroundColor =[UIColor clearColor];
    _itemNamel.font =kNormalTextFont;
    _itemNamel.text = @"服务名称: ";
    [imageView addSubview:_itemNamel];
    
    _nameTF = [[MBTextField alloc]initWithFrame:CGRectMake(70, 5, kScreenWidth-90-30, 30)];
    _nameTF.backgroundColor=[UIColor clearColor];
    _nameTF.borderStyle=UITextBorderStyleNone;
    [imageView addSubview:_nameTF];
    
    
    UIImageView *imageViewTwo =[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth-20, 112)];
    imageViewTwo.layer.borderWidth  = 0.5f;
    imageViewTwo.layer.cornerRadius  = 7.0f;
    imageViewTwo.backgroundColor = [UIColor whiteColor];
    imageViewTwo.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageViewTwo];
    imageViewTwo.alpha=0.6;
    imageViewTwo.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamelTwo  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelTwo.backgroundColor =[UIColor clearColor];
    _itemNamelTwo.font =kNormalTextFont;
    _itemNamelTwo.text = @"代驾价格: ";
    _itemNamelTwo.textColor = [UIColor grayColor];
    [imageViewTwo addSubview:_itemNamelTwo];
    
    _priceTF = [[MBTextField alloc]initWithFrame:CGRectMake(70, 5, kScreenWidth-90-30, 30)];
    _priceTF.backgroundColor=[UIColor clearColor];
    _priceTF.borderStyle=UITextBorderStyleNone;
    [imageViewTwo addSubview:_priceTF];
    
    UIImageView *sepeImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 36, kScreenWidth-20, 1)];
    sepeImage.backgroundColor = [UIColor grayColor];
    [imageViewTwo addSubview:sepeImage];
    sepeImage.alpha=0.6;
    
    
    UILabel*_delegatLabelTwo  =[[UILabel alloc]initWithFrame:CGRectMake(10, 30+5+3, 60, 30)];
    _delegatLabelTwo.backgroundColor =[UIColor clearColor];
    _delegatLabelTwo.font =[UIFont boldSystemFontOfSize:12];
    _delegatLabelTwo.numberOfLines=2;
    _delegatLabelTwo.textColor = [UIColor grayColor];
    _delegatLabelTwo.text = @"服务时间: ";
    [imageViewTwo addSubview:_delegatLabelTwo];
    
    _timeFrom  =[[MBSelectView alloc]initWithFrame:CGRectMake(60,30+7+3, 100, 30)];
    _timeFrom.backgroundColor =[UIColor clearColor];
    _timeFrom.selectType = MBDatePickerModeTime;
    [imageViewTwo addSubview:_timeFrom];
    
    
    UILabel*_delegatLabelTwoTo  =[[UILabel alloc]initWithFrame:CGRectMake(170, 30+5+3, 60, 30)];
    _delegatLabelTwoTo.backgroundColor =[UIColor clearColor];
    _delegatLabelTwoTo.font =[UIFont boldSystemFontOfSize:12];
    _delegatLabelTwoTo.numberOfLines=2;
    _delegatLabelTwoTo.textColor = [UIColor grayColor];
    _delegatLabelTwoTo.text = @"到";
    [imageViewTwo addSubview:_delegatLabelTwoTo];
    
    
    _timeTo  =[[MBSelectView alloc]initWithFrame:CGRectMake(200,30+7+3, 100, 30)];
    _timeTo.backgroundColor =[UIColor clearColor];
    _timeTo.selectType = MBDatePickerModeTime;
    [imageViewTwo addSubview:_timeTo];

    
    UILabel*_itemNamelThree  =[[UILabel alloc]initWithFrame:CGRectMake(10, 67+3+2, 180, 30)];
    _itemNamelThree.backgroundColor =[UIColor clearColor];
    _itemNamelThree.font =kNormalTextFont;
    _itemNamelThree.text = @"关联群号(信息发到群的每人): ";
    _itemNamelThree.textColor = [UIColor grayColor];
    [imageViewTwo addSubview:_itemNamelThree];
    
    _qunHaoTF = [[MBTextField alloc]initWithFrame:CGRectMake(175, 63+2+3, kScreenWidth-90-30-100, 30)];
    _qunHaoTF.backgroundColor=[UIColor clearColor];
    _qunHaoTF.borderStyle=UITextBorderStyleNone;
    [imageViewTwo addSubview:_qunHaoTF];
    
    UIImageView *sepeImagetwo =[[UIImageView alloc]initWithFrame:CGRectMake(0, 68+2, kScreenWidth-20, 1)];
    sepeImagetwo.backgroundColor = [UIColor grayColor];
    [imageViewTwo addSubview:sepeImagetwo];
    sepeImagetwo.alpha=0.6;
    
    
    
    UIImageView *imageViewThree =[[UIImageView alloc]initWithFrame:CGRectMake(10, 180, kScreenWidth-20, 112-39)];
    imageViewThree.layer.borderWidth  = 0.5f;
    imageViewThree.layer.cornerRadius  = 7.0f;
    imageViewThree.backgroundColor = [UIColor whiteColor];
    imageViewThree.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageViewThree];
    imageViewThree.alpha=0.6;
    imageViewThree.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamelTwo2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelTwo2.backgroundColor =[UIColor clearColor];
    _itemNamelTwo2.font =kNormalTextFont;
    _itemNamelTwo2.text = @"出发地址: ";
    _itemNamelTwo2.textColor = [UIColor grayColor];
    [imageViewThree addSubview:_itemNamelTwo2];

    
    _addFromBtn  =[[MBSelectView alloc]initWithFrame:CGRectMake(70, 8, kScreenWidth-90-30, 30)];
    _addFromBtn.backgroundColor =[UIColor clearColor];
    _addFromBtn.selectType = MBSelectTypeNormal;
    _addFromBtn.options = @[@"不限",@"上地"];
    [imageViewThree addSubview:_addFromBtn];

    UIImageView *sepeImageTho =[[UIImageView alloc]initWithFrame:CGRectMake(0, 36, kScreenWidth-20-20-5, 1)];
    sepeImageTho.backgroundColor = [UIColor grayColor];
    [imageViewThree addSubview:sepeImageTho];
    sepeImageTho.alpha=0.6;
    
    UIButton *changeAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    changeAdd.frame = CGRectMake(kScreenWidth-20-22, 22, 20, 20);
    [changeAdd setImage:[UIImage imageNamed:@"change_places.png"] forState:UIControlStateNormal];
    [imageViewThree addSubview:changeAdd];
    
    UILabel*_delegatLabelTwo2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 30+5+3, 60, 30)];
    _delegatLabelTwo2.backgroundColor =[UIColor clearColor];
    _delegatLabelTwo2.font =[UIFont boldSystemFontOfSize:12];
    _delegatLabelTwo2.numberOfLines=2;
    _delegatLabelTwo2.textColor = [UIColor grayColor];
    _delegatLabelTwo2.text = @"目的地址: ";
    [imageViewThree addSubview:_delegatLabelTwo2];
    
    _addToBtn  =[[MBSelectView alloc]initWithFrame:CGRectMake(70, 41, kScreenWidth-90-30, 30)];
    _addToBtn.backgroundColor =[UIColor clearColor];
    _addToBtn.selectType = MBSelectTypeNormal;
    _addToBtn.options = @[@"不限",@"上地"];
    [imageViewThree addSubview:_addToBtn];
    
    

    UIImageView *imageViewLast =[[UIImageView alloc]initWithFrame:CGRectMake(10, 264, kScreenWidth-20, 40)];
    imageViewLast.layer.borderWidth  = 0.5f;
    imageViewLast.layer.cornerRadius  = 7.0f;
    imageViewLast.backgroundColor = [UIColor whiteColor];
    imageViewLast.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageViewLast];
    imageViewLast.alpha=0.6;
    imageViewLast.userInteractionEnabled = YES;
    
    
    UILabel*_itemNamelLast  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelLast.backgroundColor =[UIColor clearColor];
    _itemNamelLast.font =kNormalTextFont;
    _itemNamelLast.text = @"补充说明: ";
    _itemNamelLast.textColor = [UIColor grayColor];
    [imageViewLast addSubview:_itemNamelLast];
    
    _sayDetail = [[MBTextField alloc]initWithFrame:CGRectMake(70, 5, kScreenWidth-90-30, 30)];
    _sayDetail.backgroundColor=[UIColor clearColor];
    _sayDetail.borderStyle=UITextBorderStyleNone;
    [imageViewLast addSubview:_sayDetail];

    
}



@end
