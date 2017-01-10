
//  RootViewController.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/22/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"



@implementation RootViewController

@synthesize listData;
@synthesize imageView;
@synthesize otherDriverView; 
@synthesize otherPeopleView;
@synthesize todoView;
@synthesize background;
@synthesize reportTitle;
@synthesize shareView;
@synthesize mustView;
@synthesize generalView;
@synthesize profsView;
@synthesize bumpObject;
@synthesize bumpView;
@synthesize tipPresented;
// the main dictionary
NSMutableDictionary *dictionary;

/**
 ** viewDidLoad
 **/ 
- (void)viewDidLoad {
    [super viewDidLoad];
	 NSArray *array = [[NSArray alloc] initWithObjects:@"Top Priority",
					   @"Basic Information",
					   @"Other Driver/Vehicle", 
					   @"Other People Involved",
                       @"Contact Professionals",
					   @"Notes" ,
					   @"Pictures", 
                       @"Bump to connect",
					   @"Share", 
					   nil];
	 self.listData = array;
	 self.title = @"Sections";

	// Set the background image
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	UINavigationBar *navBar = [self.navigationController navigationBar];
	[navBar setTintColor:[UIColor blackColor]];
	[array release];
	
    //loadDataFromFile
    [self loadDataFromFile];
    
    if (tipPresented == nil || [tipPresented length]== 0) {
    
            UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Tip!" 
						  message:@"Fill out the 'Top Priority' section first and then send the report via email. All other sections can be filled out later." 
						  delegate:nil 
						  cancelButtonTitle:@"Okay" 
						  otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        // set tipPresented to the dictionary
        NSString *tKey = @"Accidently-"; 
        tKey = [tKey stringByAppendingString: reportTitle];
        tKey = [tKey stringByAppendingString: @"-tipPresented"];
        [dictionary setObject:@"YES" forKey:tKey];
        
        // Persist the dictionary
        [self saveDataToFile];
    }
        
    
    /**
     * Initialize bump Objectt
     **/ 
    bumpObject = [BumpAPI sharedInstance];
    
}

/**
 ** Get the accidently .plist file
 **/
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}


/**
 ** loadDataFromFile (specifically - was the tip presented)
 **/
-(void) loadDataFromFile {
	
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		NSLog(@"[WARNING] Failed to load the accidently.plist file");
        return;
	}
	
	// if file exists, load Dictionary from file.
	dictionary = (NSMutableDictionary *) [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		dictionary = [[NSMutableDictionary alloc] init];
    }
    NSString *tKey = @"Accidently-"; 
    
    // if the reportTitle is empty, get it from the dictionary.
    if (reportTitle == nil) {
        reportTitle = [dictionary objectForKey:@"Accidently-ActiveReport"];
    }
    
    tKey = [tKey stringByAppendingString: reportTitle];
    tKey = [tKey stringByAppendingString: @"-tipPresented"];
    tipPresented = [dictionary objectForKey:tKey];
}

/**
 ** saveDataToFile
 **/ 
- (void) saveDataToFile {
    
    //get the accidently.plist file
	NSString *dataFile = [self dataFilePath];
    
    // persist the dictionary
	BOOL res = [dictionary writeToFile:dataFile atomically:YES];
	if (res == NO) {
		NSLog(@"[ERROR]: While saving  the tipPresented flag for report: %@, Failed to save data to Accidently.plist file!", reportTitle);	
    }
}

