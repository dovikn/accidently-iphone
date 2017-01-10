//
//  BumpViewLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BumpViewLeaf.h"


@implementation BumpViewLeaf


@synthesize nameField;
@synthesize phoneField;
@synthesize emailField;
@synthesize bumpButton;
@synthesize cancelButton;
@synthesize listData;
@synthesize typesListData;
@synthesize nameLabel;
@synthesize phoneLabel;;
@synthesize reportTitle;
@synthesize emailLabel;
@synthesize naviBar;
@synthesize bumpObject;
@synthesize scrollView;


// the main dictionary
NSMutableDictionary *dictionary;

/**
 ** viewDidLoad
 **/
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//load Data from .plist before presenting the page
	[self loadDataFromFile];
	    
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
    
    UIImage *image =[UIImage imageNamed:@"red"];
	
	// Set the color of the navigation bar to black
	[naviBar setTintColor:[UIColor blackColor]];
	
	// Set the color of the labels to White
	UILabel *nLabel = [self nameLabel]; 
	nLabel.textColor = [UIColor whiteColor];
	[nLabel setFont:[UIFont boldSystemFontOfSize:20]];
	
	UILabel *pLabel	= [self phoneLabel]; 
	pLabel.textColor = [UIColor whiteColor];
	[pLabel setFont:[UIFont boldSystemFontOfSize:20]];
	
    
    
	UILabel *eLabel	= [self emailLabel]; 
	eLabel.textColor = [UIColor whiteColor];
	[eLabel setFont:[UIFont boldSystemFontOfSize:20]];
	
	[nLabel release];
	[pLabel release];
    [eLabel release];
    
    // Enable Scrolling 
    [scrollView setScrollEnabled:YES]; 
    [scrollView setContentSize:CGSizeMake(320, 700)];
    
    /**
     * Initialize bump Objectt
     **/ 
    bumpObject = [BumpAPI sharedInstance];
	
}

/**
 * Ensures that when you are done editing the keyboard disappears
 **/
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}


/**
 * Touch the background to make the keyboard disappear
 **/
// 
-(IBAction) backgroundTap: (id)sender {
    [nameField resignFirstResponder];
	[phoneField resignFirstResponder];
	[emailField resignFirstResponder];
    
}

// Get the accidently .plist file in the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

/**
 ** Load data from the plist file
 **/
-(void) loadDataFromFile {
	
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		return;
	}
	
	// if file exists, load Dictionary from file.
	// Load the Dictionary 
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		return;
	}

	
	// Populate data from  Dictionary 
	NSMutableDictionary *person = (NSMutableDictionary *)[dictionary objectForKey:@"Accidently-My-Contact"];
    
    
    if (person == nil) {
        return;
    }
    
    self.nameField.text =  [person objectForKey:@"p_name"];
    self.phoneField.text = [person objectForKey:@"p_phone"];
    self.emailField.text = [person objectForKey:@"p_email"];
    
    
    // Loading  list data and types list data
	NSString *key = @"Accidently-";
	NSString *keyNames =@"";
	NSString *keyTypes =@"";
	
	key = [key stringByAppendingString:reportTitle];
	keyNames = [key stringByAppendingString:@"-OtherPeopleListData"];
	keyTypes = [key stringByAppendingString:@"-OtherPeopleTypesListData"];
	
	// Populate data from  Dictionary 
	listData = [dictionary objectForKey:keyNames];
	
	if (listData == nil) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.listData = array;
		[array release];
	}
	
	typesListData = [dictionary objectForKey:keyTypes];
	
	if (typesListData == nil) {
		NSMutableArray *tArray = [[NSMutableArray alloc] init];
		self.listData = tArray;
		[tArray release];
	}

                            
}

/**
 ** Save data to the plist file
 **/
