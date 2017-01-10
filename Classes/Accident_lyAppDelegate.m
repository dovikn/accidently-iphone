//
//  Accident_lyAppDelegate.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/22/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Accident_lyAppDelegate.h"

@implementation Accident_lyAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize reportSentStatus;
NSMutableDictionary *dictionary;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	sleep(2);
	
    // set badge
    Utilities* ut = [[Utilities alloc] init ];
	NSInteger badgeNumber = [ut  numberOfPendingReports];
	[[UIApplication  sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
    [ut release];
	
	
	// Override point for customization after app launch    
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	// runMe is a plug in method to run fixes if necessary
    [self runMe];
	return YES;
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[navigationController facebook] handleOpenURL:url];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// set badge
    Utilities* ut = [[Utilities alloc] init ];
	NSInteger badgeNumber = [ut  numberOfPendingReports];
	[[UIApplication  sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
    [ut release];
}

// Get the accidently .plist file in the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}


/**
 ** Plug in content before the application loads
 **/
-(void) runMe {
    // Initialize the data (set a common ground) 
    Utilities *ut = [[Utilities alloc] init]; 
    [ut initialize: NO];

    //[ut printDictionary:dictionary];
    //[ut reset:YES];
    [ut release];
}

- (void)dealloc {
	[navigationController	release];
	[window					release];
	[reportSentStatus		release];
	[super					dealloc];
}


@end

