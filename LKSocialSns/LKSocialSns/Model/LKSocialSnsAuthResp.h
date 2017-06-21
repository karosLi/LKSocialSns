//
//  JYZAuthResp.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKSocialSnsBaseResp.h"

@interface LKSocialSnsAuthResp : LKSocialSnsBaseResp

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

/**
 微信临时授权码
 */
@property (nonatomic, retain) NSString *code;

/** 第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传
 * @note state字符串长度不能超过1K
 */
@property (nonatomic, retain) NSString *state;

@end
