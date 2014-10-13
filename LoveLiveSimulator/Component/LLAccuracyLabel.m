//
//  LLAccuracyLabel.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/13.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLAccuracyLabel.h"

@implementation LLAccuracyLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:25.0];
    }
    return self;
}

#pragma mark - animation

- (void)showAccuracyAnimationWithText:(NSString *)accuracy {
    self.text = accuracy;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{
        //Delay and disappear
        [UIView animateWithDuration:0.1 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations: ^{
            self.alpha = 0;
        } completion: ^(BOOL finished) {
            NSLog(@"animations:%@", self.layer.animationKeys);
        }];
    }];
    self.alpha = 1;
    [self.layer addAnimation:[self animation] forKey:@"accuracy"];
    [CATransaction commit];
}

#pragma mark - private

- (CAAnimation *)animation {
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleUp.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1)];
    scaleUp.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.fromValue = @0;
    fadeIn.toValue = @1;
    
    CAAnimationGroup *sequence = [CAAnimationGroup animation];
    sequence.animations = @[scaleUp, fadeIn];
    sequence.duration = 0.2;
    sequence.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return sequence;
}

@end
