//
//  SendMailView.m
//  Accident-ly
//
//  Created by Dovik Nissim on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendMailView.h"


@implementation SendMailView

@synthesize sendButton;
@synthesize recipientsField;
@synthesize recipientsLabel;
@synthesize reportTitle;
@synthesize cancelButton;
@synthesize naviBar;
@synthesize reportSentStatus;

NSMutableDictionary *dictionary;

-(void) viewDidLoad {
    
    [self loadDataFromFile];
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	[naviBar setTintColor:[UIColor blackColor]];
	
	
	// Set the color of the labels to White
	UILabel *rLabel = [self recipientsLabel]; 
	rLabel.textColor = [UIColor whiteColor];
	[rLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[rLabel release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {	
   
    // dismiss the email window.
    [self dismissModalViewControllerAnimated:YES];


	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:{
            NSLog(@"[DEBUG]: Accident report %@ was cancelled.", reportTitle);
			break;
        }
        case MFMailComposeResultSaved:{
			UIAlertView *saved = [[UIAlertView alloc] initWithTitle:@"Results" message:@"Report draft saved" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			[saved show];
			[saved release];
			break;
        }
		case MFMailComposeResultSent:{
			UIAlertView *sent = [[UIAlertView alloc] initWithTitle:@"Results" message:@"Accident report was sent successfully." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			[sent show];
			[sent release];
			// set value 0 = report sent for this report
			 NSLog(@"[DEBUG]: Accident report %@ was sent successfully.", reportTitle);
            [reportSentStatus setValue:@"0" forKey:reportTitle];
            [self saveDataToFile];
			break;
		}
		case MFMailComposeResultFailed:{
			UIAlertView *failed = [[UIAlertView alloc] initWithTitle:@"Results" message:@"Failed to send accident report!, Please Check Internet Connection And Try Again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			[failed show];
			[failed release];
             NSLog(@"[DEBUG]: Failed to send accident report %@ !", reportTitle);
			break;
		}
    }
}
    

- (IBAction) cancel: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}
		
-(IBAction) sendMail: (id) sender {
	
	if (recipientsField.text ==nil || [recipientsField.text length] == 0) {
		
		// alert - must add recipient(s)
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Alert!"
							  message:@"Please indicate target recipient(s) to whom you would like to send report."
							  delegate: self
							  cancelButtonTitle: @"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}

	[self mailIt];
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
	
	// set the reportSentStatus Dictionary 
	reportSentStatus = [dictionary valueForKey:@"Accidently-ReportSentStatus"];
	if (reportSentStatus == nil) {
		reportSentStatus = [[NSMutableDictionary alloc] init];
        
	}
	
}

-(void) saveDataToFile {
	
	// set the values to the dictionary 
	[dictionary setObject:reportSentStatus forKey:@"Accidently-ReportSentStatus"];
	
	//Otherwise save/ persist the contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While Sending a report (SendMailView), Failed to save data to Accidently.plist file!");
	}
}

//Composing the email
-(IBAction)mailIt {
	
	NSString *subject = @"Accident Report: ";
	subject = [subject stringByAppendingString:reportTitle];
	//
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	
	[picker setSubject:subject];

	NSMutableArray *toRecipients = [[NSMutableArray alloc] init];
	[toRecipients setArray:[recipientsField.text componentsSeparatedByString:@","]];
	
	
	[picker setToRecipients:toRecipients];
		
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *emailBody = [[NSString alloc] initWithString:@"<HTML><head> <h1> Accident Report </h1></head> <Body>"];
	
	NSString * accidentlySignature = [NSString stringWithFormat:@"\n\n<B>Sent using the  <a href = '%@'>Accidently iPhone App</a></B>", @"http://itunes.com/apps/accidently"];

	emailBody = [emailBody stringByAppendingString:accidentlySignature];
	
	emailBody = [emailBody stringByAppendingString:@"<BR><BR><b> Report Name: </b>"];
	emailBody = [emailBody stringByAppendingString: self.reportTitle];
	
	// Date and Time
	NSString *timeKey = [key stringByAppendingString:@"-DateAndTime"];
	
	NSDate *date = [dictionary objectForKey:timeKey];

	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-mm-yyyy"];
	NSString *dateAsString = [formatter stringFromDate:date];
	
	if (dateAsString != nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR><b>Date & Time: </b>"];
		emailBody = [emailBody stringByAppendingString: dateAsString];
	}		
	
	// Description
	NSString *descriptionKey = @"-Description";
	descriptionKey = [key stringByAppendingString: descriptionKey];
	NSString *descriptionValue =[dictionary objectForKey: descriptionKey];
	
	if (descriptionValue != nil) { 
		emailBody = [emailBody stringByAppendingString:@"<BR><b>Description: </b>"];
		emailBody = [emailBody stringByAppendingString: descriptionValue ];
	}
	
	// Location 
	NSString *addresKey = @"-Address";
	addresKey = [key stringByAppendingString: addresKey];
	NSString *addressValue =[dictionary objectForKey: addresKey];
	
	if (addressValue != nil) { 
		emailBody = [emailBody stringByAppendingString:@"<BR><b>Address:</b>"];
		emailBody = [emailBody stringByAppendingString: addressValue ];
	}
	
	NSString *cityKey = @"-City";
	cityKey = [key stringByAppendingString: cityKey];
	
	NSString *cityValue = [dictionary objectForKey: cityKey];
	
	if (cityValue != nil) {
	
		emailBody = [emailBody stringByAppendingString:@"<BR><b>City:</b>"];
		emailBody = [emailBody stringByAppendingString:cityValue ];
		
	}
	
	NSString *stateKey = @"-State";
	stateKey = [key stringByAppendingString: stateKey];
	NSString *stateValue = [dictionary objectForKey:stateKey];
		
	if (stateValue != nil) {
		
		emailBody = [emailBody stringByAppendingString:@"<BR><b>State:</b>"];
		emailBody = [emailBody stringByAppendingString:stateValue ];
		
	}
	
	// Other Person, Name, Car, Insurance Company
	
	//key = [key stringByAppendingString:reportTitle];
	
	NSString *nameKey  = [key stringByAppendingString:@"-OtherDriverName"];

	NSString *cpKey = [key stringByAppendingString:@"-OtherDriverCellPhone"];
	NSString *lnKey = [key stringByAppendingString:@"-OtherDriverLicenseNumber"];
	
	//Populate data from  Dictionary 
	NSString *nameValue = [dictionary objectForKey:nameKey];
	
	if (nameValue != nil ) {
		emailBody = [emailBody stringByAppendingString:@"<BR><b>Other Driver:</b>"];
		emailBody = [emailBody stringByAppendingString:@"<BR>Name:"];
		emailBody = [emailBody stringByAppendingString:nameValue ];
		
	}

	
	NSString *cellPhoneValue  = [dictionary objectForKey:cpKey];
	if (cellPhoneValue != nil ) {
		emailBody = [emailBody stringByAppendingString:@"<BR>Cell:"];
		emailBody = [emailBody stringByAppendingString:cellPhoneValue ];
	
	}
	
	
	
	NSString *driversLicenseValue= [dictionary objectForKey:lnKey];

	if (driversLicenseValue != nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR>Driver's License:"];
		emailBody = [emailBody stringByAppendingString:cellPhoneValue ];
		
	}
	
	NSString *maKey = [key stringByAppendingString:@"-OtherDriverVehicleMake"];
	NSString *moKey = [key stringByAppendingString:@"-OtherDriverVehicleModel"];
	NSString *yKey = [key stringByAppendingString:@"-OtherDriverVehicleYear"];
	NSString *lpKey = [key stringByAppendingString:@"-OtherDriverVehicleLicensePlate"];
		
	
	NSString *vehicleMake =  [dictionary objectForKey:maKey];

	if (vehicleMake != nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR><b>Other Vehicle:</b>"];
		emailBody = [emailBody stringByAppendingString:@"<BR>Make:"];
		emailBody = [emailBody stringByAppendingString:vehicleMake ];
	
	}

	NSString * vehicleModel = [dictionary objectForKey:moKey];
	if (vehicleModel != nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR>Model:"];
		emailBody = [emailBody stringByAppendingString:vehicleModel ];	
	}

	NSString * vehicleYear = [dictionary objectForKey:yKey];
	if (vehicleYear != nil ) {
		emailBody = [emailBody stringByAppendingString:@"<BR>Year:"];
		emailBody = [emailBody stringByAppendingString:vehicleYear ];	
	
	}

	NSString * licensePlate = [dictionary objectForKey:lpKey];
	if (licensePlate != nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR>License Plate:"];
		emailBody = [emailBody stringByAppendingString:licensePlate ];	
	}


	NSString *ipKey = [key stringByAppendingString:@"-OtherDriverInsurancePolicy"];
	NSString *pnKey = [key stringByAppendingString:@"-OtherDriverPolicyNumber"];
	NSString *edKey = [key stringByAppendingString:@"-OtherDriverExpirationDate"];


	NSString *insuranceCompany = [dictionary objectForKey:ipKey];

	if (insuranceCompany != nil ) {
		emailBody = [emailBody stringByAppendingString:@"<BR><b>Other Driver Insurance:</b>"];
		emailBody = [emailBody stringByAppendingString:@"<BR>company:"];
		emailBody = [emailBody stringByAppendingString:insuranceCompany ];
	
	}
	
	NSString * insurancePolicy =  [dictionary objectForKey:pnKey];

	if (insurancePolicy !=nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR>Policy:"];
		emailBody = [emailBody stringByAppendingString:insurancePolicy ];
	}

	NSString *expiration  = [dictionary objectForKey:edKey];
	if (expiration != nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR>Expiration:"];
		emailBody = [emailBody stringByAppendingString:expiration ];
	}

								
	// Other People involved, names 
	
	NSString *namesKey = [key stringByAppendingString:@"-OtherPeopleListData"];
	NSString *typesKey = [key stringByAppendingString:@"-OtherPeopleTypesListData"];
	
	
	NSMutableArray *namesValues = [dictionary objectForKey:namesKey];
	NSMutableArray *typesValues = [dictionary objectForKey:typesKey];
	if (namesValues != nil) {
		emailBody = [emailBody stringByAppendingString:@"<BR><b>Other People Involved:</b>"];
	}
	
	
	
	NSEnumerator *n = [namesValues objectEnumerator];
	NSEnumerator *t = [typesValues objectEnumerator];
	
	id nObject;
	id tObject;
	while (nObject = [n nextObject]) {
		tObject = [t nextObject];
		
		// do something with object
		emailBody = [emailBody stringByAppendingString:@"<BR>Name:"];
		emailBody = [emailBody stringByAppendingString:(NSString *)nObject ];
		
		emailBody = [emailBody stringByAppendingString:@"<BR>Involvement: "];
		emailBody = [emailBody stringByAppendingString:(NSString *)tObject ];
		
	}
	
	//[NSString stringWithFormat:@"%@\n\n<h3>Sent using the  <a href = '%@'>Accidently</a> iPhone Application. <a href = '%@'>Download</a> yours from AppStore now!</h3>", content, pageLink, iTunesLink];
	
	// finally 
	emailBody = [emailBody stringByAppendingString:@"<BR></body></HTML>"];
	
	
	[picker setMessageBody:emailBody isHTML:YES];
	
	
	/**
	 * Attachments
	 */
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *imagesKey = @"Accidently-";
	imagesKey = [imagesKey stringByAppendingString:reportTitle];
	imagesKey = [imagesKey stringByAppendingString:@"-ImageNames"];
	
	// Populate data from  Dictionary 
	NSMutableArray *imageNames = [dictionary objectForKey: imagesKey];
		
	if (imageNames != nil) {
		int i = [imageNames count];
		while ( i-- ) {
			
			NSString *imagePath = documentsDirectory;
			imagePath = [imagePath stringByAppendingString:@"/"];
			imagePath = [imagePath stringByAppendingString:[imageNames objectAtIndex:i]];			 
			NSData* imageData = [NSData dataWithContentsOfFile:imagePath];
			[picker addAttachmentData:imageData mimeType:@"image/jpg" fileName:[imageNames objectAtIndex:i]];
			
			imagePath = nil;
			imageData = nil;
			
									  
		}
	}
    [self presentModalViewController:picker animated:YES];
	[picker release];
}


// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	[recipientsField resignFirstResponder];
}

// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] Whilesending an email report, Accidently received a a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    recipientsField			= nil;
	sendButton				= nil;
	recipientsLabel			= nil;
	reportTitle				= nil; 
	cancelButton			= nil;
	naviBar					= nil;
	reportSentStatus		= nil;
}


- (void)dealloc {
	[sendButton			release];
	[recipientsField	release];
    [reportTitle		release]; 
	[cancelButton		release];
	[naviBar			release];
	[reportSentStatus	release];
	[[NSNotificationCenter defaultCenter] removeObserver:self]; 
	[super dealloc];
	
}
@end