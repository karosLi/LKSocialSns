//
//  JYZSocialSnsConfigCenter.h
//  LeoaoApp
//
//  Created by Karos on 16/1/14.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKSocialSnsConfigCenter : NSObject

+ (BOOL)isWXAppInstalled;
+ (BOOL)isWeiboAppInstalled;
+ (BOOL)isQQInstalled;

+ (void)registerWX:(NSString *)appid appsecret:(NSString *)appsecret;
+ (void)registerQQ:(NSString *)appid;
+ (void)registerWeibo:(NSString *)appkey rediectURI:(NSString *)redirectURI;

@end
