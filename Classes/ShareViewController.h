//
//  ShareViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "SendMailView.h"
#import "TwitterViewLeaf.h"


@interface ShareViewController : UITableViewController <FBSessionDelegate, FBRequestDelegate, FBDialogDelegate> {    
	NSArray             *listData; 
	NSString            *reportTitle;
    SendMailView        *mailView;
    TwitterViewLeaf     *twitterView;
    NSUserDefaults      *defaults;
    
    
    //Facebook
    Facebook            *facebook;
    NSArray             *permissions;
    BOOL                userIsLoggedIn;
}

@property (nonatomic, retain) NSArray           *listData;
@property (nonatomic, retain) NSString          *reportTitle;
@property (nonatomic, retain) SendMailView      *mailView;
@property (nonatomic, retain) TwitterViewLeaf   *twitterView;
@property (nonatomic, retain) NSUserDefaults    *defaults;
//Facebook
@property (readonly)          Facebook          *facebook;
@property (nonatomic, retain) NSArray           *permissions;

- (void) fbDidLogin;
- (void) fbDidNotLogin:(BOOL)cancelled;
- (void) fbDidLogout;
- (IBAction) postMessageOnFacebookWall: (id) sender;

@end
