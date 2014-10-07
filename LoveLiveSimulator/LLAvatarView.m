//
//  LLAvatarView.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/2.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLAvatarView.h"

@interface LLAvatarView ()

@property (nonatomic) UIColor *borderColor;
@property (nonatomic, strong) CAShapeLayer *circleShape;
@property (nonatomic, assign) id <AvatarTouchDelegate> touchDelegate;

@end

@implementation LLAvatarView



- (id)initWithFrame:(CGRect)frame image:(UIImage *)image borderColor:(UIColor *)borderColor touch:(id <AvatarTouchDelegate> )touchDelegate {
	self = [super initWithFrame:frame];
	if (self) {
		_touchDelegate = touchDelegate;
        
		//add image
		CALayer *imageLayer = [CALayer layer];
		imageLayer.contents = (id)image.CGImage;
		imageLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
		imageLayer.cornerRadius = CGRectGetHeight(self.frame) / 2;
		imageLayer.masksToBounds = YES;
		[self.layer addSublayer:imageLayer];
        
		self.userInteractionEnabled = YES; //make UIGestureRecognizer work
		_borderColor = borderColor;
		[self draw];
	}
	return self;
}

- (void)draw {
	CALayer *layer = self.layer;
	layer.borderWidth = 2.0;
	layer.borderColor = _borderColor.CGColor;
	layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
	//這邊避免用[layer setMasksToBounds:YES]; 用了在貼上circleShape 會被mask
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.touchDelegate touch:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

#pragma mark - Circle animation

- (void)runCircleAnimation {
	if (!self.circleShape) {
		self.circleShape = [self circleLayer];
		[self.layer addSublayer:self.circleShape];
	}
    
	[self.circleShape addAnimation:[self circleAnimationWithDelay:0] forKey:nil];
}

- (CAShapeLayer *)circleLayer {
	UIColor *stroke = self.borderColor;
    
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
	animation.duration = 0.3f;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	animation.beginTime = CACurrentMediaTime() + delay;
	return animation;
}

@end
