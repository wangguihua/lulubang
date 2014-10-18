//
//  MBRegExpCheck.m
//  BOCMBCI
//
//  Created by Tracy E on 13-5-9.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBRegExpCheck.h"
#import "GXMLNode.h"
#import "MBGlobalUICommon.h"
#import "RegexKitLite.h"

@interface MBRegExpCheckItem : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL required;

+ (id)itemWithLabel:(NSString *)label value:(NSString *)value type:(NSString *)type required:(BOOL)required;

@end


@implementation MBRegExpCheckItem

+ (id)itemWithLabel:(NSString *)label value:(NSString *)value type:(NSString *)type required:(BOOL)required{
    return [[MBRegExpCheckItem alloc] initWithLabel:label value:value type:type required:required];
}

- (id)initWithLabel:(NSString *)label value:(NSString *)value type:(NSString *)type required:(BOOL)required{
    self = [super init];
    if (self) {
        self.label = label;
        self.value = value;
        self.type = type;
        self.required = required;
        }
    return self;
}


@end


#pragma mark - RegExpCheck
static GXMLDocument *__regExpDocument = nil;
static GXMLDocument *regExpDocument() {
    if (__regExpDocument == NULL) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"RegExpList" ofType:@"xml"];
        NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        __regExpDocument = [[GXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    }
    return __regExpDocument;
}

MBRegExpCheckItem *RegExpItem(NSString *label, NSString *value, NSString *type, BOOL required){
    return [MBRegExpCheckItem itemWithLabel:label value:value type:type required:required];
}

BOOL RegExpCheck(NSArray *checkList){
    BOOL result = YES;
    for (MBRegExpCheckItem *item in checkList) {
        NSString *type = item.type;
        NSError *error = nil;
        NSArray *rules = [regExpDocument() nodesForXPath:[NSString stringWithFormat:@"/rules/rule[@type='%@']",type] error:&error];
        if (![rules count] || error) {
            NSLog(@"正则校验类型不存在! %s %d  %@",__FUNCTION__,__LINE__,type);
            return NO;
        }
        GXMLElement *rule = rules[0];
        NSString *pattern = [rule getAttribute:@"pattern"];
        NSString *tip = [rule getAttribute:@"tip"];
        if (item.required) {
            if (!item.value) {
                result = NO;
                MBAlert([NSString stringWithFormat:@"请输入%@",item.label]);
                break;
            } else if (![item.value isMatchedByRegex:pattern]) {
                NSLog(@"pattern:%@  value:%@",pattern,item.value);
                result = NO;
            
                MBAlert(tip);
                                
                break;
            }
        } else if(item.value && ![item.value isMatchedByRegex:pattern]) {
            NSLog(@"pattern:%@  value:%@",pattern,item.value);
            result = NO;
    
            MBAlert(tip);
            
            break;
        }
    }
    return result;
}