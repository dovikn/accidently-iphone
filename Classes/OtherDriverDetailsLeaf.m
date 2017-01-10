//
//  OtherDriverDetailsLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OtherDriverDetailsLeaf.h"


@implementation OtherDriverDetailsLeaf
@synthesize nameField;
@synthesize address1Field;
@synthesize reportTitle;
@synthesize homePhoneField;
@synthesize cellPhoneField;
@synthesize licenseNumberField;
@synthesize scrollView;
@synthesize nameLabel;
@synthesize addressLabel;
@synthesize phoneLabel;
@synthesize licenseNumberLabel;
@synthesize saveButton, cancelButton;
@synthesize naviBar;


NSMutableDictionary *dictionary;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//load Data from .plist before presenting the page
	[self loadDataFromFile];
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	[naviBar setTintColor:[UIColor blackColor]];
	
	
	// Set the color of the labels to White
	UILabel *nLabel = [self nameLabel]; 
	nLabel.textColor = [UIColor whiteColor];
	[nLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[nLabel release];
	
	UILabel *aLabel = [self addressLabel]; 
	aLabel.textColor = [UIColor whiteColor];
	[aLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[aLabel release];
	
	UILabel *pLabel = [self phoneLabel]; 
	pLabel.textColor = [UIColor whiteColor];
	[pLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[pLabel release];
	
	UILabel *lLabel = [self licenseNumberLabel]; 
	lLabel.textColor = [UIColor whiteColor];
	[lLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[lLabel release];
    
    //Enable Scrolling
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
}

-(IBAction) save:(id)sender {
	[self saveDataToFile];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) cancel:(id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
	// Save data to .plist before closing
	//[self saveDataToFile];
}

// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	
	[nameField resignFirstResponder];
	[address1Field resignFirstResponder];
	
	[homePhoneField resignFirstResponder];
	[cellPhoneField resignFirstResponder];
	[licenseNumberField resignFirstResponder];
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
	
	NSString *nameKey  = [key stringByAppendingString:@"-OtherDriverName"];
	NSString *addressKey = [key stringByAppendingString:@"-OtherDriverAddress1"];
	NSString *hpKey  = [key stringByAppendingString:@"-OtherDriverHomePhone"];
	NSString *cpKey = [key stringByAppendingString:@"-OtherDriverCellPhone"];
	NSString *lnKey = [key stringByAppendingString:@"-OtherDriverLicenseNumber"];
	
	//Populate data from  Dictionary 
	nameField.text = [dictionary objectForKey:nameKey];
	address1Field.text = [dictionary objectForKey:addressKey];
	homePhoneField.text = [dictionary objectForKey:hpKey];
	cellPhoneField.text = [dictionary objectForKey:cpKey];
	licenseNumberField.text = [dictionary objectForKey:lnKey];
	
}


-(void) saveDataToFile {
	
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *nameKey  = [key stringByAppendingString:@"-OtherDriverName"];
	NSString *addressKey = [key stringByAppendingString:@"-OtherDriverAddress1"];
	NSString *hpKey  = [key stringByAppendingString:@"-OtherDriverHomePhone"];
	NSString *cpKey = [key stringByAppendingString:@"-OtherDriverCellPhone"];
	NSString *lnKey = [key stringByAppendingString:@"-OtherDriverLicenseNumber"];
	
	
	if(nameField.text == nil) {
			nameField.text = @"";
	}
	if(address1Field.text == nil) {
		address1Field.text = @"";
	}
	if(homePhoneField.text == nil) {
		homePhoneField.text = @"";
	}
	if(cellPhoneField.text == nil) {
		cellPhoneField.text = @"";
	}
	if(licenseNumberField.text == nil) {
		licenseNumberField.text = @"";
	}
	 
	[dictionary setObject:nameField.text forKey:nameKey];
	[dictionary setObject:address1Field.text forKey:addressKey];
	[dictionary setObject:homePhoneField.text forKey:hpKey];
	[dictionary setObject:cellPhoneField.text forKey:cpKey];
	[dictionary setObject:licenseNumberField.text forKey:lnKey];
	
	//Otherwise save/ persist the contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving information about the other driver (OtherDriverDetailsLeaf), Failed to save data to Accidently.plist file!");
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about other driver (OtherDriverDetailsLeaf), Accidently received a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	nameField = nil;
	address1Field = nil;
	homePhoneField = nil;
    cellPhoneField = nil;
	licenseNumberField = nil;
	reportTitle = nil;
    nameLabel = nil;
	addressLabel = nil;
	phoneLabel = nil;
	licenseNumberLabel= nil;
	scrollView =nil;
}


- (void)dealloc {
	[nameField release];
	[address1Field release];
	[reportTitle release];
	[homePhoneField release];
	[cellPhoneField release];
	[licenseNumberField release];
	[nameLabel  release];
	[addressLabel release];
	[phoneLabel release];
	[licenseNumberLabel release];
	[saveButton release];
	[cancelButton release];
	[naviBar release];
	[naviBar release];
    [scrollView release];
    [super dealloc];
}


@end
