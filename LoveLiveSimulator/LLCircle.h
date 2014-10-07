//
//  LLCircle.h
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/7.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLCircleLauncher;

@interface LLCircle : UIView

- (id)initWithFrame:(CGRect)frame circle:(UIColor *)borderColor index:(int)index launcher:(LLCircleLauncher *)launcher;
- (void)animationFrom:(CGPoint)fromValue to:(CGPoint)toValue withDuration:(NSTimeInterval)duration;
- (void)stopAnimation;

@end
