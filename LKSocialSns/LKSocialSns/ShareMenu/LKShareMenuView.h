//
//  DropdownMenuView.h
//  LeoaoApp
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSocialSnsConstant.h"

@interface LKShareMenuView : UIView

+ (void)show:(NSArray<NSString *> *)datasoure block:(LKShareMenuChooseItemBlock)block;

@end

