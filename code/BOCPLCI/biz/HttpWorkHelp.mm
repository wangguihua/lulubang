//
//  HttpWorkHelp.m
//  BOCPLCI
//
//  Created by IBM on 14-10-12.
//  Copyright (c) 2014年 China M-World Co.,Ltd. All rights reserved.
//

#import "HttpWorkHelp.h"
#import "JSONKit.h"
@implementation HttpWorkHelp
+ (id)ShareData
{
    static HttpWorkHelp *safetyData=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safetyData = [[HttpWorkHelp alloc] init];
    });
    return safetyData;
}
-(void)httpGet:(void (^)(NSDictionary *))sendData andUrlName:(NSString *)urlName andHTTPType:(NSString *)httpType withDic:(NSDictionary *)comeData andFailCallBack:(void (^)(NSDictionary *))failCallBack{
    
    safetyDataSend = nil;
    safetyDataSendFailCallBack = nil;
    safetyDataSend = sendData;
    safetyDataSendFailCallBack = failCallBack;
    //第一步，创建url
    
    NSURL *url = [NSURL URLWithString:urlName];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    if ([httpType isEqualToString:@"POST"]) {
        [request setHTTPMethod:@"POST"];
        
        NSString *strData = [comeData JSONString];
        
        NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:data];

    }
    
    //第三步，连接服务器
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    if (!_loadingView) {
        _loadingView =[[MBLoadingView alloc] init];
        
    }
    [_loadingView show];
    
}
//接收到服务器回应的时候调用此方法

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",[res allHeaderFields]);
    
    self.receiveData = [NSMutableData data];
    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    [self.receiveData appendData:data];
    
}

//数据传完之后调用此方法

-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",receiveStr);
    NSDictionary *result = [receiveStr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    safetyDataSend(result);
    [_loadingView hide];

    
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法

-(void)connection:(NSURLConnection *)connection

 didFailWithError:(NSError *)error

{
    
    NSLog(@"%@",[error localizedDescription]);
    [_loadingView hide];
    safetyDataSendFailCallBack(nil);
}
@end
