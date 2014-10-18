//
//  ZbarScanViewController.m
//  QR code
//
//  Created by Tracy E on 13-4-24.
//  Copyright (c) 2013年 斌. All rights reserved.
//

#import "ZBarScanViewController.h"
#import "ZBarReaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "MBGlobalUICommon.h"

NSString* const ZBarScanViewControllerImageMessage = @"ZBarScanViewControllerImageMessage";

@interface ZBarImagePickerController : UIImagePickerController
@end
@implementation ZBarImagePickerController
@end

@interface UINavigationBar (CustomStyle)
@end

@implementation UINavigationBar (CustomStyle)

- (void)drawRect:(CGRect)rect
{
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
        [self setTintColor:[UIColor colorWithRed:160.0/255.0 green:0 blue:0 alpha:1.0]];
        
        UIImage *image;
        image = [[UIImage imageNamed:@"navigationBar.png"] stretchableImageWithLeftCapWidth:1/2 topCapHeight:10];
        [image drawInRect:self.bounds];
    }
    */
}
@end

@interface ZbarCameraOverlayView : UIImageView

@end

@implementation ZbarCameraOverlayView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImage imageNamed:@"zbar_cameraOverlay.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 220, 50)];
        tipLabel.layer.cornerRadius = 5.0f;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        tipLabel.text = @"请将二维码图案放在取景框内，即可自动扫码";
        tipLabel.numberOfLines = 2;
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tipLabel];
        
        UIImageView *scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(45, 64, 230, 11)];
        scanLine.image = [UIImage imageNamed:@"zbar_scanline.png"];
        [self addSubview:scanLine];
        
        if (MBIsIPhone5()) {
            tipLabel.frame = CGRectMake(50, 50, 220, 50);
            scanLine.frame = CGRectMake(45, 154, 230, 11);
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:999999];
        [UIView setAnimationDuration:3.0f];
        scanLine.transform = CGAffineTransformMakeTranslation(0, 220);
        [UIView commitAnimations];
    }
    return self;
}

@end


@interface ZBarScanViewController ()<ZBarReaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ZBarScanViewController{
    UIView *_loadingBackgroundView;
    UIActivityIndicatorView *_loadingView;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    float barHeight = 44;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    }
     */
    navigationBar.items = @[[[UINavigationItem alloc] initWithTitle:@"扫描二维码"]];
    [self.view addSubview:navigationBar];
    
    CGSize size = self.view.frame.size;
    
    _imageScanner = [[ZBarImageScanner alloc] init];
    [_imageScanner setSymbology:ZBAR_PARTIAL config:ZBAR_CFG_ENABLE to:0];
    _imageScanner.enableCache = YES;
    
    _readView = [[ZBarReaderView alloc] initWithImageScanner:_imageScanner];
    _readView.tracksSymbols = NO;
    _readView.readerDelegate = self;
    _readView.frame = CGRectMake(0, barHeight, size.width, size.height - 2 * barHeight);
    _readView.backgroundColor = [UIColor blackColor];
    [self.view addSubview: _readView];
    
    self.cameraOverlayView = [[ZbarCameraOverlayView alloc] initWithFrame:CGRectMake(0, barHeight, size.width, size.height - 2 * barHeight)];
    [self.view addSubview:_cameraOverlayView];
    
    _loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, barHeight, size.width, size.height - 2 * barHeight)];
    _loadingBackgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_loadingBackgroundView];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _loadingView.frame = CGRectMake(0, 0, 40, 40);
    _loadingView.center = _loadingBackgroundView.center;
    [_loadingView startAnimating];
    [_loadingView setHidesWhenStopped:YES];
    [self.view addSubview:_loadingView];
    
    
    UIToolbar *controlsBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, size.height - 44, size.width, 44)];
    controlsBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *imageSelectItem = [[UIBarButtonItem alloc] initWithTitle:@"相册选择"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(selectImageFromPhotoLibrary)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(cancelScan)];
    controlsBar.items = [NSArray arrayWithObjects:imageSelectItem, spaceItem, cancelItem, nil];
    [self.view addSubview:controlsBar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_readView start];
    
    [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.3];
}

- (void)removeLoadingView{
    [_loadingView setHidden:YES];
    [_loadingBackgroundView removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_readView stop];
}

- (void)selectImageFromPhotoLibrary{
    ZBarImagePickerController *imagePickerController = [[ZBarImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5) {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (void)cancelScan{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    if (_scanDelegate && [_scanDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [_scanDelegate imagePickerControllerDidCancel:(UIImagePickerController *)self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        [picker dismissModalViewControllerAnimated:YES];
    }
    
    [self.view addSubview:_loadingBackgroundView];
    [_loadingView startAnimating];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ZBarImage *zbarImage = [[ZBarImage alloc] initWithCGImage:[image CGImage]];
    [_imageScanner scanImage:zbarImage];
    
    ZBarSymbolSet *results = [_imageScanner results];
    
    ZBarSymbol *symbol = nil;
    for (symbol in results) {
        break;
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.5];
        
        if (_scanDelegate && [_scanDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
            NSMutableDictionary *zbarInfo = [info mutableCopy];
            if (symbol.data) {
                [zbarInfo setValue:symbol.data forKey:ZBarScanViewControllerImageMessage];
            }
            [_scanDelegate imagePickerController:(UIImagePickerController *)self didFinishPickingMediaWithInfo:zbarInfo];
        }
    });
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image{
    ZBarSymbol *symbol = nil;
    for (symbol in symbols) {
        break;
    }
    
    if (_scanDelegate && [_scanDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
        NSMutableDictionary *zbarInfo = [[NSMutableDictionary alloc] init];
        [zbarInfo setObject:image forKey:UIImagePickerControllerOriginalImage];
        if (symbol.data) {
            [zbarInfo setValue:symbol.data forKey:ZBarScanViewControllerImageMessage];
        }
        [_scanDelegate imagePickerController:(UIImagePickerController *)self didFinishPickingMediaWithInfo:zbarInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
