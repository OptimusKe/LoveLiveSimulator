//
//  LLBeaterView.h
//  LoveLiveSimulator
//
//  Created by OptimusKe on 2014/10/11.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLBeaterView;

@protocol BeaterTouchDelegate <NSObject>
@required
- (void)touch:(LLBeaterView *)avatarView;
@end

@interface LLBeaterView : UIView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image borderColor:(UIColor *)borderColor touch:(id <BeaterTouchDelegate> )touchDelegate;
- (void)runCircleAnimation;
- (void)changeImage:(NSString *)imageUrl;

@end
