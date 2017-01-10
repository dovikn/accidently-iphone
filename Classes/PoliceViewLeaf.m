//
//  PoliceViewLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PoliceViewLeaf.h"


@implementation PoliceViewLeaf


@synthesize policeDepartmentField;
@synthesize policeReportNumberField;
@synthesize policeDepartmentLabel;
@synthesize policeReportNumberLabel;
@synthesize reportTitle;
@synthesize saveButton, cancelButton;
@synthesize navBar;
@synthesize scrollView;

NSMutableDictionary *dictionary;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//load data from data file
	[self loadDataFromFile];
	
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	[navBar setTintColor:[UIColor blackColor]];
	
	
	// Set the color of the labels to White
	UILabel *pdLabel = [self policeDepartmentLabel]; 
	pdLabel.textColor = [UIColor whiteColor];
	[pdLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[pdLabel release];
	
	UILabel *pdnLabel = [self policeReportNumberLabel]; 
	pdnLabel.textColor = [UIColor whiteColor];
	[pdnLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[pdnLabel release];
    
    //enable Scrolling
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
	
}

-(IBAction) save:(id) sender {
	[self saveDataToFile];
	
}

-(IBAction) cancel:(id) sender {
	[self dismissModalViewControllerAnimated:YES];
}



-(void)viewWillDisappear:(BOOL)animated {
	[self saveDataToFile];
}

- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

-(IBAction) backgroundTap: (id)sender {
	[policeDepartmentField resignFirstResponder];
	[policeReportNumberField resignFirstResponder];
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
	
	NSString *pdKey = [key stringByAppendingString:@"-PoliceDepartmentInvestigating"];
	NSString *pdrnKey = [key stringByAppendingString:@"-PoliceReportNumber"];
	
	// populate data from  Dictionary 
	policeDepartmentField.text = [dictionary objectForKey:pdKey];
	policeReportNumberField.text = [dictionary objectForKey:pdrnKey];
}


-(void) saveDataToFile {
	
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *pdKey = [key stringByAppendingString:@"-PoliceDepartmentInvestigating"];
	NSString *pdrnKey = [key stringByAppendingString:@"-PoliceReportNumber"];
	

	// set the values to the dictionary ( if nil - then set default values
	if (policeDepartmentField.text == nil) {
			policeDepartmentField.text = @"";
	}
	
	if (policeReportNumberField.text == nil) {
		policeReportNumberField.text = @"";
	}
	
	[dictionary setObject:policeDepartmentField.text forKey:pdKey];
	[dictionary setObject:policeReportNumberField.text forKey:pdrnKey];
	
	//Otherwise save/ persist the contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving information about the other driver (OtherDriverDetailsLeaf), Failed to save data to Accidently.plist file!");
	}
	
	[self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about the police report, Accidently received a a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
	reportTitle     = nil; 
	saveButton      = nil;
	cancelButton    = nil;
	navBar          = nil;
}


- (void)dealloc {
	[reportTitle    release];
	[saveButton     release];
	[cancelButton   release];
	[navBar         release];
    [scrollView     release];
    [super dealloc];
}


@end
