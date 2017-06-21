//
//  LKSocialSnsPlatform.m
//  LeoaoApp
//
//  Created by Karos on 16/1/13.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKSocialSnsPlatform.h"
#import "LKSocialSnsManager.h"

@interface LKSocialSnsPlatform ()

@property (nonatomic, weak) NSObject<LKSocialSnsPlatformProtocol> *child;

@property (nonatomic, copy, readwrite) LKLoginCompeletion loginCompletion;
@property (nonatomic, copy, readwrite) LKShareCompeletion shareCompletion;

@end

@implementation LKSocialSnsPlatform

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([self conformsToProtocol:@protocol(LKSocialSnsPlatformProtocol)]) {
        self.child = (id <LKSocialSnsPlatformProtocol>)self;
    } else {
        NSException *exception = [[NSException alloc] initWithName:@"LKSocialSnsPlatform" reason:@"The child class of LKSocialSnsPlatform should implement LKSocialSnsPlatform protocol" userInfo:nil];
        @throw exception;
    }
    
    return self;
}

- (void)login:(LKLoginCompeletion)completion {
    self.loginCompletion = completion;
    [LKSocialSnsManager shared].currentSharePlatform = self.socialType;
    
    if ([self.child respondsToSelector:@selector(socialLogin:)]) {
        [self.child socialLogin:completion];
    }
}

- (void)shareImage:(UIImage *)shareImage title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion {
    self.shareCompletion = completion;
    [LKSocialSnsManager shared].currentSharePlatform = self.socialType;
    
    if ([self.child respondsToSelector:@selector(socialShareImage:title:description:targetLink:completion:)]) {
        [self.child socialShareImage:shareImage title:title description:description targetLink:targetLink completion:completion];
    }
}

- (void)shareImageURL:(NSString *)shareImageURL title:(NSString *)title description:(NSString *)description targetLink:(NSString *)targetLink completion:(LKShareCompeletion)completion
{
    self.shareCompletion = completion;
    [LKSocialSnsManager shared].currentSharePlatform = self.socialType;
    
    if ([self.child respondsToSelector:@selector(socialShareImageURL:title:description:targetLink:completion:)]) {
        [self.child socialShareImageURL:shareImageURL title:title description:description targetLink:targetLink completion:completion];
    }
}

- (void)onReceiveResponse:(LKSocialSnsBaseResp *)resp
{
    if ([self.child respondsToSelector:@selector(socialOnReceiveResponse:)]) {
        [self.child socialOnReceiveResponse:resp];
    }
}

@end
