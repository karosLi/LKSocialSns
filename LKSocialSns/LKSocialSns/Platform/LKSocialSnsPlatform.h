//
//  LKSocialSnsPlatform.h
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKSocialSnsHelper.h"

@class LKSocialSnsBaseResp;

@protocol LKSocialSnsPlatformProtocol <NSObject>

@required

- (void)socialLogin:(LKLoginCompeletion)completion;
- (void)socialShareImage:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion;
- (void)socialShareImageURL:(NSString *)shareImageURL title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion;
- (void)socialOnReceiveResponse:(LKSocialSnsBaseResp *)resp;

@end

@interface LKSocialSnsPlatform : NSObject

/// 子类的实例
@property (nonatomic, weak, readonly) NSObject<LKSocialSnsPlatformProtocol> *child;
@property (nonatomic, strong) NSString *socialType;
@property (nonatomic, copy, readonly) LKLoginCompeletion loginCompletion;
@property (nonatomic, copy, readonly) LKShareCompeletion shareCompletion;

- (void)login:(LKLoginCompeletion)completion;
- (void)shareImage:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion;
- (void)shareImageURL:(NSString *)shareImageURL title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion;

// 处理回调结果
- (void)onReceiveResponse:(LKSocialSnsBaseResp *)resp;

@end
