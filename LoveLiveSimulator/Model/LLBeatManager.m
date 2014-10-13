//
//  LLBeatManager.m
//  LoveLiveSimulator
//
//  Created by OptimusKe on 2014/10/11.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLBeatManager.h"

@interface LLBeatManager ()

@property (nonatomic, strong) NSMutableArray *circleArray;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation LLBeatManager

+ (LLBeatManager *)sharedIntance {
    static dispatch_once_t onceToken;
    static LLBeatManager *sharedIntance = nil;
    dispatch_once(&onceToken, ^{
        sharedIntance = [[self alloc] init];
    });
    return sharedIntance;
}

- (id)init {
    if (self = [super init]) {
        self.circleArray = [NSMutableArray array];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        //        self.startTime = CACurrentMediaTime();
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark - Launch Circle

- (void)launchCircleWithWidth:(CGFloat)borderWidth color:(UIColor *)borderColor index:(int)index duration:(CGFloat)timeDuration centerView:(LLBeatOrigin *)centerView targetBeater:(UIView *)targetBeater {
    LLBeatCircle *circle = [[LLBeatCircle alloc] initWithFrame:CGRectMake(0, 0, borderWidth, borderWidth) circle:borderColor index:index launcher:self];
    circle.center = centerView.center;
    [centerView.superview addSubview:circle];
    [circle animationFrom:centerView.center to:targetBeater.center withDuration:timeDuration];
    [self.circleArray addObject:circle];
}

- (void)releaseCircle:(LLBeatCircle *)circle {
    [circle removeFromSuperview];
    [self.circleArray removeObject:circle];
}

- (void)update:(CADisplayLink *)displayLink {
    LLBeatCircle *missedCircle = nil;
    
    for (LLBeatCircle *circle in self.circleArray) {
        //enable
        if (circle.dTime < 1.3) {
            [circle update:displayLink];
        }
        else {
            //miss
            missedCircle = circle;
        }
    }
    
    if (missedCircle) {
        [self releaseCircle:missedCircle];
    }
}

#pragma mark - touch event

- (void)checkCircleTouchMatchBeater:(LLBeaterView *)beater {
    LLBeatCircle *touchedCircle = nil;
    
    for (LLBeatCircle *circle in self.circleArray) {
        if (!CGRectIsNull(CGRectIntersection(beater.frame, circle.frame))) {
            [beater runCircleAnimation];
            touchedCircle = circle;
        }
    }
    
    if (touchedCircle) {
        [self releaseCircle:touchedCircle];
    }
}

@end
