//
//  LLComboLabel.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/13.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLComboLabel.h"

@implementation LLComboLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:25.0];
    }
    return self;
}

- (void)showComboAnimationWithValue:(int)combo {
    if (combo > 0) {
        self.text = [NSString stringWithFormat:@"%d Combo", combo];
        [self.layer addAnimation:[self animation] forKey:@"combo"];
    }
    else {
        self.text = @"";
    }
}

#pragma mark - private

- (CAAnimation *)animation {
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleUp.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1)];
    scaleUp.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.fromValue = @0;
    fadeIn.toValue = @1;
    
    CAAnimationGroup *sequence = [CAAnimationGroup animation];
    sequence.animations = @[scaleUp, fadeIn];
    sequence.duration = 0.2;
    sequence.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return sequence;
}

@end
