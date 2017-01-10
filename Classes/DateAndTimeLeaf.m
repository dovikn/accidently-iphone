//
//  DateAndTimeLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DateAndTimeLeaf.h"


@implementation DateAndTimeLeaf

@synthesize addFlag;
@synthesize reportNameLabel;
@synthesize dateLabel; 
@synthesize saveButton, cancelButton;
@synthesize textField;
@synthesize reportTitle;
@synthesize dateAsString;
@synthesize naviBar;
@synthesize reportSentStatus;



UIDatePicker		*datePicker;
NSMutableDictionary *dictionary;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	UINavigationBar *navBar = [self.navigationController navigationBar];
	[navBar setTintColor:[UIColor blackColor]];
	
	// In case of adding a new report.
	if (addFlag) {
		
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		dateAsString= [dateFormatter stringFromDate:[NSDate date]];
		
		
//		NSString *suggestedReportTitle = @"My Accident Report (";
//		suggestedReportTitle = [suggestedReportTitle stringByAppendingString:dateAsString];
//		suggestedReportTitle = [suggestedReportTitle stringByAppendingString:@")"];
//	    textField.text = suggestedReportTitle;
	}
	
	// Set the color of the navigation bar to black
	[naviBar setTintColor:[UIColor blackColor]];
	
	// Set the color of the labels to White
	UILabel *nLabel = [self reportNameLabel]; 
	nLabel.textColor = [UIColor whiteColor];
	[nLabel setFont:[UIFont boldSystemFontOfSize:25]];
	[nLabel release];
	
	UILabel *dLabel = [self dateLabel]; 
	dLabel.textColor = [UIColor whiteColor];
	[dLabel setFont:[UIFont boldSystemFontOfSize:25]];
	[dLabel release];
	
	
	// Create and Add the datePicker
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 140, 325, 250)];
	datePicker.datePickerMode = UIDatePickerModeDate;
	datePicker.hidden = NO;
	
	
	// load  the default date from File
	[self loadDataFromFile];
	
	//[datePicker addTarget:self action:@selector(saveDataToFile:)forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:datePicker];
}


-(IBAction) cancelReport:(id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) saveDataToFile {
	
    // Check if the name is missing
	if (textField.text ==nil || [textField.text length] == 0) {
	
		UIAlertView *alertNameMissing = [[UIAlertView alloc]
							  initWithTitle:@"Alert!"
							  message:@"Please add a title to your report"
							  delegate: self
							  cancelButtonTitle: @"OK"
							  otherButtonTitles:nil];
		[alertNameMissing show];
		[alertNameMissing release];
		return;
	}
    
    
    // Check if the name is invalid
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {
		
		UIAlertView *alertInvalidName = [[UIAlertView alloc]
                                         initWithTitle:@"Alert!"
                                         message:@"Please add a title to your report"
                                         delegate: self
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles:nil];
		[alertInvalidName show];
		[alertInvalidName release];
		return;
	}
    
    if ([self reportNameExists:textField.text] == YES ) {
        // alert - must fill out a name
		UIAlertView *alertNameExists = [[UIAlertView alloc]
							  initWithTitle:@"Alert!"
							  message:@"A report by that name already exists, please pick an alternative title for your report"
							  delegate: self
							  cancelButtonTitle: @"OK"
							  otherButtonTitles:nil];
		[alertNameExists show];
		[alertNameExists release];
        return;
        
    }
	
	NSString *reportNotSent = @"1";
	
	if (addFlag) {
		// Save the report name 
		[reportsList  addObject:textField.text];
		[reportSentStatus setValue:reportNotSent forKey:textField.text];
		
		// set the values to the dictionary
		[dictionary setValue:reportsList forKey:@"Accidently-Reports"];	
		[reportSentStatus setValue:reportNotSent forKey:textField.text];
	
	} else { //its edit 
	
		// Correct the name if necessary
		if (![reportTitle isEqualToString: textField.text]) {
		
			[reportsList  removeObject:reportTitle];
			[reportSentStatus removeObjectForKey:reportTitle];
			
			[reportsList  addObject:textField.text];
			[reportSentStatus setValue:reportNotSent forKey:textField.text];
			
		}
	}
	
	// Save the date and time to the dictionary 
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:textField.text];
	key = [key stringByAppendingString:@"-DateAndTime"];
	[dictionary setObject:datePicker.date forKey:key];
	
	if (reportSentStatus == nil ) {
		reportSentStatus = [[NSMutableDictionary alloc] init];
	}

	//Set the information about report being sent to the dictionary 
	[dictionary setObject:reportSentStatus forKey:@"Accidently-ReportSentStatus"];
	
	//save contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];

	if (ret == NO) {
		NSLog(@"[ERROR]: While adding or editing a new report (DateAndTimeLeaf), Failed to save data to Accidently.plist file!");
	}
	
	[self dismissModalViewControllerAnimated:YES];

}

