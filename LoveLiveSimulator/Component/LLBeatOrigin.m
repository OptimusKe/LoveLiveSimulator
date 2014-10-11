//
//  LLBeatOrigin.m
//  LoveLiveSimulator
//
//  Created by OptimusKe on 2014/10/11.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLBeatOrigin.h"

@implementation LLBeatOrigin

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
		self.image = image;
        
		NSRunLoop *runloop = [NSRunLoop currentRunLoop];
		[runloop addTimer:[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(runCircleAnimation) userInfo:nil repeats:YES] forMode:NSDefaultRunLoopMode];
		[runloop addTimer:[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(runScaleAnimation) userInfo:nil repeats:YES] forMode:NSDefaultRunLoopMode];
	}
	return self;
}

#pragma mark - Circle

- (void)runCircleAnimation {
	CAShapeLayer *circleShape = [self circleLayer];
	CAShapeLayer *circleShape2 = [self circleLayer];
	[self.layer addSublayer:circleShape];
	[self.layer addSublayer:circleShape2];
    
	[circleShape addAnimation:[self circleAnimationWithDelay:0] forKey:nil];
	[circleShape2 addAnimation:[self circleAnimationWithDelay:0.2] forKey:nil];
}

- (CAShapeLayer *)circleLayer {
	UIColor *stroke = [UIColor blueColor];
    
	CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:CGRectGetWidth(self.bounds) / 2];
    
	CGPoint shapePosition = [self convertPoint:self.center fromView:self.superview];
    
	CAShapeLayer *circleShape = [CAShapeLayer layer];
	circleShape.path = path.CGPath;
	circleShape.position = shapePosition;
	circleShape.fillColor = [UIColor clearColor].CGColor;
	circleShape.opacity = 0;
	circleShape.strokeColor = stroke.CGColor;
	circleShape.lineWidth = 3;
	return circleShape;
}

- (CAAnimation *)circleAnimationWithDelay:(NSTimeInterval)delay {
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1)];
    
	CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.fromValue = @1;
	alphaAnimation.toValue = @0;
    
	CAAnimationGroup *animation = [CAAnimationGroup animation];
	animation.animations = @[scaleAnimation, alphaAnimation];
	animation.duration = 0.5f;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	animation.beginTime = CACurrentMediaTime() + delay;
	return animation;
}

#pragma mark - Scale

- (void)runScaleAnimation {
	[self.layer addAnimation:[self scaleAnimation] forKey:nil];
}

- (CAAnimation *)scaleAnimation {
	CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleUp.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	scaleUp.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
	scaleUp.duration = 1.0;
    
	CABasicAnimation *scaleDown = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleDown.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
	scaleDown.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	scaleDown.beginTime = 1.0;
	scaleDown.duration = 1.0;
    
	CAAnimationGroup *animation = [CAAnimationGroup animation];
	animation.animations = @[scaleUp, scaleDown];
	animation.duration = 2.0f;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	return animation;
}

@end
