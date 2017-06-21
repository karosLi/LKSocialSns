//
//  LKSocialSnsPlatformWechat.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsPlatform.h"

@class LKSocialSnsBaseResp;

@interface LKSocialSnsPlatformWeibo : LKSocialSnsPlatform <LKSocialSnsPlatformProtocol>

+ (void)registerApp:(NSString *)appkey redictURI:(NSString *)redirectURI;

@end