/**
 *
 **/
-(BOOL) reportNameExists:(NSString *) name {
    
    // ASSUMPTION: this method receives a report name which is not nil.
    NSString *tmpKey = @"Accidently-";
	tmpKey = [tmpKey stringByAppendingString:name];
	tmpKey = [tmpKey stringByAppendingString:@"-DateAndTime"];
    
    NSString *tmpVal = [dictionary objectForKey:tmpKey];
    
    if (tmpVal == nil) {
        return NO;
    }
    
    return YES;
}

// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	[textField resignFirstResponder];
}


- (void) viewWillAppear:(BOOL)animated {
	[self loadDataFromFile];
	

}

// Get the accidently .plist file in the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

-(void) loadDataFromFile {
	
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't set the date picker to show today's date
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		dictionary = [[NSMutableDictionary alloc] init];
		reportsList = [[NSMutableArray alloc] init];
		datePicker.date = [NSDate date];
		return;
	}
	
	// if file exists, load Dictionary from file.
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		dictionary = [[NSMutableDictionary alloc] init];
		reportsList = [[NSMutableArray alloc] init];
		datePicker.date = [NSDate date];
		return;
	}
	
	
	// Populate data from  Dictionary 
	reportsList = [dictionary objectForKey:@"Accidently-Reports"];
	if (reportsList == nil ) {
		reportsList = [[NSMutableArray alloc] init];
		
	}
	
	// Populate the reportSent Status
	reportSentStatus = [dictionary objectForKey:@"Accidently-ReportSentStatus"];
	if (reportSentStatus == nil) {
		reportSentStatus = [[NSMutableDictionary alloc] init];
	}
	
	
	// Set the date to today's 
	datePicker.date = [NSDate date];
	
	// change the date for an edit case if neccesary  
	
	if(!addFlag) {	
	
		textField.text = reportTitle;
		
		NSString *key = @"Accidently-";
		key = [key stringByAppendingString:reportTitle];
		key = [key stringByAppendingString:@"-DateAndTime"];
		
		NSDate *date = [dictionary objectForKey:key];
		datePicker.date = date;
		
	}
}


- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While creating or editing a report (DateAndTimeLeaf), Accidently received a memory warning!");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

	datePicker			= nil;
	dictionary			= nil;
	reportNameLabel		= nil;
	dateLabel			= nil;
	textField			= nil;
	reportsList			= nil;
	reportTitle			= nil;
	cancelButton		= nil;
	naviBar				= nil;
	reportSentStatus	= nil;
	[super viewDidUnload];
}


- (void)dealloc {
    NSLog(@"DEBUG: DateAndTime Dealloc/ Released");
	[reportsList		release];
	[datePicker			release];
	[dictionary			release];
	[reportNameLabel	release];
	[dateLabel			release];
	[textField			release];
	[cancelButton		release];
	[naviBar			release];
    [reportSentStatus   release];
	[super				dealloc];
	
}

@end
