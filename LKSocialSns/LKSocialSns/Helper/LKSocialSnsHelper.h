//
//  LKSocialSnsHelper.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKSocialSnsConstant.h"
#import "LKSocialSnsAuthResp.h"
#import "LKSocialSnsSendMessageResp.h"

@interface LKSocialSnsHelper : NSObject

+ (LKSocialSnsAuthResp *)authRespFromWX:(SendAuthResp *)resp;
+ (LKSocialSnsSendMessageResp *)sendMsgRespFromWX:(SendMessageToWXResp *)resp;
+ (LKSocialSnsAuthResp *)authRespFromWeibo:(WBAuthorizeResponse *)resp;
+ (LKSocialSnsSendMessageResp *)sendMsgRespFromWeibo:(WBSendMessageToWeiboResponse *)resp;
+ (LKSocialSnsSendMessageResp *)sendMsgRespFromQQ:(SendMessageToQQResp *)resp;

@end
