//
//  MBAFRequest.m
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-4.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBAFRequest.h"
#import "AFJSONRequestOperation.h"
#import "NSStringAdditions.h"
#import "JSONKit.h"
#import "MBLoadingView.h"
#import "MBAllModel.h"

#if __MB_SHOW_WARNING__
    #warning 修改后台服务器地址
#endif

#define kBIIBaseURL @"http://22.188.XX.XX/XXX.do"

@implementation MBRequestItem

+ (MBRequestItem *)itemWithMethod:(NSString *)method
                   conversationId:(NSString *)conversationId
                           params:(NSDictionary *)params{
    return [[MBRequestItem alloc] initWithMethod:method
                                  conversationId:conversationId
                                          params:params];
}

- (MBRequestItem *)initWithMethod:(NSString *)method
                   conversationId:(NSString *)conversationId
                           params:(NSDictionary *)params{
    self = [super init];
    if (self) {
        self.method = method;
        self.conversationId = conversationId;
        self.params = params;
    }
    return self;
}


@end


@implementation MBAFRequest

static NSString* kURL(){
    NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:@"kServerURL"];
    return url ? url : kBIIBaseURL;
}

//自定义通讯
//info keys:
#define MBRequest_ShowErrorAlert  @"MBRequestShowErrorAlert"    //@"yes" | @"no", default is @"yes".
#define MBRequest_ShowLoadingView @"MBRequestShowLoadingView"   //@"yes" | @"no", default is @"yes".
#define MBRequest_CanCancelRequest @"MBRequestCanCancelRequest" //@"yes" | @"no", default is @"yes".


BOOL errorHandle(NSDictionary *result, BOOL showAlert, NSString *methodName){
    BOOL hasError = NO;
    @try {
        
    }
    @catch (NSException *exception) {

    }
    return hasError;
}

//不能取消通讯的接口列表
BOOL shouldCancelRequest(NSString *method) {
    return ![@[
//               [PsnTransLinkTransferSubmit method],
//               [PsnFinanceICTransfer method],
               ] containsObject:method];
}

#pragma mark -
+ (NSOperation *)requestWithItems:(NSArray *)items
                 success:(void (^)(id JSON))success
                 failure:(void (^)(NSError *error, id JSON))failure{
    return [MBAFRequest requestWithItems:items info:nil success:success failure:failure];
}

+ (NSOperation *)requestWithItems:(NSArray *)items
                             info:(NSDictionary *)info
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *, id))failure{
    NSDictionary *headers = @{@"agent":     @"X-IOS",
                              @"device":    @"",
                              @"ext":       @"",
                              @"local":     @"zh_CN",
                              @"page":      @"FF001",
                              @"platform":  @"",
                              @"plugins":   @"",
                              @"version":   @""
                              };
    
    NSMutableArray *methods = [[NSMutableArray alloc] init];
    for (MBRequestItem *item in items) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:item.params];
        
        params[@"id"] = [NSString stringWithFormat:@"%ld",random()];
        if (item.conversationId) {
            params[@"conversationId"] = item.conversationId;
        }
        
        NSDictionary *method = @{@"method": item.method,
                                 @"header": headers,
                                 @"params": params};
        [methods addObject:method];
    }
    
    NSDictionary *postInfo = nil;
    if ([items count] == 1) {
        postInfo = methods[0];
    } else {
        postInfo = @{@"method": @"CompositeAjax",
                     @"header": headers,
                     @"params": @{@"methods": methods}};
    }
    
    NSString *postString = [NSString stringWithFormat:@"json=%@",[[postInfo JSONString] urlEncoded]];
    NSLog(@"post:%@",postString);
    

    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kURL()]];
    [urlRequest setTimeoutInterval:300.0];
    [urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"json" forHTTPHeaderField:@"bfw-ctrl"];
    [urlRequest setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];

    NSLog(@"\n------【Request】------\n%@\n%@",[urlRequest allHTTPHeaderFields], [postInfo JSONString]);

    BOOL shouldShowLoadingView = [info[MBRequest_ShowLoadingView] isEqualToString:@"no"] ? NO : YES;
    BOOL shouldShowErrorAlert = [info[MBRequest_ShowErrorAlert] isEqualToString:@"no"] ? NO : YES;
    BOOL canCancelRequest = YES;
    if (info[MBRequest_CanCancelRequest]) {
        canCancelRequest = [info[MBRequest_CanCancelRequest] isEqualToString:@"no"] ? NO : YES;
    } else {
        MBRequestItem *item = items[0];
        NSLog(@"method:%@",item.method);
        canCancelRequest = shouldCancelRequest(item.method);
    }
    
    MBLoadingView *loadingView = nil;
    if (shouldShowLoadingView) {
        loadingView = [[MBLoadingView alloc] init];
        loadingView.canCancel = canCancelRequest;
    }

    
    __block NSInteger statusCode = -1;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [loadingView hide];
        NSLog(@"-------[Response]-----------\n%@ %d \n%@",[response allHeaderFields],[response statusCode],[JSON JSONString]);
        
        statusCode = [response statusCode];
        if (statusCode == 200) {
            if (JSON) {
                MBRequestItem *item = items[0];
                if (!errorHandle(JSON, shouldShowErrorAlert, item.method)) {
                    NSArray *responseArray;
                    if (JSON[@"result"]) {
                        responseArray = @[@{@"result": JSON[@"result"],
                                            @"status": @"01"}];
                    } else {
                        responseArray = @[@{@"status": @"01"}];
                    }
                    success(responseArray);
                }else{
                    failure(nil, JSON);
                }
            }else{
                failure(nil, JSON);
            }
        } else {
            failure(nil, JSON);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [loadingView hide];
        
        NSLog(@"error:%@",error);
        NSLog(@"-------[Response]-----------\n%@ %d \n%@",[response allHeaderFields],[response statusCode],[JSON JSONString]);

        failure(error, JSON);
    }];
    [operation start];
    loadingView.requestOperation = operation;
    [loadingView show];
    
    return operation;
}


@end
