//
//  LKSocialSnsConstant.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#ifndef LKSocialSnsConstant_h
#define LKSocialSnsConstant_h

#if __has_include(<TencentOpenAPI/QQApiInterface.h>)
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#else
#import "QQApiInterface.h"
#import "TencentOAuth.h"
#endif

#import "WXApi.h"
#import "WeiboSDK.h"
#import "LKSocialSnsAccountInfo.h"

/**
 微信好友
 */
extern NSString *const LKShareToWechatSession;

/**
 微信朋友圈
 */
extern NSString *const LKShareToWechatTimeline;

/**
 手机QQ
 */
extern NSString *const LKShareToQQ;

/**
 QQ空间
 */
extern NSString *const LKShareToQzone;

/**
 新浪微博
 */
extern NSString *const LKShareToWeibo;

typedef void(^LKLoginCompeletion)(LKSocialSnsAccountInfo *snsAccount, NSString *errorMsg);
typedef void(^LKShareCompeletion)(NSString *errorMsg);
typedef void(^LKShareMenuChooseItemBlock)(id value);

#endif /* LKSocialSnsConstant_h */
