//
//  DescriptionViewLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DescriptionViewLeaf.h"

@implementation DescriptionViewLeaf

@synthesize textView;
@synthesize textViewLabel;
@synthesize reportTitle;
@synthesize saveButton, cancelButton;
@synthesize navBar;
@synthesize scrollView;

NSMutableDictionary *dictionary;


- (void)viewDidLoad {
    [super viewDidLoad];

	// Load data from file
	[self loadDataFromFile];
	
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	[navBar setTintColor:[UIColor blackColor]];
	
	UILabel *aLabel = [self textViewLabel];
	aLabel.textColor = [UIColor whiteColor];
	[aLabel setFont:[UIFont boldSystemFontOfSize:30]];
	[aLabel release];

    // set the scrollView
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
   
}

-(void) viewWillDisappear:(BOOL)animated {
	[self saveDataToFile];
}

- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

-(IBAction) backgroundTap: (id)sender {
	[textView resignFirstResponder];
}

-(IBAction) save:(id) sender {
	[self saveDataToFile];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) cancel:(id) sender {
	[self dismissModalViewControllerAnimated:YES];
}


// Get the accidently .plist file in the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

-(void) loadDataFromFile {
	
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		return;
	}
	
	// if file exists, load Dictionary from file.
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		return;
	}
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *descriptionKey = @"-Description";
	descriptionKey = [key stringByAppendingString: descriptionKey];
	
	// populate data from  Dictionary 
	textView.text = [dictionary objectForKey:descriptionKey];
}


-(void) saveDataToFile {
	
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *descriptionKey = @"-Description";
	descriptionKey = [key stringByAppendingString: descriptionKey];
	
	// set the values to the dictionary 
	
	if (textView.text == nil) {
		textView.text = @"";
	}
	[dictionary setObject:textView.text forKey:descriptionKey];

	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving information about the Description  (DescriptionViewLeaf), Failed to save data to Accidently.plist file!");
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about the Description, Accidently received a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	textView		= nil;
	textViewLabel	= nil;
	reportTitle		= nil;
	saveButton		= nil;
	cancelButton	= nil;
	navBar			= nil;
    scrollView      = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [reportTitle	release];
	[saveButton		release];
	[cancelButton	release];
	[textView		release];
	[textViewLabel	release];
	[navBar			release];
    [scrollView     release];
	[super			dealloc];
}

@end

