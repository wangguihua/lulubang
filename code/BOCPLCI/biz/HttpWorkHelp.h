//
//  HttpWorkHelp.h
//  BOCPLCI
//
//  Created by IBM on 14-10-12.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBLoadingView.h"

@interface HttpWorkHelp : NSObject
{
    void(^safetyDataSend)(NSDictionary *dic);
    void(^safetyDataSendFailCallBack)(NSDictionary *dic);
    MBLoadingView *_loadingView ;

}
@property(nonatomic,strong)NSMutableData *receiveData;
+(id)ShareData;
/**
 *
 *  @param sendData         回调请求后的参数
 *  @param urlName          接口名称
 *  @param comeData         请求体信息
 *  @param failCallBack     失败回调参数
 */
-(void)httpGet:(void(^)(NSDictionary *dic))sendData
       andUrlName:(NSString *)urlName
      andHTTPType:(NSString*)httpType
       withDic:(NSDictionary *)comeData
andFailCallBack:(void(^)(NSDictionary *dic))failCallBack;
@end