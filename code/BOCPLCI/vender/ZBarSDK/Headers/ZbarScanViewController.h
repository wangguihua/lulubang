//
//  ZbarScanViewController.h
//  QR code
//
//  Created by Tracy E on 13-4-24.
//  Copyright (c) 2013年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBarReaderView;
@class ZBarImageScanner;
@protocol ZBarScanViewControllerDelegate;
@interface ZBarScanViewController : UIViewController{
}

@property (nonatomic, retain, readonly) ZBarReaderView *readView;
@property (nonatomic, retain, readonly) ZBarImageScanner *imageScanner;
@property (nonatomic, retain) UIView *cameraOverlayView;

@property (nonatomic, assign) id<ZBarScanViewControllerDelegate> scanDelegate;

@end


@protocol ZBarScanViewControllerDelegate <NSObject>

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info;
@optional
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end

extern NSString* const ZBarScanViewControllerImageMessage;
