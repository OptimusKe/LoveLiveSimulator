//
//  LLBeatCircle.m
//  LoveLiveSimulator
//
//  Created by OptimusKe on 2014/10/11.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLBeatCircle.h"
#import "LLBeatManager.h"

@interface LLBeatCircle ()

@property (nonatomic) UIColor *borderColor;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) CGPoint startValue, endValue;
@property (nonatomic, assign) CGFloat rate, totaltime, scaleStartValue;
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) LLBeatManager *beatManager;

@end

@implementation LLBeatCircle

- (id)initWithFrame:(CGRect)frame circle:(UIColor *)borderColor index:(int)index launcher:(LLBeatManager *)launcher {
    self = [super initWithFrame:frame];
    if (self) {
        self.index = index;
        self.borderColor = borderColor;
        self.beatManager = launcher;
        self.userInteractionEnabled = NO;
        [self draw];
    }
    return self;
}

- (void)draw {
    CALayer *layer = self.layer;
    layer.borderWidth = 2.0;
    layer.borderColor = self.borderColor.CGColor;
    layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    layer.masksToBounds = YES;
}

#pragma mark - animation

- (void)animationFrom:(CGPoint)fromValue to:(CGPoint)toValue withDuration:(NSTimeInterval)duration {
    self.startValue = fromValue;
    self.endValue = toValue;
    self.startTime = CACurrentMediaTime();
    self.totaltime = duration;
    self.scaleStartValue = 0.3;
    self.transform = CGAffineTransformMakeScale(self.scaleStartValue, self.scaleStartValue);
}

- (void)update:(CADisplayLink *)displayLink {
    float dt = ([displayLink timestamp] - self.startTime) / self.totaltime;
    self.dTime = dt;
    
    //move
    CGFloat dx = (self.endValue.x - self.startValue.x) * displayLink.duration / self.totaltime;
    CGFloat dy = (self.endValue.y - self.startValue.y) * displayLink.duration / self.totaltime;
    CGPoint dPoint = CGPointMake(self.center.x + dx, self.center.y + dy);
    self.center = dPoint;
    
    //scale
    CGFloat dScaleX = self.scaleStartValue + (1 - self.scaleStartValue) * dt;
    CGFloat dScaleY = self.scaleStartValue + (1 - self.scaleStartValue) * dt;
    self.transform = CGAffineTransformMakeScale(dScaleX, dScaleY);
}

@end
