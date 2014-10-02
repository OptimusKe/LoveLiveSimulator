//
//  LLAvatarView.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/2.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "LLAvatarView.h"

@interface LLAvatarView ()

@property (nonatomic) UIColor* borderColor;

@end

@implementation LLAvatarView



- (id)initWithFrame:(CGRect)frame image:(UIImage *)image borderColor:(UIColor*)borderColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        _borderColor = borderColor;
        [self draw];
    }
    return self;
}

- (void)draw
{
    CALayer *layer = self.layer;
    [layer setBorderWidth:2.0];
    [layer setBorderColor:_borderColor.CGColor];
    [layer setCornerRadius:CGRectGetHeight(self.frame) / 2];
    [layer setMasksToBounds:YES];
}

@end