-(void) showEmailModalView {
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
	//Change the text color to White
	cell.textLabel.textColor = [UIColor whiteColor]; 
	
	// Display disclosure button
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [listData objectAtIndex: row];
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row]; 
	
	if (row == 0) {
		
		if (mustView == nil) {
			mustView = [[MustHavesView alloc] initWithNibName:@"MustHavesView" bundle:nil];
		}
		mustView.reportTitle = self.reportTitle;
		[self.navigationController pushViewController:mustView animated:YES];
	}
	
	
	if (row == 1) {
	
		if (generalView  == nil) {
			generalView = [[GeneralDetailedView alloc] initWithNibName:@"GeneralDetailedView" bundle:nil];
		}
		generalView.reportTitle = self.reportTitle;
		[self.navigationController pushViewController:generalView animated:YES];
	}
	
	if (row == 2) {
		
		if (otherDriverView == nil) {
			otherDriverView = [[OtherDriverViewController alloc] initWithNibName:@"OtherDriverViewController" bundle:nil];
		}
		otherDriverView.reportTitle = self.reportTitle;
		[self.navigationController pushViewController:otherDriverView animated:YES];
	}
	
	// Other people involved
	if (row == 3) {
		
		if (otherPeopleView == nil) {
			otherPeopleView = [[OtherPeopleViewController alloc] initWithNibName:@"OtherPeopleViewController" bundle:nil];
		}
		otherPeopleView.reportTitle = self.reportTitle;
		[self.navigationController pushViewController:otherPeopleView animated:YES];
	}
    
    // Contact Professionals
	if (row == 4) {
		
		if (profsView == nil) {
			profsView = [[ContactProfessionalsViewController alloc] initWithNibName:@"ContactProfessionalsViewController" bundle:nil];
		}
		profsView.reportTitle = self.reportTitle;
		[self.navigationController pushViewController:profsView animated:YES];
	}

	
	// todos
	if (row == 5) {
		
		if (todoView == nil) {
			todoView = [[TodoViewController alloc] initWithNibName:@"TodoViewController" bundle:nil];
		}
		todoView.reportTitle = self.reportTitle;
		[self.navigationController pushViewController:todoView animated:YES];
	}
	
	// The Pictures tab
	if (row == 6) {
		
		if (imageView == nil) {
			imageView = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
		}
		imageView.reportTitle = self.reportTitle;
		[self presentModalViewController:imageView animated:YES];  
	}
    
    // Run Bump to connect
    
    if (row == 7) {
        
        if (bumpView == nil) {
            bumpView= [[BumpViewLeaf alloc] initWithNibName:@"BumpViewLeaf" bundle:nil];
		}
		bumpView.reportTitle = self.reportTitle;
		[self presentModalViewController:bumpView animated:YES];  
  
    }	
	// the email:
	if (row == 8) {
		
		// check for internet Connectivity 
		if ([self isInternetConnectionAvailable] == NO) {
			// alert - must fill out a name
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Alert!"
								  message:@"Looks like the device that you are using is not currently connected to the Internet. Please check your Internet connection and try again."
								  delegate: self
								  cancelButtonTitle: @"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		} else {
		
			if (shareView == nil){	
				shareView = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil]; 
			}
			shareView.reportTitle = self.reportTitle;
			[self.navigationController pushViewController:shareView animated:YES];
		}
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}   

- (BOOL) isInternetConnectionAvailable{
	
	NSString *connectionString = [[NSString alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:@"http://google.com"]];
	if ([connectionString length] == 0) {
		return NO;
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While displaying the root view, Accidently received  a memory warning!");
    [super didReceiveMemoryWarning];
}

/**
 *  Bump
 **/

-(void) configBump{
	[bumpObject configAPIKey:@"f152d98eb4d54cb7be62980e648a5272"];
	[bumpObject configDelegate:self];
	[bumpObject configParentView:self.view];
	[bumpObject configActionMessage:@"Bump away."];
}

- (void) startBump{
	[self configBump];
	[bumpObject requestSession];
}


- (void)viewDidUnload {
    profsView       = nil;
	self.listData   = nil;
	generalView     = nil;
	imageView       = nil;
	otherDriverView = nil;
	otherPeopleView = nil;
	todoView        = nil;
	background      = nil;
	reportTitle     = nil;
	shareView       = nil;
	mustView        = nil; 
    bumpObject      = nil;
    bumpView        = nil;
    tipPresented    = nil;
}

- (void)dealloc {
    [profsView          release];
	[generalView        release];
	[imageView          release];
	[otherDriverView    release];
	[listData           release];
	[otherPeopleView    release];
	[todoView           release];
	[background         release];
	[reportTitle        release];
	[shareView          release];
	[mustView           release];
    [bumpObject         release];
    [bumpView           release];
    [tipPresented       release];
	[super              dealloc];
}


-(void) bumpSessionStartedWith:(Bumper *)otherBumper{
    NSLog(@"[WARNING] While bumping the Accidently iPhone App, bumpSessionStartedWith was called!");

}

-(void) bumpSessionFailedToStart:(BumpSessionStartFailedReason)reason {
    // here the user cancelled the bump session.
    NSLog(@"[WARNING] While bumping the Accidently iPhone App, the user chose to cancel the bump session, hence Accidently will be closing bump!");
}
-(void) bumpSessionEnded:(BumpSessionEndReason)reason {
    NSLog(@"[WARNING] While bumping the Accidently iPhone App, bumpSessionEnded was called!");
}

-(void) bumpDataReceived:(NSData *)chunk {
    NSLog(@"[WARNING] While bumping the Accidently iPhone App, bumpDataReceived was called!"); 
    // need to add the data to the system.
}


@end