-(void) saveDataToFile {
	
	// if there is nothing to save (an alert was presented for that earlier on)
  	if (nameField.text == nil) {
		return;
	}
	
		
	// In  case the dictionary is nil, initiate it.
	if (dictionary == nil) {
		dictionary =[[NSMutableDictionary alloc] init];
	}
	
	// Create the contact object for the owner's contact
	NSMutableDictionary *person = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								   nameField.text,    @"p_name",
								   @"self",           @"p_type",
								   phoneField.text,   @"p_phone",
								   emailField.text,   @"p_email", 
								   nil];
	
	
	// Add the contact to the dictionary (there is only 1 contact called My-Contact)
	NSString *cKey = [[NSString alloc] initWithString:@"Accidently-My-Contact"];
	[dictionary setValue:person forKey:cKey];
	
	//Persist the  contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
    
    
	BOOL res = [dictionary writeToFile:dataFile atomically:YES];
	if (res == NO) {
		NSLog(@"[ERROR]: While saving the owner's information,  Failed to save data to Accidently.plist file!");
	}
}

/**
 ** Save the information and call Bump
 **/ 
-(IBAction) saveAndBump: (id)sender {
    
    if ([self.nameField.text length] == 0 ) {
        UIAlertView *warning = [[UIAlertView alloc]
                                         initWithTitle:@"Alert!"
                                         message:@"Please add your name in the designated field to continue."
                                         delegate: self
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles:nil];
		[warning show];
		[warning release];
        return;
        
    }
    
    
	// Save the data
	[self saveDataToFile];
    
    //config user name:
    [bumpObject configUserName:self.nameField.text];
	
	//Add a call to Bump
	[self startBump];
}

/**
 *  Bump
 **/

-(void) configBump{
	[bumpObject configAPIKey:@"f152d98eb4d54cb7be62980e648a5272"];
	[bumpObject configDelegate:self];
	[bumpObject configParentView:self.view];
	[bumpObject configActionMessage:@"Accidently will save the other bumper's contact information to the 'Other people involved' section."];
}

- (void) startBump{
	[self configBump];
	[bumpObject requestSession];
}

/**
 ** Bump API Delegate
 **/ 
-(void) bumpSessionStartedWith:(Bumper *)otherBumper{
   
    // Following a successful bump - this method is called. It prompts the sendData call.
    
     NSLog(@"[DEBUG] While bumping using the Accidently iPhone App, bumpSessionStartedWith was called!");
    
    /**
     ** Sending data
     **/
    
    NSMutableDictionary *myInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                        self.nameField.text,    @"p_name",
                        @"Other",               @"p_type",
                        self.phoneField.text,   @"p_phone",
                        self.emailField.text,         @"p_email", 
                        nil];

    
    // Converting the data to NSData
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject: myInfo forKey:@"bump information"];
    [archiver finishEncoding];
    [archiver release]; 
    
    [bumpObject sendData:data];
}

-(void) bumpSessionFailedToStart:(BumpSessionStartFailedReason)reason {
    // here the user cancelled the bump session.
    NSLog(@"[WARNING] While bumping the Accidently iPhone App, the bump session failed to start [BumpSessionStartFailedReason], hence Accidently will be closing bump!");
    
   
    //closing this window.
   [self dismissModalViewControllerAnimated:YES];	

}
-(void) bumpSessionEnded:(BumpSessionEndReason)reason {
    NSLog(@"[WARNING] While bumping the Accidently iPhone App, bumpSessionEnded was called! The reason was %@", reason);
}

