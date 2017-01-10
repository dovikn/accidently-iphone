//
//  Accident_lyAppDelegate.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/22/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportsViewController.h"
#import "Utilities.h"
#define kFileName @"accidently.plist"

@interface Accident_lyAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow				*window;
    UINavigationController	*navigationController;
	NSMutableDictionary		*reportSentStatus;
}

@property (nonatomic, retain) IBOutlet UIWindow					*window;
@property (nonatomic, retain) IBOutlet UINavigationController	*navigationController;
@property (nonatomic, retain) NSMutableDictionary				*reportSentStatus;

-(void) runMe;

@end

