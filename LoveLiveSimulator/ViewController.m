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
#import "LLCircleLauncher.h"

#define colorRedSmile  [UIColor colorWithRed:140.0 / 255.0 green:1.0 / 255.0 blue:18.0 / 255.0 alpha:1]
#define colorGreenPure [UIColor colorWithRed:119.0 / 255.0 green:214.0 / 255.0 blue:110.0 / 255.0 alpha:1]
#define colorCoolBlue  [UIColor colorWithRed:81.0 / 255.0 green:209.0 / 255.0 blue:245.0 / 255.0 alpha:1]

@interface ViewController () <AvatarTouchDelegate>

@property (strong, nonatomic) NSMutableArray *avatarArray;
@property (strong, nonatomic) NSArray *colorArray;
@property (strong, nonatomic) LLNote *note;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.colorArray = [[NSArray alloc] initWithObjects:colorRedSmile, colorGreenPure, colorCoolBlue, nil];
	self.avatarArray = [NSMutableArray array];
    
	CGSize frameSize = [self rotatedViewSize];
	CGFloat borderWidth = 50;
	self.note = [[LLNote alloc] initWithFrame:CGRectMake((frameSize.width - borderWidth) / 2, 20, borderWidth, borderWidth) image:[UIImage imageNamed:@"note"]];
	[self.view addSubview:self.note];
    
    
	for (int i = 0; i < 9; i++) {
		int randomColorIndex = arc4random() % 3;
		LLAvatarView *avatar = [[LLAvatarView alloc] initWithFrame:CGRectMake(50 + i * 40, 50, 60, 60) image:[UIImage imageNamed:@"avatar"] borderColor:[self.colorArray objectAtIndex:randomColorIndex] touch:self];
		avatar.center = [self layoutArcNoteCenterWithCenter:CGPointMake(frameSize.width / 2, 50) radius:230 noteIndex:i count:9];
		[self.avatarArray addObject:avatar];
		[self.view addSubview:avatar];
	}
    
    
    
	NSRunLoop *runloop = [NSRunLoop currentRunLoop];
	[runloop addTimer:[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(launchCircle) userInfo:nil repeats:YES] forMode:NSDefaultRunLoopMode];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - orientation

- (CGSize)rotatedViewSize {
	BOOL isPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
    
	float max = MAX(self.view.bounds.size.width, self.view.bounds.size.height);
	float min = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
	return (isPortrait ?
	        CGSizeMake(min, max) :
	        CGSizeMake(max, min));
}

#pragma mark - note center

- (CGPoint)layoutArcNoteCenterWithCenter:(CGPoint)screenCenter radius:(CGFloat)radius noteIndex:(int)noteIndex count:(int)count {
	CGFloat averagePi = M_PI / (count - 1);
    
	CGFloat x = screenCenter.x + radius * (cosf((averagePi) * noteIndex));
	CGFloat y = screenCenter.y + radius * (sinf((averagePi) * noteIndex));
    
	return CGPointMake(x, y);
}

#pragma mark - Launch Circle

- (void)launchCircle {
	int randomCircleIndex = arc4random() % 9;
	int randomColorIndex = arc4random() % 3;
	[CircleLauncher launchCircleWithWidth:60 color:[self.colorArray objectAtIndex:randomColorIndex] index:randomCircleIndex duration:2.0 centerView:self.note targetAvatar:[self.avatarArray objectAtIndex:randomCircleIndex]];
}

#pragma mark - AvatarTouchDelegate

- (void)touch:(LLAvatarView *)avatarView {
    [CircleLauncher checkCircleTouchMatchAvatar:avatarView];
}

@end
