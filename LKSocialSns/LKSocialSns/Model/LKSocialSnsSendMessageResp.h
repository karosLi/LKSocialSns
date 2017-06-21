//
//  LKSendMessageResp.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsBaseResp.h"

@interface LKSocialSnsSendMessageResp : LKSocialSnsBaseResp

/**
 用户ID
 */
@property (nonatomic, strong) NSString *userID;

/**
 认证口令
 */
@property (nonatomic, strong) NSString *accessToken;

/**
 认证过期时间
 */
@property (nonatomic, strong) NSDate *expirationDate;

/**
 当认证口令过期时用于换取认证口令的更新口令
 */
@property (nonatomic, strong) NSString *refreshToken;

@end
