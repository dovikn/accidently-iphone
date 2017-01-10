//
//  OtherDriverInsuranceLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OtherDriverInsuranceLeaf.h"

@implementation OtherDriverInsuranceLeaf


@synthesize insuranceCompanyField;;
@synthesize policyNumberField;;
@synthesize expirationDateField;
@synthesize insuranceCompanyLabel;
@synthesize policyNumberLabel;
@synthesize expirationDateLabel;
@synthesize viewTitle;
@synthesize saveButton, cancelButton;
@synthesize reportTitle;
@synthesize scrollView;
@synthesize naviBar;

NSMutableDictionary *dictionary;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	[naviBar setTintColor:[UIColor blackColor]];
	
	// Set the color of the labels to White
	UILabel *iLabel = [self insuranceCompanyLabel]; 
	iLabel.textColor = [UIColor whiteColor];
	[iLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[iLabel release];
	
	UILabel *pLabel = [self policyNumberLabel]; 
	pLabel.textColor = [UIColor whiteColor];
	[pLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[pLabel release];
	
	
	UILabel *expirationLabel = [self expirationDateLabel]; 
	expirationLabel.textColor = [UIColor whiteColor];
	[expirationLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[expirationLabel release];
	
	
	UILabel *vTitle = [self viewTitle]; 
	vTitle.textColor = [UIColor whiteColor];
	[vTitle setFont:[UIFont boldSystemFontOfSize:20]];
	[vTitle release];
    
    // Enable Scrolling
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
    
	
	
	//load Data from .plist before presenting the page
	[self loadDataFromFile];
}

-(IBAction) save: (id)sender {
	[self saveDataToFile];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) cancel:(id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	
	[insuranceCompanyField resignFirstResponder];
	[policyNumberField resignFirstResponder];
	[expirationDateField resignFirstResponder];
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
	
	NSString *ipKey = [key stringByAppendingString:@"-OtherDriverInsurancePolicy"];
	NSString *pnKey = [key stringByAppendingString:@"-OtherDriverPolicyNumber"];
	NSString *edKey = [key stringByAppendingString:@"-OtherDriverExpirationDate"];

	
	insuranceCompanyField.text = [dictionary objectForKey:ipKey];
	policyNumberField.text = [dictionary objectForKey:pnKey];
	expirationDateField.text = [dictionary objectForKey:edKey];
	
}


-(void) saveDataToFile {
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *ipKey = [key stringByAppendingString:@"-OtherDriverInsurancePolicy"];
	NSString *pnKey = [key stringByAppendingString:@"-OtherDriverPolicyNumber"];
	NSString *edKey = [key stringByAppendingString:@"-OtherDriverExpirationDate"];
	
	
	if (insuranceCompanyField.text  == nil) {
		insuranceCompanyField.text  = @"";
	}
	if (policyNumberField.text == nil) {
		policyNumberField.text = @"";
	}	
	if (expirationDateField.text == nil) {
		expirationDateField.text = @"";
	}
	
	[dictionary setObject:insuranceCompanyField.text forKey:ipKey];
	[dictionary setObject:policyNumberField.text forKey:pnKey];
	[dictionary setObject:expirationDateField.text forKey:edKey];
	
	
	//Otherwise save/ persist the contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving information about the other driver's insurance  (OtherDriverInsuranceLeaf), Failed to save data to Accidently.plist file!");
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about other driver's insurance details, Accidently received a a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
 
	insuranceCompanyField = nil;
	policyNumberField = nil;
	expirationDateField = nil;
	insuranceCompanyLabel = nil;
	policyNumberLabel = nil;
	expirationDateLabel=nil;
	viewTitle = nil;
	saveButton = nil;
	cancelButton = nil;
	naviBar = nil;
	reportTitle = nil;
    scrollView = nil;
}


- (void)dealloc {
	[insuranceCompanyField release];
	[policyNumberField release];
	[expirationDateField release];
	[insuranceCompanyLabel release];
	[policyNumberLabel release];
	[expirationDateLabel release];
	[viewTitle release];
	[reportTitle release];
	[saveButton release];
	[cancelButton release];
    [scrollView release];
	[naviBar release];
    [super dealloc];
}


@end
