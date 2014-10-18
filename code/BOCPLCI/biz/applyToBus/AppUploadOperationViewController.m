//
//  AppUploadIDCardViewController.m
//  BOCPLCI
//
//  Created by wang on 14-9-25.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "AppUploadOperationViewController.h"
#import "MBTextField.h"
#import "MBSelectView.h"
@interface AppUploadOperationViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    MBTextField *_nameTF;
    MBTextField *_cardTF;
    UIButton*_showBtn;
    BOOL _isHave;
    MBTextField *_timeSele;

}
@end

@implementation AppUploadOperationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公司认证信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectNameOver)];
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 210)];
    imageView.layer.borderWidth  = 0.5f;
    imageView.layer.cornerRadius  = 7.0f;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:imageView];
    imageView.alpha=0.6;
    imageView.userInteractionEnabled = YES;
    
    _isHave = NO;
    
    UILabel*_itemNamel  =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    _itemNamel.backgroundColor =[UIColor clearColor];
    _itemNamel.font =kNormalTextFont;
    _itemNamel.text = @"公司名称: ";
    [imageView addSubview:_itemNamel];
    
    _nameTF = [[MBTextField alloc]initWithFrame:CGRectMake(70, 10, kScreenWidth-90-30, 30)];
    _nameTF.backgroundColor=[UIColor clearColor];
    _nameTF.borderStyle=UITextBorderStyleNone;
    [imageView addSubview:_nameTF];
    
    
    UIImageView *sepeImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth-20, 1)];
    sepeImage.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:sepeImage];
    sepeImage.alpha=0.6;
    
    
    UILabel*_itemIDNamel  =[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 30)];
    _itemIDNamel.backgroundColor =[UIColor clearColor];
    _itemIDNamel.font =kNormalTextFont;
    _itemIDNamel.text = @"公司类型: ";
    [imageView addSubview:_itemIDNamel];
    
    _cardTF = [[MBTextField alloc]initWithFrame:CGRectMake(70, 50, kScreenWidth-90-30, 30)];
    _cardTF.backgroundColor=[UIColor clearColor];
    _cardTF.borderStyle=UITextBorderStyleNone;
    [imageView addSubview:_cardTF];
    
    UIImageView *sepeImageTwo =[[UIImageView alloc]initWithFrame:CGRectMake(10, 100, kScreenWidth-20, 1)];
    sepeImageTwo.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:sepeImageTwo];
    sepeImageTwo.alpha=0.6;
    
    
    
    UILabel*_itemIDNamelTiem  =[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 60, 30)];
    _itemIDNamelTiem.backgroundColor =[UIColor clearColor];
    _itemIDNamelTiem.font =kNormalTextFont;
    _itemIDNamelTiem.text = @"公司地址: ";
    [imageView addSubview:_itemIDNamelTiem];
    

    
    _timeSele = [[MBTextField alloc]initWithFrame:CGRectMake(70, 103, kScreenWidth-90-30, 30)];
    _timeSele.backgroundColor=[UIColor clearColor];
    _timeSele.borderStyle=UITextBorderStyleNone;
    [imageView addSubview:_timeSele];
    
    
    UIImageView *sepeImageThree =[[UIImageView alloc]initWithFrame:CGRectMake(10, 150, kScreenWidth-20, 1)];
    sepeImageThree.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:sepeImageThree];
    sepeImageThree.alpha=0.6;
    
    
    UILabel*_itemIDNamelImage  =[[UILabel alloc]initWithFrame:CGRectMake(10, 165, 80, 30)];
    _itemIDNamelImage.backgroundColor =[UIColor clearColor];
    _itemIDNamelImage.font =kNormalTextFont;
    _itemIDNamelImage.text = @"资料照片: ";
    [imageView addSubview:_itemIDNamelImage];
    
    
    _showBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _showBtn.frame = CGRectMake(100, 145, 60, 60);
    _showBtn.backgroundColor = [UIColor orangeColor];
    _showBtn.layer.cornerRadius = 10.0f;
    _showBtn.layer.borderWidth=0.5;
    [_showBtn setImage:[UIImage imageNamed:@"bg_add_image.png"] forState:UIControlStateNormal];
    _showBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [_showBtn addTarget:self action:@selector(showImageSelect) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:_showBtn];
    
}
//选择照片
-(void)showImageSelect{

    UIActionSheet *shee = [[UIActionSheet alloc]initWithTitle:@"设置上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择本地照片" otherButtonTitles:@"拍照", nil];
    [shee showInView:self.contentView];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==2) {
        return;
    }
    UIImagePickerControllerSourceType sourceType ;
    if (buttonIndex==0) {
        //本地照片
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    if (buttonIndex==1) {
        //拍照
     sourceType = UIImagePickerControllerSourceTypeCamera;

    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [_showBtn setImage:info[@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];

    [picker dismissViewControllerAnimated:YES completion:nil];
}
//完成
- (void)selectNameOver
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
