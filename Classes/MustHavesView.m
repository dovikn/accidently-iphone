//
//  MustHavesView.m
//  Accident-ly
//
//  Created by Dovik Nissim on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MustHavesView.h"


@implementation MustHavesView


@synthesize nameField, nameLabel;
@synthesize carMakeModelYearLabel;
@synthesize carMakeModelYearField;
@synthesize cellPhoneField, cellPhoneLabel;
@synthesize insuranceNumberField, insuranceNumberLabel;
@synthesize reportTitle;
@synthesize saveButton, cancelButton;
@synthesize scrollView;


NSMutableDictionary *dictionary;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//load Data from .plist before presenting the page
	[self loadDataFromFile];
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
    
    // Set the title: 
    self.title = @"Top Priority";
	
	
	// Set the color of the labels to White
	UILabel *nLabel = [self nameLabel]; 
	nLabel.textColor = [UIColor whiteColor];
	[nLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[nLabel release];
	
	UILabel *cLabel = [self carMakeModelYearLabel]; 
	cLabel.textColor = [UIColor whiteColor];
	[cLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[cLabel release];
	
	UILabel *pLabel = [self cellPhoneLabel]; 
	pLabel.textColor = [UIColor whiteColor];
	[pLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[pLabel release];
	
	UILabel *iLabel = [self insuranceNumberLabel]; 
	iLabel.textColor = [UIColor whiteColor];
	[iLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[iLabel release];
    
    //set the scroll View
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize: CGSizeMake(320, 700)];

}

-(IBAction) save:(id)sender {
	[self saveDataToFile];
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) cancel:(id) sender {
	[self.navigationController popViewControllerAnimated:YES];
}


// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	
	[nameField resignFirstResponder];
	[carMakeModelYearField resignFirstResponder];
	[cellPhoneField resignFirstResponder];
	[insuranceNumberField resignFirstResponder];
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
	
	NSString *maKey = [key stringByAppendingString:@"-OtherDriverVehicleMake"];
	NSString *moKey = [key stringByAppendingString:@"-OtherDriverVehicleModel"];
	NSString *yKey = [key stringByAppendingString:@"-OtherDriverVehicleYear"];
	
	
	NSString *cpKey = [key stringByAppendingString:@"-OtherDriverCellPhone"];
	NSString *ipKey = [key stringByAppendingString:@"-OtherDriverInsurancePolicy"];
	NSString *pnKey = [key stringByAppendingString:@"-OtherDriverPolicyNumber"];
	
	//Populate data from  Dictionary 
	nameField.text = [dictionary objectForKey:nameKey];
	cellPhoneField.text = [dictionary objectForKey:cpKey];
	
	// Populate the  other guy's name 
	NSString *otherName =  [dictionary objectForKey:nameKey];
	if (otherName != nil) {
		nameField.text = otherName;
	}
	
	// Populate the other guy's phone number 
	NSString *cellPhoneValue =  [dictionary objectForKey:cpKey];
	if (cellPhoneValue != nil) {
		cellPhoneField.text = cellPhoneValue;
	}
	
	// Car Model, make, year 
	NSString *carValue = @"";
	
	NSString *carMakeValue = [dictionary objectForKey:maKey];
	
	if (carMakeValue != nil) {
		carValue = [carValue stringByAppendingString:carMakeValue];
					 
	}
	
	NSString *carModelValue = [dictionary objectForKey:moKey];
					
					
	if (carModelValue != nil) {
		carValue = [carValue stringByAppendingString:@", "];	
		carValue = [carValue stringByAppendingString:carModelValue];
	}
					
					
	NSString *carYearValue = [dictionary objectForKey:yKey];
					
					
	if (carYearValue != nil) {
		carValue = [carValue stringByAppendingString:@", "];
		carValue = [carValue stringByAppendingString:carYearValue];
						
	}
					
	carMakeModelYearField.text = carValue;
					 
	NSString * insuranceValue = @""; 
					 
	NSString *insuranceCompanyValue = [dictionary objectForKey:ipKey];
					
	if (insuranceCompanyValue != nil) {
			insuranceValue = [insuranceValue stringByAppendingString:insuranceCompanyValue];
	}
	
		
	NSString *insurancePolicyValue = [dictionary objectForKey:pnKey];
					 
					 
	if (insurancePolicyValue != nil) {
		insuranceValue = [insuranceValue stringByAppendingString:@", "];
		insuranceValue = [insuranceValue stringByAppendingString:insurancePolicyValue];
	}
					 
	insuranceNumberField.text = insuranceValue;

}


-(void) saveDataToFile {
	
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	NSString *nameKey  = [key stringByAppendingString:@"-OtherDriverName"];	
	
	NSString *maKey = [key stringByAppendingString:@"-OtherDriverVehicleMake"];
	NSString *moKey = [key stringByAppendingString:@"-OtherDriverVehicleModel"];
	NSString *yKey =[key stringByAppendingString:@"-OtherDriverVehicleYear"];
	
	
	NSString *cpKey = [key stringByAppendingString:@"-OtherDriverCellPhone"];
	NSString *ipKey = [key stringByAppendingString:@"-OtherDriverInsurancePolicy"];
	NSString *pnKey = [key stringByAppendingString:@"-OtherDriverPolicyNumber"];
	
	
	if(nameField.text == nil) {
		nameField.text = @"";
	}
	if(carMakeModelYearField.text == nil) {
		carMakeModelYearField.text = @"";
	}
	if(cellPhoneField.text == nil) {
		cellPhoneField.text = @"";
	}
	if(insuranceNumberField.text == nil) {
		insuranceNumberField.text = @"";
	}
	
	[dictionary setObject:nameField.text forKey:nameKey];
	[dictionary setObject:cellPhoneField.text forKey:cpKey];
	
	// make model year 
	NSMutableArray *makeModelYearArray = [[NSMutableArray alloc] init];
	[makeModelYearArray setArray:[carMakeModelYearField.text componentsSeparatedByString:@","]];
	

	if (makeModelYearArray == nil) {
		// if the array is nil do nothing 
		
	} else if ([makeModelYearArray count] ==1) {
		[dictionary setObject:[makeModelYearArray objectAtIndex:0] forKey:maKey];	
	}else if ([makeModelYearArray count] ==2) {
		[dictionary setObject:[makeModelYearArray objectAtIndex:0] forKey:maKey];
		[dictionary setObject:[makeModelYearArray objectAtIndex:1] forKey:moKey];	
		
	}else if ([makeModelYearArray count] ==3) {
		[dictionary setObject:[makeModelYearArray objectAtIndex:0] forKey:maKey];
		[dictionary setObject:[makeModelYearArray objectAtIndex:1] forKey:moKey];	
		[dictionary setObject:[makeModelYearArray objectAtIndex:2] forKey:yKey];
	}
	
	// insurance
	NSMutableArray *insuranceArray = [[NSMutableArray alloc] init];
	[insuranceArray setArray:[insuranceNumberField.text componentsSeparatedByString:@","]];
	
	if (insuranceArray == nil) {
		// if the array is nil do nothing 
		
	} else if ([insuranceArray count] ==1) {
		[dictionary setObject:[insuranceArray objectAtIndex:0] forKey:ipKey];	
	} else if ([insuranceArray count] ==2) {
		
		[dictionary setObject:[insuranceArray objectAtIndex:0] forKey:ipKey];
		[dictionary setObject:[insuranceArray objectAtIndex:1] forKey:pnKey];	
		
	}
	
	//Otherwise save/ persist the contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving top priority information (MustHavesView), Failed to save data to Accidently.plist file!");
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving top priority information (MustHavesView), Accidently received a a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}



- (void)viewDidUnload {
    [super viewDidUnload];
	nameField = nil;
	carMakeModelYearField = nil;
    cellPhoneField = nil;
	insuranceNumberField = nil;
	reportTitle = nil;
    nameLabel = nil;
	carMakeModelYearLabel= nil;
	cellPhoneLabel = nil;
	insuranceNumberLabel= nil;
    scrollView = nil;
	
}


- (void)dealloc {
	[nameField release];
	[carMakeModelYearField release];
	[cellPhoneField release];
	[insuranceNumberField release];
	[nameLabel  release];
	[carMakeModelYearLabel release];
	[cellPhoneLabel release];
	[insuranceNumberLabel release];
	[saveButton release];
	[cancelButton release];
	//[naviBar release];
    [scrollView release];
    [super dealloc];
}


@end