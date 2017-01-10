//
//  ShareViewController.m
//  Accident-ly
//
//  Created by Dovik Nissim on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"

#define EXPIRATION_DATE_KEY @"ExpKey"
#define ACCESS_TOKEN_KEY @"AccessTokenKey"
static NSString * kAppId = nil;

@implementation ShareViewController

@synthesize listData;
@synthesize reportTitle;
@synthesize mailView;
@synthesize twitterView;
@synthesize facebook;
@synthesize permissions;

@synthesize defaults;

//

/**
 *  viewDidLoad
 **/
- (void)viewDidLoad {	
	[super viewDidLoad];
	NSArray *array = [[NSArray alloc] initWithObjects:	
					  @"Email Full Report", 
					  @"Post on Facebook", 
                      @"Share via Twitter",
					  nil];
	
	self.listData = array;
	self.title= @"Share";
	[array release];
    
	// Set the background image
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	UINavigationBar *navBar = [self.navigationController navigationBar];
	[navBar setTintColor:[UIColor blackColor]];
    

    /**
     * Initializing the FB portion
     */
    kAppId = @"181097828611551";
    permissions = [[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", nil] retain];
    facebook = [[Facebook alloc] initWithAppId:kAppId];

}


/**
 *  Post on Facebook wall 
 **/
- (IBAction) postMessageOnFacebookWall: (id) sender {
        
    // On login, use the stored access token and see if it still works.
   // facebook.accessToken = [defaults objectForKey: ACCESS_TOKEN_KEY];
   // facebook.expirationDate = [defaults objectForKey: EXPIRATION_DATE_KEY];
    
    // only authorize if the access token isn't valid. 
    // if it is valid, no need to authenticate
    //if (![facebook isSessionValid]) {
    //    [facebook authorize:permissions delegate:self];
    //}
   
    NSLog(@"[DEBUG] Posting a meessage on Facebook the user's Wall");  
        
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        kAppId,                                                                      @"app_id",
        @"http://accidentlyiphoneapp.blogspot.com/",                                 @"link", 
        @"http://3.bp.blogspot.com/-N-X0KIENb6Y/TaHakQjag_I/AAAAAAAAE-Q/Hig3GFLGxL0/s1600/Accidently-Icon-256x256.png",                                            @"picture", 
        @"Posted using the Accidently iPhone Application",                           @"name",
        @"The Accidently iPhone Application is an easy to use application aimed to assist you with methodically gathering necessary information during the unfortunate time of a car accident.(Download the Accidently iPhone App from the App Store at http://itunes.com/apps/accidently)",                                                  @"caption",
        @"I just got into an accident. There is no need to worry - I feel fine. Can anybody recommend a good body-shop or a good lawyer in the area?",                                     @"message",
        nil];
    [facebook dialog:@"feed" andParams:params andDelegate:self];
   }

/**
 *  Called when the user has logged in
 **/

- (void) fbDidLogin {
    NSLog(@"[DEBUG] the user is logged in to Facebook");

    // store the access token and the expiration date to the user defaults.
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:facebook.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:facebook.expirationDate forKey: EXPIRATION_DATE_KEY];
    [defaults synchronize];
    userIsLoggedIn = YES;
}

/**
 * Called when the user logout 
 **/

- (void) fbDidLogout {
   NSLog(@"[DEBUG] the user logged out of Facebook"); 
    
}

/**
 *  Called when the user has failed to login
 **/
- (void) fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"[DEBUG] the user is NOT logged in to Facebook");
    userIsLoggedIn = NO;
}

/**
 * Facebook Request delegate
 **/
-(void) request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"[DEBUG] Did receive response from facebook" );
    
}

-(void) request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"[ERROR] Facebook request failed with error %@", error);
}


-(void) request:(FBRequest *)request didLoad:(id)result{
    NSLog(@"[DEBUG] Request Did Load facebook" );
}

-(void) dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"[DEBUG] Publish successfully" ); 
}

- (void) dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"[DEBUG] Failed to Publish" );   
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	return [self.listData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString * generalIdentifier = @"GeneralIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: generalIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier: generalIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [listData objectAtIndex: row];
    
	//Change the text color to White
	cell.textLabel.textColor = [UIColor whiteColor];
    
    // Add image
    if (indexPath.row == 0) {
        UIImage *emailImage = [UIImage imageNamed: @"Email-icon-57x57.png"];
        cell.imageView.image = emailImage;
        [emailImage release];
    }
	
    if (indexPath.row == 1) {
        UIImage *facebookImage = [UIImage imageNamed: @"Facebook-icon-57x57.png"];
        cell.imageView.image = facebookImage;
        [facebookImage release];
    }
    
    if (indexPath.row == 2) {
        UIImage *twitterImage = [UIImage imageNamed: @"Twitter_512x512.png"];
        cell.imageView.image = twitterImage;
        [twitterImage release];
    }
    
    
    
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row];
	
	//The other driver
	if (row == 0) {
		if (mailView == nil) {
			mailView = [[SendMailView alloc] initWithNibName:@"SendMailView" bundle:nil];
		}
		mailView.reportTitle = self.reportTitle;
		[self presentModalViewController:mailView animated:YES];
    }
	//the other vehiclez
	if (row == 1) {
        [self postMessageOnFacebookWall:nil];
	}
    
    // The Twitter Page
    //The other driver
	if (row == 2) {
		if (twitterView == nil) {
			twitterView = [[TwitterViewLeaf alloc] initWithNibName:@"TwitterViewLeaf" bundle:nil];
		}
		[self presentModalViewController:twitterView animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While displaying sharing options (ShareViewController), Accidently received a memory warning!");
}


- (void)viewDidUnload {
	listData        = nil;
	reportTitle     = nil;
    mailView        = nil;
    facebook       = nil;
    permissions    = nil;
    defaults       = nil;
    twitterView    = nil;
}

- (void)dealloc {
	[listData       release];
	[reportTitle    release];
    [mailView       release];
    [facebook      release];
    [permissions   release];
    [defaults      release];
    [twitterView   release];
	[super          dealloc];
}
@end

