//
//  MBAFRequest.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-4.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************Example*************************************
 NSDictionary *params =@{[PsnCrcdQueryAccountDetail accountId]:  @"112",
                         [PsnCrcdQueryAccountDetail currency]:  @"001"};
 
 MBRequestItem *requestItem = [MBRequestItem itemWithMethod:[PsnCrcdQueryAccountDetail method] 
                                             conversationId:NULL 
                                                     params: params];
 [MBAFRequest requestWithItems:[NSArray arrayWithObject:requestItem] success:^(id JSON) {
 
 } failure:^(NSError *error, id JSON) {
 
 }];

 **********************************************************************/


#pragma mark - 请求封装类
@interface MBRequestItem : NSObject

@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, strong) NSDictionary *params;

+ (MBRequestItem *)itemWithMethod:(NSString *)method
                   conversationId:(NSString *)conversationId
                           params:(NSDictionary *)params;
@end


@interface MBAFRequest : NSObject

//通用JSON通讯
+ (NSOperation *)requestWithItems:(NSArray *)items
                 success:(void (^)(id JSON))success
                 failure:(void (^)(NSError *error, id JSON))failure;

+ (NSOperation *)requestWithItems:(NSArray *)items
                             info:(NSDictionary *)info
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *, id))failure;

@end
