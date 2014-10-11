//
//  LLBeatManager.m
//  LoveLiveSimulator
//
//  Created by OptimusKe on 2014/10/11.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLBeatManager.h"

@interface LLBeatManager ()

@property (strong, nonatomic) NSMutableArray *circleArray;

@end

@implementation LLBeatManager

+ (LLBeatManager *)sharedIntance {
	static dispatch_once_t pred;
	static LLBeatManager *sharedIntance = nil;
    
	//init
	dispatch_once(&pred, ^{
	    sharedIntance = [[super alloc] init];
	    sharedIntance->_circleArray = [NSMutableArray array];
	});
    
	return sharedIntance;
}

#pragma mark -

- (void)launchCircleWithWidth:(CGFloat)borderWidth color:(UIColor *)borderColor index:(int)index duration:(CGFloat)timeDuration centerView:(LLBeatOrigin *)centerView targetBeater:(UIView *)targetBeater {
	LLBeatCircle *circle = [[LLBeatCircle alloc] initWithFrame:CGRectMake(0, 0, borderWidth, borderWidth) circle:borderColor index:index launcher:self];
	circle.center = centerView.center;
	[centerView.superview addSubview:circle];
	[circle animationFrom:centerView.center to:targetBeater.center withDuration:timeDuration];
    [self.circleArray addObject:circle];
}

- (void)releaseCircle:(LLBeatCircle *)circle{
    [circle stopAnimation];
    [circle removeFromSuperview];
    [self.circleArray removeObject:circle];
}

- (void)checkCircleTouchMatchBeater:(LLBeaterView *)beater{
    
    LLBeatCircle *touchedCircle = nil;
    
    for(LLBeatCircle *circle in self.circleArray){
        
        if(!CGRectIsNull(CGRectIntersection(beater.frame, circle.frame)) ){
            [beater runCircleAnimation];
            touchedCircle = circle;
        }
    }
    
    if(touchedCircle){
        [self releaseCircle:touchedCircle];
    }
    
}



@end
