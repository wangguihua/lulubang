//
//  AsynImageView.h
//  Demo
//
//  Created by llbt on 14-4-2.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsynImageView : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *loadData;
    UIActivityIndicatorView *_activityIndicatorView;
    
}
//图片对应的缓存在沙河中的路径
@property (nonatomic, retain) NSString *fileName;

//指定默认未加载时，显示的默认图片
@property (nonatomic, retain) UIImage *placeholderImage;

//请求网络图片的URL
@property (nonatomic, retain) NSString *imageURL;

@end
