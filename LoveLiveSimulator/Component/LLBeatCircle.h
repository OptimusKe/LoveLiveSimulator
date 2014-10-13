//
//  LLBeatCircle.h
//  LoveLiveSimulator
//
//  Created by OptimusKe on 2014/10/11.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLBeatManager;

@interface LLBeatCircle : UIView

@property (nonatomic, assign) CGFloat dTime;

- (id)initWithFrame:(CGRect)frame circle:(UIColor *)borderColor index:(int)index launcher:(LLBeatManager *)launcher;
- (void)animationFrom:(CGPoint)fromValue to:(CGPoint)toValue withDuration:(NSTimeInterval)duration;
- (void)update:(CADisplayLink *)displayLink;

@end
