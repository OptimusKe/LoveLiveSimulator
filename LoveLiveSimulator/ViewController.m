//
//  ViewController.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/2.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "ViewController.h"
#import "LLAvatarView.h"
#import "LLNote.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    NSLog(@"viewDidLayoutSubviews");
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    CGSize frameSize = [self rotatedViewSize];
    CGFloat borderWidth = 50;
    LLNote* note = [[LLNote alloc] initWithFrame:CGRectMake((frameSize.width - borderWidth) / 2, 20, borderWidth, borderWidth) image:[UIImage imageNamed:@"note"]];
    [self.view addSubview:note];

    
    LLAvatarView* avatar = [[LLAvatarView alloc] initWithFrame:CGRectMake(50, 50, 100, 100) image:[UIImage imageNamed:@"avatar"] borderColor:[UIColor blackColor]];
//    [self.view addSubview:avatar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - 

- (CGSize)rotatedViewSize
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
    
    float max = MAX(self.view.bounds.size.width, self.view.bounds.size.height);
    float min = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
    return (isPortrait ?
            CGSizeMake(min, max) :
            CGSizeMake(max, min));
}

@end
