//
//  LLCircle.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/7.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLCircle.h"
#import "LLCircleLauncher.h"

@interface LLCircle ()

@property (nonatomic) UIColor *borderColor;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) CGPoint startValue, endValue;
@property (nonatomic, assign) CGFloat rate, totaltime, scaleStartValue;
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) LLCircleLauncher *launcher;


@end

@implementation LLCircle

- (id)initWithFrame:(CGRect)frame circle:(UIColor *)borderColor index:(int)index launcher:(LLCircleLauncher *)launcher{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
        _index = index;
		_borderColor = borderColor;
        _launcher = launcher;
		self.userInteractionEnabled = NO;
        
		[self draw];
	}
	return self;
}

- (void)draw {
	CALayer *layer = self.layer;
	[layer setBorderWidth:2.0];
	[layer setBorderColor:_borderColor.CGColor];
	[layer setCornerRadius:CGRectGetHeight(self.frame) / 2];
	[layer setMasksToBounds:YES];
}

#pragma mark - animation

- (void)animationFrom:(CGPoint)fromValue to:(CGPoint)toValue withDuration:(NSTimeInterval)duration {
	self.startValue = fromValue;
	self.endValue = toValue;
	self.totaltime = duration;
	self.scaleStartValue = 0.3;
	self.transform = CGAffineTransformMakeScale(self.scaleStartValue, self.scaleStartValue);
    
	self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
	self.startTime = CACurrentMediaTime();
	[self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation {
	if (self.link) {
		[self.link invalidate];
//		[self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
}

#pragma mark - private

- (void)updateValue:(CADisplayLink *)link {
	float dt = ([link timestamp] - self.startTime) / self.totaltime;
    if (dt >= 2.0) {
        [self.launcher releaseCircle:self];
        return;
    }
    
	//move
	CGFloat dx = (self.endValue.x - self.startValue.x) * link.duration / self.totaltime;
	CGFloat dy = (self.endValue.y - self.startValue.y) * link.duration / self.totaltime;
	CGPoint dPoint = CGPointMake(self.center.x + dx, self.center.y + dy);
	self.center = dPoint;
    
	//scale
	CGFloat dScaleX = self.scaleStartValue + (1 - self.scaleStartValue) * dt;
	CGFloat dScaleY = self.scaleStartValue + (1 - self.scaleStartValue) * dt;
	self.transform = CGAffineTransformMakeScale(dScaleX, dScaleY);
}

@end
