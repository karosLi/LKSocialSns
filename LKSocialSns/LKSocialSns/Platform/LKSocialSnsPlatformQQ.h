//
//  LKSocialSnsPlatformWechat.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsPlatform.h"

typedef NS_ENUM(NSInteger, LKSocialSnsQQLoginErrorCode) {
    LKSocialSnsQQLoginSuccess = 2000,
    LKSocialSnsQQLoginFail,
    LKSocialSnsQQLoginCancel,
};

@class LKSocialSnsBaseResp;

@interface LKSocialSnsPlatformQQ : LKSocialSnsPlatform <LKSocialSnsPlatformProtocol>

+ (void)registerApp:(NSString *)appid;

@end
