//
//  LLCircleLauncher.h
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/7.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCircle.h"
#import "LLNote.h"
#import "LLAvatarView.h"

#define CircleLauncher [LLCircleLauncher sharedIntance]

@interface LLCircleLauncher : NSObject

+ (LLCircleLauncher *)sharedIntance;


- (void)launchCircleWithWidth:(CGFloat)borderWidth color:(UIColor *)borderColor index:(int)index duration:(CGFloat)timeDuration centerView:(LLNote *)centerView targetAvatar:(UIView *)targetAvatar;

- (void)releaseCircle:(LLCircle *)circle;

- (void)checkCircleTouchMatchAvatar:(LLAvatarView *)avatar;

@end
