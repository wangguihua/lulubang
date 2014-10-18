//
//  MySerViceDrivViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-26.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "MySerViceFaBuKuaiDiViewController.h"
#import "MBTextField.h"
#import "MBSelectView.h"
@interface MySerViceFaBuKuaiDiViewController ()<UITextFieldDelegate>
{
    MBTextField *_nameTF;
    MBTextField *_qunHaoTF;
    MBSelectView *_timeFrom;
    MBSelectView *_timeTo;
    
    MBSelectView *_addFromBtn;
    MBSelectView *_addToBtn;
    MBTextField *_sayDetail;
    
    UIImageView *_imageViewTwo;
    UIImageView *_imageViewThree;
    UIImageView *_imageViewLast;
    UIView *_applyVIPView;
    CGFloat _applyVIPViewHeight;
    CGFloat _imageViewTwoHeight;
    CGFloat _imageViewThreeHeight;
    CGFloat _imageViewLastHeight;
    
    UIButton *_oneBtn;
    UIButton *_twoBtn;
    
    BOOL _isAuto;
}
@end

@implementation MySerViceFaBuKuaiDiViewController

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
    self.title = @"发布带货服务";
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
    
    
    
    UIImageView *imageViewAbout =[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth-20, 50)];
    imageViewAbout.layer.borderWidth  = 0.5f;
    imageViewAbout.layer.cornerRadius  = 7.0f;
    imageViewAbout.backgroundColor = [UIColor whiteColor];
    imageViewAbout.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageViewAbout];
    imageViewAbout.alpha=0.6;
    imageViewAbout.userInteractionEnabled = YES;
    
    UILabel*_itemNamelAbout1  =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    _itemNamelAbout1.backgroundColor =[UIColor clearColor];
    _itemNamelAbout1.font =kNormalTextFont;
    _itemNamelAbout1.text = @"带货价格: ";
    [imageViewAbout addSubview:_itemNamelAbout1];
    
    _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneBtn.frame = CGRectMake(75, 5, (kScreenWidth-100-10)/2, 40);
    _oneBtn.backgroundColor =[UIColor whiteColor];
    [_oneBtn setTitle:@"价格设置" forState:UIControlStateNormal];
    _oneBtn.layer.cornerRadius = 6.0f;
    _oneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _oneBtn.layer.borderWidth=0.5;
    [_oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _oneBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [_oneBtn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"]  forState:UIControlStateNormal];
    [imageViewAbout addSubview:_oneBtn];
    [_oneBtn addTarget:self action:@selector(oneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _twoBtn.frame = CGRectMake(80+(kScreenWidth-100-10)/2, 5, (kScreenWidth-100-10)/2, 40);
    [_twoBtn setTitle:@"议价" forState:UIControlStateNormal];
    _twoBtn.backgroundColor =[UIColor whiteColor];
    _twoBtn.layer.cornerRadius = 6.0f;
    _twoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _twoBtn.layer.borderWidth=0.5;
    [_twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _twoBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [_twoBtn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
    [imageViewAbout addSubview:_twoBtn];
    [_twoBtn addTarget:self action:@selector(twoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _imageViewTwo =[[UIImageView alloc]initWithFrame:CGRectMake(10, 120, kScreenWidth-20, 112-39)];
    _imageViewTwo.layer.borderWidth  = 0.5f;
    _imageViewTwo.layer.cornerRadius  = 7.0f;
    _imageViewTwo.backgroundColor = [UIColor whiteColor];
    _imageViewTwo.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_imageViewTwo];
    _imageViewTwo.alpha=0.6;
    _imageViewTwo.userInteractionEnabled = YES;
    _imageViewTwoHeight =120;
    
    UIImageView *sepeImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 36, kScreenWidth-20, 1)];
    sepeImage.backgroundColor = [UIColor grayColor];
    [_imageViewTwo addSubview:sepeImage];
    sepeImage.alpha=0.6;
    
    
    UILabel*_delegatLabelTwo  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5+3, 60, 30)];
    _delegatLabelTwo.backgroundColor =[UIColor clearColor];
    _delegatLabelTwo.font =[UIFont boldSystemFontOfSize:12];
    _delegatLabelTwo.numberOfLines=2;
    _delegatLabelTwo.textColor = [UIColor grayColor];
    _delegatLabelTwo.text = @"服务时间: ";
    [_imageViewTwo addSubview:_delegatLabelTwo];
    
    _timeFrom  =[[MBSelectView alloc]initWithFrame:CGRectMake(60,7+3, 100, 30)];
    _timeFrom.backgroundColor =[UIColor clearColor];
    _timeFrom.selectType = MBDatePickerModeTime;
    [_imageViewTwo addSubview:_timeFrom];
    
    
    UILabel*_delegatLabelTwoTo  =[[UILabel alloc]initWithFrame:CGRectMake(170, 5+3, 60, 30)];
    _delegatLabelTwoTo.backgroundColor =[UIColor clearColor];
    _delegatLabelTwoTo.font =[UIFont boldSystemFontOfSize:12];
    _delegatLabelTwoTo.numberOfLines=2;
    _delegatLabelTwoTo.textColor = [UIColor grayColor];
    _delegatLabelTwoTo.text = @"到";
    [_imageViewTwo addSubview:_delegatLabelTwoTo];
    
    
    _timeTo  =[[MBSelectView alloc]initWithFrame:CGRectMake(200,7+3, 100, 30)];
    _timeTo.backgroundColor =[UIColor clearColor];
    _timeTo.selectType = MBDatePickerModeTime;
    [_imageViewTwo addSubview:_timeTo];
    
    
    UILabel*_itemNamelThree  =[[UILabel alloc]initWithFrame:CGRectMake(10, 37+3+2, 180, 30)];
    _itemNamelThree.backgroundColor =[UIColor clearColor];
    _itemNamelThree.font =kNormalTextFont;
    _itemNamelThree.text = @"关联群号(信息发到群的每人): ";
    _itemNamelThree.textColor = [UIColor grayColor];
    [_imageViewTwo addSubview:_itemNamelThree];
    
    _qunHaoTF = [[MBTextField alloc]initWithFrame:CGRectMake(175, 33+2+3, kScreenWidth-90-30-100, 30)];
    _qunHaoTF.backgroundColor=[UIColor clearColor];
    _qunHaoTF.borderStyle=UITextBorderStyleNone;
    [_imageViewTwo addSubview:_qunHaoTF];
    
    
    
    
    
    _imageViewThree =[[UIImageView alloc]initWithFrame:CGRectMake(10, 180+40, kScreenWidth-20, 112-39)];
    _imageViewThree.layer.borderWidth  = 0.5f;
    _imageViewThree.layer.cornerRadius  = 7.0f;
    _imageViewThree.backgroundColor = [UIColor whiteColor];
    _imageViewThree.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_imageViewThree];
    _imageViewThree.alpha=0.6;
    _imageViewThree.userInteractionEnabled = YES;
    _imageViewThreeHeight =220;
    
    
    UILabel*_itemNamelTwo2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelTwo2.backgroundColor =[UIColor clearColor];
    _itemNamelTwo2.font =kNormalTextFont;
    _itemNamelTwo2.text = @"出发地址: ";
    _itemNamelTwo2.textColor = [UIColor grayColor];
    [_imageViewThree addSubview:_itemNamelTwo2];
    
    
    _addFromBtn  =[[MBSelectView alloc]initWithFrame:CGRectMake(70, 8, kScreenWidth-90-30, 30)];
    _addFromBtn.backgroundColor =[UIColor clearColor];
    _addFromBtn.selectType = MBSelectTypeNormal;
    _addFromBtn.options = @[@"不限",@"上地"];
    [_imageViewThree addSubview:_addFromBtn];
    
    UIImageView *sepeImageTho =[[UIImageView alloc]initWithFrame:CGRectMake(0, 36, kScreenWidth-20-20-5, 1)];
    sepeImageTho.backgroundColor = [UIColor grayColor];
    [_imageViewThree addSubview:sepeImageTho];
    sepeImageTho.alpha=0.6;
    
    UIButton *changeAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    changeAdd.frame = CGRectMake(kScreenWidth-20-22, 22, 20, 20);
    [changeAdd setImage:[UIImage imageNamed:@"change_places.png"] forState:UIControlStateNormal];
    [_imageViewThree addSubview:changeAdd];
    
    UILabel*_delegatLabelTwo2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 30+5+3, 60, 30)];
    _delegatLabelTwo2.backgroundColor =[UIColor clearColor];
    _delegatLabelTwo2.font =[UIFont boldSystemFontOfSize:12];
    _delegatLabelTwo2.numberOfLines=2;
    _delegatLabelTwo2.textColor = [UIColor grayColor];
    _delegatLabelTwo2.text = @"目的地址: ";
    [_imageViewThree addSubview:_delegatLabelTwo2];
    
    _addToBtn  =[[MBSelectView alloc]initWithFrame:CGRectMake(70, 41, kScreenWidth-90-30, 30)];
    _addToBtn.backgroundColor =[UIColor clearColor];
    _addToBtn.selectType = MBSelectTypeNormal;
    _addToBtn.options = @[@"不限",@"上地"];
    [_imageViewThree addSubview:_addToBtn];
    
    
    
    _imageViewLast =[[UIImageView alloc]initWithFrame:CGRectMake(10, 304, kScreenWidth-20, 40)];
    _imageViewLast.layer.borderWidth  = 0.5f;
    _imageViewLast.layer.cornerRadius  = 7.0f;
    _imageViewLast.backgroundColor = [UIColor whiteColor];
    _imageViewLast.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_imageViewLast];
    _imageViewLast.alpha=0.6;
    _imageViewLast.userInteractionEnabled = YES;
    _imageViewLastHeight =304;
    
    
    UILabel*_itemNamelLast  =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    _itemNamelLast.backgroundColor =[UIColor clearColor];
    _itemNamelLast.font =kNormalTextFont;
    _itemNamelLast.text = @"补充说明: ";
    _itemNamelLast.textColor = [UIColor grayColor];
    [_imageViewLast addSubview:_itemNamelLast];
    
    _sayDetail = [[MBTextField alloc]initWithFrame:CGRectMake(70, 5, kScreenWidth-90-30, 30)];
    _sayDetail.backgroundColor=[UIColor clearColor];
    _sayDetail.borderStyle=UITextBorderStyleNone;
    [_imageViewLast addSubview:_sayDetail];
    
    _applyVIPView = [[UIView alloc]initWithFrame:CGRectMake(0, 355, kScreenWidth, 40)];
    _applyVIPView.backgroundColor =[UIColor whiteColor];
    [self.contentView addSubview:_applyVIPView];
    _applyVIPViewHeight = _applyVIPView.frame.origin.y;
    
    
    NSString *showImage;
    _isAuto = NO;
    if (_isAuto) {
        showImage = @"tag_selected.png";
    } else {
        showImage = @"tag_not_selected.png";
        
        
    }
    
    UIButton*_autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _autoLoginBtn.frame = CGRectMake(20, 10, 20, 20);
    [_applyVIPView addSubview:_autoLoginBtn];
    [_autoLoginBtn setBackgroundImage:[UIImage imageNamed:showImage] forState:UIControlStateNormal];
    [_autoLoginBtn addTarget:self action:@selector(autoLoginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(45, 0, 160, 42)];
    label.text = @"申请VIP服务并同意";
    label.backgroundColor = [UIColor clearColor];
    [_applyVIPView addSubview:label];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    
    UIButton*forPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forPwdBtn.frame = CGRectMake(kScreenWidth-140, 0, 130, 42);
    [_applyVIPView addSubview:forPwdBtn];
    forPwdBtn.titleLabel.font= kNormalTextFont;
    [forPwdBtn setTitle:@"<<VIP服务协议>>" forState:UIControlStateNormal];
    [forPwdBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [forPwdBtn addTarget:self action:@selector(forpawdBtnPressed) forControlEvents:UIControlEventTouchUpInside];

    
    
}

//服务协议
-(void)forpawdBtnPressed{
}
//同意申请vip
- (void)autoLoginBtnPressed:(UIButton*)btn
{
    _isAuto = !_isAuto;
    NSString *showImage;
    if (_isAuto) {
        showImage = @"tag_selected.png";
    } else {
        showImage = @"tag_not_selected.png";
    }
    [btn setBackgroundImage:[UIImage imageNamed:showImage] forState:UIControlStateNormal];
    
}
//价格设置
-(void)oneBtnPressed{
    [_oneBtn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"]  forState:UIControlStateNormal];
    [_twoBtn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
    
    UIImageView *imageViewAbout = (UIImageView*)[self.contentView viewWithTag:1000];
    if (imageViewAbout==nil) {
        imageViewAbout =[[UIImageView alloc]initWithFrame:CGRectMake(10, 110, kScreenWidth-20, 220)];
        imageViewAbout.layer.borderWidth  = 0.5f;
        imageViewAbout.layer.cornerRadius  = 7.0f;
        imageViewAbout.backgroundColor = [UIColor whiteColor];
        imageViewAbout.layer.borderColor=[UIColor grayColor].CGColor;
        [self.contentView addSubview:imageViewAbout];
        imageViewAbout.alpha=0.6;
        imageViewAbout.userInteractionEnabled = YES;
        imageViewAbout.tag=1000;
        NSArray *Item = @[@"0-5千克",@"5-10千克",@"10-15千克",@"25-50千克",@"50-100千克",@"100千克以上"];
        for (int i=0; i<Item.count; i++) {
            CGSize size = [Item[i] sizeWithFont:kNormalTextFont constrainedToSize:CGSizeMake(10000, 30)];
            
            UILabel *itemAbout  = [[UILabel alloc]initWithFrame:CGRectMake(80, i*35+5, size.width, 30)];
            itemAbout.font = kNormalTextFont;
            itemAbout.backgroundColor =[UIColor clearColor];
            itemAbout.font =[UIFont boldSystemFontOfSize:12];
            itemAbout.text=Item[i];
            itemAbout.textColor = [UIColor blackColor];
            [imageViewAbout addSubview:itemAbout];
            
            MBTextField*itemTF = [[MBTextField alloc]initWithFrame:CGRectMake(itemAbout.frame.origin.x+size.width+5, i*35+5, 100, 30)];
            itemTF.backgroundColor=[UIColor clearColor];
            itemTF.borderStyle=UITextBorderStyleRoundedRect;
            [imageViewAbout addSubview:itemTF];
            itemTF.delegate = self;
            
            UILabel *itemAboutLast  = [[UILabel alloc]initWithFrame:CGRectMake(itemTF.frame.origin.x+itemTF.frame.size.width, i*35+5, size.width, 30)];
            itemAboutLast.font = kNormalTextFont;
            itemAboutLast.backgroundColor =[UIColor clearColor];
            itemAboutLast.font =[UIFont boldSystemFontOfSize:12];
            itemAboutLast.textColor = [UIColor blackColor];
            itemAboutLast.text = @"元";
            [imageViewAbout addSubview:itemAboutLast];
        }
        
        
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        
        
        _imageViewTwo.frame = CGRectMake(_imageViewTwo.frame.origin.x, _imageViewTwoHeight+230, _imageViewTwo.frame.size.width, _imageViewTwo.frame.size.height);
        _imageViewThree.frame = CGRectMake(_imageViewThree.frame.origin.x, _imageViewThreeHeight+230, _imageViewThree.frame.size.width, _imageViewThree.frame.size.height);
        _imageViewLast.frame = CGRectMake(_imageViewLast.frame.origin.x, _imageViewLastHeight+230, _imageViewLast.frame.size.width, _imageViewLast.frame.size.height);

        _applyVIPView.frame = CGRectMake(_applyVIPView.frame.origin.x, _applyVIPViewHeight+230, _applyVIPView.frame.size.width, _applyVIPView.frame.size.height);
        // [self.contentView contentSizeToFit];
        
        
        
    } completion:^(BOOL finished) {
        
    }];
    self.contentView.contentSize = CGSizeMake(kScreenWidth, 700);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.contentView.contentSize = CGSizeMake(kScreenWidth, 700);
    
}
//议价
-(void)twoBtnPressed{
    [_twoBtn setBackgroundImage:[UIImage imageNamed:@"tv_select_bg.9.png"]  forState:UIControlStateNormal];
    [_oneBtn setBackgroundImage:[UIImage imageNamed:@"tv_unselect_bg.9.png"] forState:UIControlStateNormal];
    
    UIImageView *imageView = (UIImageView*)[self.contentView viewWithTag:1000];
    [imageView removeFromSuperview];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        _imageViewTwo.frame = CGRectMake(_imageViewTwo.frame.origin.x, _imageViewTwoHeight, _imageViewTwo.frame.size.width, _imageViewTwo.frame.size.height);
        _imageViewThree.frame = CGRectMake(_imageViewThree.frame.origin.x, _imageViewThreeHeight, _imageViewThree.frame.size.width, _imageViewThree.frame.size.height);
        _imageViewLast.frame = CGRectMake(_imageViewLast.frame.origin.x,_imageViewLastHeight, _imageViewLast.frame.size.width, _imageViewLast.frame.size.height);
        _applyVIPView.frame = CGRectMake(_applyVIPView.frame.origin.x, _applyVIPViewHeight, _applyVIPView.frame.size.width, _applyVIPView.frame.size.height);

        
    } completion:^(BOOL finished) {
        [self.contentView contentSizeToFit];
        
    }];
    
}
@end
