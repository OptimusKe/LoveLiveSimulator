//
//  LLBeatManager.h
//  LoveLiveSimulator
//
//  Created by OptimusKe on 2014/10/11.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLBeatCircle.h"
#import "LLBeaterView.h"
#import "LLBeatOrigin.h"

@protocol AccuracyJudgeDelegate <NSObject>
@required
- (void)accuracyJudge:(NSString *)accuracy;
- (void)showCombo:(int)combo;
@end

#define BeatManager [LLBeatManager sharedIntance]

@interface LLBeatManager : NSObject

@property (nonatomic, assign) id <AccuracyJudgeDelegate> accuracyDelegate;

+ (LLBeatManager *)sharedIntance;

- (void)launchCircleWithWidth:(CGFloat)borderWidth color:(UIColor *)borderColor index:(int)index duration:(CGFloat)timeDuration centerView:(LLBeatOrigin *)centerView targetBeater:(UIView *)targetBeater;
- (void)releaseCircle:(LLBeatCircle *)circle;
- (void)checkCircleTouchMatchBeater:(LLBeaterView *)beater;

@end
