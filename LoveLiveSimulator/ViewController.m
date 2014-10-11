//
//  ViewController.m
//  LoveLiveSimulator
//
//  Created by Jack on 2014/10/2.
//  Copyright (c) 2014年 KerKer. All rights reserved.
//

#import "ViewController.h"
#import "LLBeaterView.h"
#import "LLBeatOrigin.h"
#import "LLBeatManager.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

static const int kMaxAvatarNum = 9;
static const int kMaxColorNum  = 3;
static const int kMaxGooglePlusBestNum  = 30; //Best Top

#define colorRedSmile  [UIColor colorWithRed:242.0 / 255.0 green:115.0 / 255.0 blue:164.0 / 255.0 alpha:1]
#define colorGreenPure [UIColor colorWithRed:119.0 / 255.0 green:214.0 / 255.0 blue:110.0 / 255.0 alpha:1]
#define colorCoolBlue  [UIColor colorWithRed:81.0 / 255.0 green:209.0 / 255.0 blue:245.0 / 255.0 alpha:1]

@interface ViewController () <BeaterTouchDelegate, GPPSignInDelegate,BeaterTouchDelegate>

@property (strong, nonatomic) NSMutableArray *avatarArray;
@property (strong, nonatomic) NSArray *colorArray;
@property (strong, nonatomic) LLBeatOrigin *origin;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (strong, nonatomic) NSMutableArray *peopleList;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    
	// Make sure the GPPSignInButton class is linked in because references from
	// xib file doesn't count.
	[GPPSignInButton class];
    
	GPPSignIn *signIn = [GPPSignIn sharedInstance];
	// Set up sample view of Google+ sign-in.
	// The client ID has been set in the app delegate.
	signIn.delegate = self;
	//    signIn.shouldFetchGoogleUserEmail = userinfoEmailScope_.on;
	signIn.actions = [NSArray arrayWithObjects:
	                  @"http://schemas.google.com/AddActivity",
	                  @"http://schemas.google.com/BuyActivity",
	                  @"http://schemas.google.com/CheckInActivity",
	                  @"http://schemas.google.com/CommentActivity",
	                  @"http://schemas.google.com/CreateActivity",
	                  @"http://schemas.google.com/ListenActivity",
	                  @"http://schemas.google.com/ReserveActivity",
	                  @"http://schemas.google.com/ReviewActivity",
	                  nil];
    
	[signIn trySilentAuthentication];
    
	// Do any additional setup after loading the view, typically from a nib.
	self.colorArray = [[NSArray alloc] initWithObjects:colorRedSmile, colorGreenPure, colorCoolBlue, nil];
	self.avatarArray = [NSMutableArray array];
    
	CGSize frameSize = [self rotatedViewSize];
	CGFloat borderWidth = 50;
	self.origin = [[LLBeatOrigin alloc] initWithFrame:CGRectMake((frameSize.width - borderWidth) / 2, 20, borderWidth, borderWidth) image:[UIImage imageNamed:@"note"]];
	[self.view addSubview:self.origin];
    
    
	for (int i = 0; i < kMaxAvatarNum; i++) {
		int randomColorIndex = arc4random() % kMaxColorNum;
		LLBeaterView *beater = [[LLBeaterView alloc] initWithFrame:CGRectMake(50 + i * 40, 50, 60, 60) image:[UIImage imageNamed:@"avatar"] borderColor:[self.colorArray objectAtIndex:randomColorIndex] touch:self];
		beater.center = [self layoutArcNoteCenterWithCenter:CGPointMake(frameSize.width / 2, 50) radius:230 noteIndex:i count:kMaxAvatarNum];
		[self.avatarArray addObject:beater];
		[self.view addSubview:beater];
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

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
	if (error) {
		return;
	}
	[self listPeople:kGTLPlusCollectionVisible];
}

- (void)didDisconnectWithError:(NSError *)error {
	if (error) {
	}
	else {
	}
}

#pragma mark - Helper methods

- (void)listPeople:(NSString *)collection {
	GTMOAuth2Authentication *auth = [GPPSignIn sharedInstance].authentication;
	if (!auth) {
		// To authenticate, use Google+ sign-in button.
		return;
	}
    
	// 1. Create a |GTLQuery| object to list people that are visible to this
	// sample app.
	GTLQueryPlus *query =
    [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                    collection:collection];
	query.orderBy = @"best";
    query.maxResults = kMaxGooglePlusBestNum;
    
	// 2. Execute the query.
	[[[GPPSignIn sharedInstance] plusService] executeQuery:query
	                                     completionHandler: ^(GTLServiceTicket *ticket,
                                                              GTLPlusPeopleFeed *peopleFeed,
                                                              NSError *error) {
                                             if (error) {
                                             }
                                             else {
                                                 // Get an array of people from |GTLPlusPeopleFeed| and reload
                                                 // the table view.
                                                 
                                                 if (!self.peopleList) {
                                                     self.peopleList = [[NSMutableArray alloc] initWithCapacity:peopleFeed.items.count];
                                                     for (GTLPlusPerson * person in peopleFeed.items) {
                                                         [self.peopleList addObject:person];
                                                     }
                                                 }
                                                 
                                                 [self setAvatarImage];
                                             }
                                         }];
}

#pragma mark - action

- (void)setAvatarImage {
	//社交圈少於9人就隨機給圖
	if (self.peopleList.count < kMaxAvatarNum) {
		for (LLBeaterView *beaterView in self.avatarArray) {
			int randomImageIndex = arc4random() % self.peopleList.count;
			GTLPlusPerson *person = [self.peopleList objectAtIndex:randomImageIndex];
			[beaterView changeImage:person.image.url];
		}
	}
	else {
		//9人以上 隨機給予不重複的avatarImage
        
		//挑選不重複的person
		NSMutableArray *mutableArray = [self.peopleList mutableCopy];
		NSMutableArray *randomArray = [[NSMutableArray alloc] initWithCapacity:kMaxAvatarNum];
        
		for (int i = 0; i < kMaxAvatarNum; i++) {
			int index = arc4random_uniform(mutableArray.count);
			GTLPlusPerson *person = [mutableArray objectAtIndex:index];
			[randomArray addObject:person];
			[mutableArray removeObjectAtIndex:index];
		}
        
		for (int i = 0; i < kMaxAvatarNum; i++) {
			LLBeaterView *beaterView = [self.avatarArray objectAtIndex:i];
			GTLPlusPerson *person = [randomArray objectAtIndex:i];
			[beaterView changeImage:person.image.url];
		}
	}
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
	int randomCircleIndex = arc4random() % kMaxAvatarNum;
	int randomColorIndex = arc4random() % kMaxColorNum;
	[BeatManager launchCircleWithWidth:60 color:[self.colorArray objectAtIndex:randomColorIndex] index:randomCircleIndex duration:2.0 centerView:self.origin targetBeater:[self.avatarArray objectAtIndex:randomCircleIndex]];
}

#pragma mark - AvatarTouchDelegate

- (void)touch:(LLBeaterView *)beaterView {
	[BeatManager checkCircleTouchMatchBeater:beaterView];
}

@end
