//
//  MBCorePreprocessorMacros.h
//  BOCPLCI
//
//  Created by Ivan Li on 13-11-4.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#pragma mark - 全局编译配置
#define __MB_DEBUG__                (1)  //是否为debug模式
#define __MB_LOG__                  (1)  //是否打开log
#define __MB_SAVE_LOG__             (0)  //是否将log保存到文件/Documents/log/
#define __MB_SHOW_WARNING__         (1)  //显示warning
#pragma mark - OS Version

#undef  IOS7_OR_LATER
#define IOS7_OR_LATER       ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

#pragma mark - 方法宏定义
#define MB_RELEASE_SAFELY(__POINTER) {  __POINTER = nil; }
#define MB_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
#define MBAppBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//--------------------------------------------------------------------------------------------------
//rgb颜色
#define MB_RGB(__r, __g, __b) [UIColor colorWithRed:(__r / 255.0) green:(__g / 255.0) blue:(__b / 255.0) alpha:1]
#define MB_RGBA(__r, __g, __b, __a) [UIColor colorWithRed:(__r / 255.0) green:(__g / 255.0) blue:(__b / 255.0) alpha:__a]

#pragma mark - 生成静态属性
//--------------------------------------------------------------------------------------------------
#undef MB_STATIC_PROPERTY
#define MB_GET_PROPERTY( __name) \
    @property (nonatomic, strong, readonly) NSString* __name; \
    + (NSString *)__name;

#undef MB_SET_PROPERTY
#define MB_SET_PROPERTY( __name, __value) \
    @dynamic __name; \
    + (NSString *)__name \
    { \
        return __value; \
    }

#pragma mark - 申明为单例
//--------------------------------------------------------------------------------------------------
#undef	MB_AS_SINGLETON
#define MB_AS_SINGLETON( __class ) \
    + (__class *)sharedInstance;

#undef	MB_DEF_SINGLETON
#define MB_DEF_SINGLETON( __class ) \
    + (__class *)sharedInstance \
    { \
        static dispatch_once_t once; \
        static __class * __singleton__; \
        dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
        return __singleton__; \
}

#pragma mark - 6.0以下兼容6.0枚举类型，避免版本导致的警告
//--------------------------------------------------------------------------------------------------
#define UILineBreakMode                 NSLineBreakMode
#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
#define UILineBreakModeClip				NSLineBreakByClipping
#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

#define UITextAlignment                 NSTextAlignment
#define UITextAlignmentLeft				NSTextAlignmentLeft
#define UITextAlignmentCenter			NSTextAlignmentCenter
#define UITextAlignmentRight			NSTextAlignmentRight

#pragma mark - 4.3的情况下兼容5.0的ARC关键字
//--------------------------------------------------------------------------------------------------
#if (!__has_feature(objc_arc)) || \
(defined __IPHONE_OS_VERSION_MIN_REQUIRED && \
__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0) || \
(defined __MAC_OS_X_VERSION_MIN_REQUIRED && \
__MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_7)
#undef weak
#define weak unsafe_unretained
#undef __weak
#define __weak __unsafe_unretained
#endif

#pragma mark - performSelector方法在ARC模式下会有警告
//--------------------------------------------------------------------------------------------------
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#pragma clang diagnostic pop
