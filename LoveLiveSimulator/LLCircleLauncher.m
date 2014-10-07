//
//  LLCircleLauncher.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/7.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLCircleLauncher.h"

@interface LLCircleLauncher ()

@property (strong, nonatomic) NSMutableArray *circleArray;

@end

@implementation LLCircleLauncher

+ (LLCircleLauncher *)sharedIntance {
	static dispatch_once_t pred;
	static LLCircleLauncher *shared = nil;
    
	//init
	dispatch_once(&pred, ^{
	    shared = [[super alloc] init];
	    shared->_circleArray = [NSMutableArray array];
	});
    
	return shared;
}

#pragma mark - 

- (void)launchCircleWithWidth:(CGFloat)borderWidth color:(UIColor *)borderColor index:(int)index duration:(CGFloat)timeDuration centerView:(LLNote *)centerView targetAvatar:(UIView *)targetAvatar {
	LLCircle *circle = [[LLCircle alloc] initWithFrame:CGRectMake(0, 0, borderWidth, borderWidth) circle:borderColor index:index launcher:self];
	circle.center = centerView.center;
	[centerView.superview addSubview:circle];
	[circle animationFrom:centerView.center to:targetAvatar.center withDuration:timeDuration];
    [self.circleArray addObject:circle];
}

- (void)releaseCircle:(LLCircle *)circle{
    [circle stopAnimation];
    [circle removeFromSuperview];
    [self.circleArray removeObject:circle];
}

- (void)checkCircleTouchMatchAvatar:(LLAvatarView *)avatar{
    
    LLCircle *touchedCircle = nil;
    
    for(LLCircle *circle in self.circleArray){
        
        if(!CGRectIsNull(CGRectIntersection(avatar.frame, circle.frame)) ){
            [avatar runCircleAnimation];
            touchedCircle = circle;
        }
    }
    
    if(touchedCircle){
        [self releaseCircle:touchedCircle];
    }
    
}

@end
