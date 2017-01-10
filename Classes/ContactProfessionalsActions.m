//
//  ContactProfessionalsActions.m
//  Accident-ly
//
//  Created by Dovik Nissim on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactProfessionalsActions.h"


@implementation ContactProfessionalsActions


@synthesize nameLabel;
@synthesize emailLabel;
@synthesize telLabel;
@synthesize emailButton;
@synthesize telButton;
@synthesize cancelButton;
@synthesize profName;
@synthesize reportTitle;
@synthesize naviBar;
@synthesize profsListData;
@synthesize profsTypesListData;
@synthesize selectedPerson;


NSMutableDictionary *dictionary;


// Render viewDidLoad
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
	[nLabel setFont:[UIFont boldSystemFontOfSize:30]];
	[nLabel release];
	
	UILabel *eLabel = [self emailLabel]; 
	eLabel.textColor = [UIColor whiteColor];
	[eLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[eLabel release];
    
    UILabel *tLabel = [self telLabel]; 
	tLabel.textColor = [UIColor whiteColor];
	[tLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[tLabel release];
    
    //Get the person Object from the dictionary 
    NSString *cKey = [[NSString alloc] initWithString:@"ProfessionalContact-"];
	cKey = [cKey stringByAppendingString: profName];
	NSMutableDictionary *person = [dictionary  objectForKey:cKey];
    
    if (person != nil ) {
        
        //set the selected person
        selectedPerson = person;
        
        // Set the name label
        nameLabel.text = profName;
      
    
        // Set the email label 
        NSString *contactEmail = @"Email: ";
        contactEmail = [contactEmail stringByAppendingString:[person objectForKey:@"p_email"]];
        emailLabel.text = contactEmail;
        //[contactEmail release];
       
        
        // Set the phone number
        NSString *contactTel = @"Tel: ";
        contactTel = [contactTel stringByAppendingString:[person objectForKey:@"p_phone"]];
        telLabel.text = contactTel;
        //[contactTel release];z
    }
}

- (IBAction) cancel: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

// Call the selected person
-(IBAction) callNow:(id)sender {    
    NSString * telNumber = @"tel://";
    telNumber = [telNumber stringByAppendingString:[selectedPerson objectForKey:@"p_phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];  
}

//Email the selected person 
-(IBAction) emailNow: (id) sender {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
        
    // Set the title 
    NSString *subject = @"A note from the Accidently iPhone App";    
    [picker setSubject:subject];
        
    // set the recipient
    NSMutableArray *toRecipients = [[NSMutableArray alloc] init];
    [toRecipients addObject:[selectedPerson objectForKey:@"p_email"]];
    [picker setToRecipients:toRecipients];
		
   
     // Add the email body and the Accidently signature
    NSString *emailBody = [[NSString alloc] initWithString:@"<HTML><head></head><Body>"];
    NSString * accidentlySignature = [NSString stringWithFormat:@"\n\n<B>Sent using the  <a href = '%@'>Accidently iPhone App</a></B>", @"http://itunes.com/apps/accidently"];
    emailBody = [emailBody stringByAppendingString:accidentlySignature];    
    emailBody = [emailBody stringByAppendingString:@"<BR></body></HTML>"];
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

// Text the selected person
-(IBAction) textNow:(id)sender {  

        MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body =  @"[A notefrom the Accidently iPhone App]: ";
            NSMutableArray *toRecipients = [[NSMutableArray alloc] init];
            [toRecipients addObject:[selectedPerson objectForKey:@"p_phone"]];
            controller.recipients = toRecipients;
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
        }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {	
    
    
    
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:{
            NSLog(@"[DEBUG]: Email to professional contact was cancelled.");
			break;
        }
        case MFMailComposeResultSaved:{
            NSLog(@"[DEBUG]: Draft saved for Email to professional contact.");
			break;
        }
		case MFMailComposeResultSent:{
            NSLog(@"[DEBUG]: Email to professional contact was successfully.");
            break;
		}
		case MFMailComposeResultFailed:{
            NSLog(@"[DEBUG]: Failed to send Email to professional contact!");
			break;
		}
    }
    // dismiss the email window.
    [self dismissModalViewControllerAnimated:YES];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"[DEBUG]: SMS to professional contact was cancelled.");
			break;
		case MessageComposeResultFailed:
            NSLog(@"[DEBUG]: Failed to send SMS to professional contact!");
			break;
		case MessageComposeResultSent:
             NSLog(@"[DEBUG]: SMS to professional contact was successfully.");
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


// Get the accidently .plist file path within the documents directory
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
		return;
	}
	
	// if file exists, load Dictionary from file.
    // Load the Dictionary 
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		return;
	}
	
	NSString *key = @"Accidently-";
	NSString *keyNames =@"";
	NSString *keyTypes =@"";
	
	key = [key stringByAppendingString:reportTitle];
    keyNames = [key stringByAppendingString:@"-ContactProfessionalsListData"];
	keyTypes = [key stringByAppendingString:@"-ContactProfessionalsTypesListData"];
	
	// Populate data from  Dictionary 
	profsListData = [dictionary objectForKey:keyNames];
	
	if (profsListData == nil) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.profsListData = array;
		[array release];
	}
	
	profsTypesListData = [dictionary objectForKey:keyTypes];

	if (profsTypesListData == nil) {
		NSMutableArray *tArray = [[NSMutableArray alloc] init];
		self.profsTypesListData = tArray;
		[tArray release];
	}
}


- (void)dealloc
{
    [nameLabel release];
    [emailLabel  release];
    [telLabel  release];
    [emailButton  release];
    [telButton release];
    [cancelButton  release];
    [naviBar release];
    [profName release];
    [profsListData release];
    [profsTypesListData release];
    [reportTitle release];
    [selectedPerson release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    nameLabel           = nil;
    emailLabel          = nil;
    telLabel            = nil;
    emailButton         = nil;
    telButton           = nil;
    cancelButton        = nil;
    naviBar             = nil;
    profName            = nil;
    profsListData       = nil;
    profsTypesListData  = nil;
    reportTitle         = nil;
    selectedPerson      = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
