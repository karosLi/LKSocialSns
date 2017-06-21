//
//  JYZSocialSnsConfigCenter.m
//  LeoaoApp
//
//  Created by Karos on 16/1/14.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "LKSocialSnsConfigCenter.h"
#import "LKSocialSnsConfig.h"
#import "LKSocialSnsConstant.h"
#import "LKSocialSnsPlatformWechat.h"
#import "LKSocialSnsPlatformQQ.h"
#import "LKSocialSnsPlatformWeibo.h"

@interface LKSocialSnsConfigCenter ()

@end

@implementation LKSocialSnsConfigCenter

+ (void)registerWX:(NSString *)appid appsecret:(NSString *)appsecret {
    [LKSocialSnsPlatformWechat registerApp:appid secret:appsecret];
}

+ (void)registerQQ:(NSString *)appid {
    [LKSocialSnsPlatformQQ registerApp:appid];
}

+ (void)registerWeibo:(NSString *)appkey rediectURI:(NSString *)redirectURI {
    [LKSocialSnsPlatformWeibo registerApp:appkey redictURI:redirectURI];
}

+ (BOOL)isWXAppInstalled {
    return [WXApi isWXAppInstalled];
}

+ (BOOL)isWeiboAppInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

+ (BOOL)isQQInstalled {
    return [QQApiInterface isQQInstalled];
}

@end
