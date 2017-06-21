//
//  LKSocialSnsPlatformWechat.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsPlatform.h"

@class LKSocialSnsBaseResp;

extern NSString * const kWechatScopeUserBase;

@interface LKSocialSnsPlatformWechat : LKSocialSnsPlatform <LKSocialSnsPlatformProtocol>

+ (void)registerApp:(NSString *)appid secret:(NSString *)appsecret;

@end
