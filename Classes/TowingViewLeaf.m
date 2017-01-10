//
//  TowingViewLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TowingViewLeaf.h"


@implementation TowingViewLeaf
@synthesize towingCompanyNameField;
@synthesize towingCompanyPhoneNumberField;
@synthesize towingCompanyNameLabel;
@synthesize towingCompanyPhoneNumberLabel; 
@synthesize saveButton, cancelButton;
@synthesize reportTitle;
@synthesize naviBar;
@synthesize scrollView;

NSMutableDictionary *dictionary;


- (void)viewDidLoad {
    [super viewDidLoad];
	//load Data from .plist before presenting the page
	[self loadDataFromFile];
	
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	//UINavigationBar *navBar = [self.navigationController navigationBar];
	[naviBar setTintColor:[UIColor blackColor]];

	
	// Set the color of the labels to White
	UILabel *tcLabel = [self towingCompanyNameLabel]; 
	tcLabel.textColor = [UIColor whiteColor];
	[tcLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[tcLabel release];
	
	UILabel *pLabel = [self towingCompanyPhoneNumberLabel]; 
	pLabel.textColor = [UIColor whiteColor];
	[pLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[pLabel release];
    
    // Enable scrolling
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)]; 
}

-(void) save:(id) sender {
	[self saveDataToFile];
	[self dismissModalViewControllerAnimated:YES];
}


-(void) cancel:(id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	[towingCompanyNameField resignFirstResponder];
	[towingCompanyPhoneNumberField resignFirstResponder];
}


// Get the accidently .plist file in the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

// load the data from the .plist file
-(void) loadDataFromFile {
	
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		dictionary = [[NSMutableDictionary alloc] init];
		return;
	}
	
	// if file exists, load Dictionary from file.
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		dictionary = [[NSMutableDictionary alloc] init];
		return;
	}
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *tckey = [key stringByAppendingString:@"-TowingCompanyName"];
	NSString *pnkey = [key stringByAppendingString:@"-TowingCompanyPhoneNumber"];
	
	//Populate data from  Dictionary 
	towingCompanyNameField.text = [dictionary objectForKey:tckey];
	towingCompanyPhoneNumberField.text = [dictionary objectForKey:pnkey];
}


-(void) saveDataToFile {
	
	// set the values to the dictionary 
	//dictionary= [[NSDictionary alloc] initWithObjectsAndKeys:towingCompanyNameField.text, @"TowingCompanyName", towingCompanyPhoneNumberField.text, @"TowingCompanyPhoneNumber", nil];
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *tcKey = [key stringByAppendingString:@"-TowingCompanyName"];
	NSString *pnKey = [key stringByAppendingString:@"-TowingCompanyPhoneNumber"];
    
    // set the values to the dictionary ( if nil - then set default values
	if (towingCompanyNameField.text == nil) {
        towingCompanyNameField.text = @"";
	}
	
	if (towingCompanyPhoneNumberField.text == nil) {
		towingCompanyPhoneNumberField.text = @"";
	}
    //
	
	[dictionary setObject:towingCompanyNameField.text forKey:tcKey];
	[dictionary setObject:towingCompanyPhoneNumberField.text forKey:pnKey];
	
	//Otherwise save/ persist the contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving information about the Towing Company (TowingViewLeaf), Failed to save data to Accidently.plist file!");
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about the Towing company, Accidently received a  memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
	towingCompanyNameField         = nil;
	towingCompanyPhoneNumberField  = nil;
	towingCompanyNameLabel         = nil;
	towingCompanyPhoneNumberLabel  = nil;
    reportTitle                    = nil; 
	saveButton                     = nil;
	cancelButton                   = nil; 
	naviBar                        = nil;
}


- (void)dealloc {
	[towingCompanyNameField         release];
	[towingCompanyPhoneNumberField  release];
	[towingCompanyNameLabel         release];
	[towingCompanyPhoneNumberLabel  release];
	[saveButton                     release];
	[cancelButton                   release];
	[reportTitle                    release];
	[naviBar                        release];
    [scrollView                     release];
    [super                          dealloc];
}


@end
