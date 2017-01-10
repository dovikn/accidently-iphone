//
//  OtherDriverVehicleLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OtherDriverVehicleLeaf.h"


@implementation OtherDriverVehicleLeaf

@synthesize ownerField;
@synthesize makeField;
@synthesize modelField;
@synthesize yearField;
@synthesize ownerLabel;
@synthesize makeLabel;
@synthesize modelLabel;
@synthesize yearLabel;
@synthesize licensePlateField;
@synthesize licensePlateLabel;
@synthesize saveButton, cancelButton, naviBar;
@synthesize reportTitle;
@synthesize scrollView;

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
	UILabel *oLabel = [self ownerLabel]; 
	oLabel.textColor = [UIColor whiteColor];
	[oLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[oLabel release];
	
	UILabel *mLabel = [self makeLabel]; 
	mLabel.textColor = [UIColor whiteColor];
	[mLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[mLabel release];
	
	UILabel *moLabel = [self modelLabel]; 
	moLabel.textColor = [UIColor whiteColor];
	[moLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[moLabel release];
	
	UILabel *yLabel = [self yearLabel]; 
	yLabel.textColor = [UIColor whiteColor];
	[yLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[yLabel release];
	
	UILabel *lpLabel = [self licensePlateLabel]; 
	lpLabel.textColor = [UIColor whiteColor];
	[lpLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[lpLabel release];	
    
    // Enable Scrolling
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
}
	

// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	
	[ownerField resignFirstResponder];
	[makeField resignFirstResponder];
	[modelField resignFirstResponder];
	[yearField resignFirstResponder];
	[licensePlateField resignFirstResponder];
}


// Get the accidently .plist file in the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}


-(IBAction) save: (id) sender {
	[self saveDataToFile];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) cancel: (id) sender {
	[self dismissModalViewControllerAnimated:YES];	
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
	
	NSString *oKey = [key stringByAppendingString:@"-OtherDriverVehicleOwner"];
	NSString *maKey = [key stringByAppendingString:@"-OtherDriverVehicleMake"];
	NSString *moKey = [key stringByAppendingString:@"-OtherDriverVehicleModel"];
	NSString *yKey = [key stringByAppendingString:@"-OtherDriverVehicleYear"];
	NSString *lpKey = [key stringByAppendingString:@"-OtherDriverVehicleLicensePlate"];
	
	
	ownerField.text = [dictionary objectForKey:oKey];
	makeField.text = [dictionary objectForKey:maKey];
	modelField.text = [dictionary objectForKey:moKey];
	yearField.text = [dictionary objectForKey:yKey];
	licensePlateField.text = [dictionary objectForKey:lpKey];
		
}


-(void) saveDataToFile {
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *oKey = [key stringByAppendingString:@"-OtherDriverVehicleOwner"];
	NSString *maKey = [key stringByAppendingString:@"-OtherDriverVehicleMake"];
	NSString *moKey = [key stringByAppendingString:@"-OtherDriverVehicleModel"];
	NSString *yKey = [key stringByAppendingString:@"-OtherDriverVehicleYear"];
	NSString *lpKey = [key stringByAppendingString:@"-OtherDriverVehicleLicensePlate"];
	
	if (ownerField.text == nil) {
			ownerField.text =@"";
	}
	
	if (makeField.text == nil) {
		makeField.text =@"";
	}
	if (modelField.text == nil) {
		modelField.text =@"";
	}
	if (yearField.text == nil) {
		yearField.text =@"";
	}
	if (licensePlateField.text == nil) {
		licensePlateField.text =@"";
	}
	
	[dictionary setObject:ownerField.text forKey:oKey];
	[dictionary setObject:makeField.text forKey:maKey];
	[dictionary setObject:modelField.text forKey:moKey];
	[dictionary setObject:yearField.text forKey:yKey];
	[dictionary setObject:licensePlateField.text forKey:lpKey];

	
	//Otherwise save/ persist the contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving information about the other driver's vehicle (OtherDriverVehicleLeaf), Failed to save data to Accidently.plist file!");
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about the other driver's vehicle, Accidently received a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
	ownerField = nil;
	makeField = nil;
	modelLabel  = nil;
	yearField  = nil;
	ownerLabel = nil;
	makeLabel = nil; 
	modelLabel = nil;
	yearField = nil;
	licensePlateField = nil;
	licensePlateLabel = nil;
	saveButton = nil;
	cancelButton = nil;
	naviBar = nil;
	reportTitle = nil;
    scrollView = nil;
}


- (void)dealloc {
	[ownerField release];
	[makeField release];
	[modelField release];
	[yearField release];
	[ownerLabel release];
	[makeLabel release];
	[modelLabel release];
	[yearLabel release];
	[licensePlateField release];
	[licensePlateLabel release];
	[saveButton release];
	[cancelButton release];
	[reportTitle release];
    [scrollView release];
	[naviBar release];
	[super dealloc];
}


@end