-(void) bumpDataReceived:(NSData *)chunk {
    // When data is received    
   NSLog(@"[DEBUG] While bumping using the Accidently iPhone App, bumpDataReceived was called!");    
    
    //Validatet that the other bumper is not empty
    if (chunk == nil) {
        
        NSLog(@"[WARNING] received chunk was found empty");     
        return;
    }
   
    
    NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:chunk];
    
    NSMutableDictionary *otherBumpersInfo = [unarchiver decodeObjectForKey:@"bump information"]; 
    [unarchiver finishDecoding];
    [unarchiver release];

   
    /**
     ** Check if the other bumper's information is valid.
     **/  
    NSString *uName = [otherBumpersInfo objectForKey:@"p_name"];
    
    if ( (uName == nil) || ([uName length] == 0 )) {
        
        UIAlertView *nilNameWarning = [[UIAlertView alloc]
                                       initWithTitle:@"Alert!"
                                       message:@"Apologies, the other bumper's information is invalid! please try bumping again."
                                       delegate: self
                                       cancelButtonTitle: @"OK"
                                       otherButtonTitles:nil];
		[nilNameWarning show];
		[nilNameWarning release];
        return;
    }
    
    
    /**
     ** Check if the other bumper's information already exist.
     **/
    //
    NSString *cKey = [[NSString alloc] initWithString:@"Contact-"];
    cKey = [cKey stringByAppendingString: uName];
    
    BOOL userExists =  [dictionary containsObject: uName];
    if (userExists) {
        UIAlertView *userExistsWarning = [[UIAlertView alloc]
                                          initWithTitle:@"Alert!"
                                          message:@"Apologies, the other bumper's information already exists in Accidently!"                                    delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles:nil];
		[userExistsWarning show];
		[userExistsWarning release];   
        return;
    }

    
    // Add the person to the list
    NSMutableDictionary *person = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            [otherBumpersInfo objectForKey:@"p_name"],    @"p_name",
                                           @"Other",      @"p_type",
			[otherBumpersInfo objectForKey:@"p_phone"],   @"p_phone",
			[otherBumpersInfo objectForKey:@"p_email"],   @"p_email", 
                                   nil];
    
    [dictionary setValue:person forKey:cKey];
	
    NSString *key = @"Accidently-";
	NSString *keyNames =@"";
	NSString *keyTypes =@"";
	
	key = [key stringByAppendingString:reportTitle];
	keyNames = [key stringByAppendingString:@"-OtherPeopleListData"];
	keyTypes = [key stringByAppendingString:@"-OtherPeopleTypesListData"];
	
    
    
	// add contact to the list data
	if(listData ==nil) {
		listData = [[NSMutableArray alloc] init];
	}
	[listData addObject:uName];
	[dictionary setValue:listData forKey: keyNames];
	
	// add contact to the types list data:
	if(typesListData ==nil) {
		typesListData = [[NSMutableArray alloc] init];
	}
	
	// add contact to list data and save it to the dictionary
	[typesListData addObject:@"Other"];
	[dictionary setValue:typesListData forKey:keyTypes];
	
	//Persist the  contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
    
    
	BOOL res = [dictionary writeToFile:dataFile atomically:YES];
	if (res == NO) {
		NSLog(@"[ERROR]: While saving information about a person received via Bump,  Accidently, Failed to save data to Accidently.plist file!");
	}

    // close the Bump window
    [self dismissModalViewControllerAnimated:YES];
}

/**
 ** Is internet Connection Available
 **/
-(BOOL) isInternetConnectionAvailable {
    return YES;
}

/**
 ** Click the cancel Button 
 **/
-(IBAction) cancel: (id)sender {
	//navigate back to the parent
	[self dismissModalViewControllerAnimated:YES];	
}

/**
 ** Memory Warning!
 **/

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    
	NSLog(@"[WARNING] While bumping, Accidently received a memory warning!");
	
    // saving and existing.
    [self saveDataToFile];
 
}

- (void)viewDidUnload {
    [super      viewDidUnload];
	nameField       = nil;
    phoneField      = nil;
	listData        = nil;
	typesListData   = nil;
	cancelButton    = nil;
	nameLabel       = nil;
	phoneLabel      = nil;
	emailField      = nil;
	emailLabel      = nil;
	reportTitle     = nil;
	scrollView      = nil;
    naviBar         = nil;
}


- (void)dealloc {

	[nameField      release];
	[phoneField     release];
	[listData       release];
	[typesListData  release];
	[bumpButton     release];
	[cancelButton   release];
	[nameLabel      release];
	[phoneLabel     release];
	[emailField     release];
	[emailLabel     release];
	[reportTitle    release];
    [scrollView     release];
    [naviBar        release];
    [super          dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
