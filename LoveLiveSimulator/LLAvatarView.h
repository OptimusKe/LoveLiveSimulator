//
//  LLAvatarView.h
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/2.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLAvatarView;

@protocol AvatarTouchDelegate <NSObject>
@required
- (void)touch:(LLAvatarView *)avatarView;
@end

@interface LLAvatarView : UIView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image borderColor:(UIColor *)borderColor touch:(id <AvatarTouchDelegate> )touchDelegate;

- (void)runCircleAnimation;

@end
