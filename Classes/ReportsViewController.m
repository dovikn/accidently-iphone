//
//  ReportsViewController.m
//  Accident-ly
//
//  Created by Dovik Nissim on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReportsViewController.h";


@implementation ReportsViewController


@synthesize listData;
@synthesize reportDetailedView;
@synthesize titleLabel;
@synthesize reportSentStatus;
@synthesize bannerView;


NSMutableDictionary *dictionary;


- (void)viewDidLoad {	
	[super viewDidLoad];
	
	// Set the title
	self.title= @"Reports";
	
	// Set the background image
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	UINavigationBar *navBar = [self.navigationController navigationBar];
	[navBar setTintColor:[UIColor blackColor]];

	// Add the plus sign on the top right (in the navigation bar)
	UIBarButtonItem *addButton  =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
																			  target: self
																			  action:@selector(navigateToAddNewReport:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Add left button to the top left of the Navigation bar 
   	UIBarButtonItem *callButton  =[[UIBarButtonItem alloc]initWithTitle:@"911"  
                                                            style:  UIBarButtonItemStylePlain
                                                            target: self
                                                            action: @selector(navigateToCall911:)];
    self.navigationItem.leftBarButtonItem = callButton;

    
    // Add the Banner view 
    // Create a view of the standard size at the bottom of the screen.
    self.bannerView = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                                self.view.frame.size.height -90,
                                                GAD_SIZE_320x50.width,
                                                GAD_SIZE_320x50.height )];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView.adUnitID = @"a14efd3818e7f14";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView.rootViewController = self;
    [self.view addSubview:bannerView];
    
    // Initiate a generic request to load it with an ad.
    [bannerView loadRequest:[GADRequest request]];

    [addButton release];
    [callButton release];
}

/**
 * Add a new report
 */

-(IBAction) navigateToAddNewReport:(id) sender {
	
	DateAndTimeLeaf *newReportView = [[DateAndTimeLeaf alloc] initWithNibName:@"DateAndTimeLeaf" bundle:nil];
	newReportView.addFlag = YES;
	[self presentModalViewController:newReportView animated:YES];
}

// Get the accidently .plist file path within the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

/**
 ** Call 911
 **/
-(IBAction)navigateToCall911 : (id) sender {
 
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Confirm"];
	[alert setMessage:@"Are you sure you want to call 911?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Call"];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        // No
        NSLog (@"[INFO] The user has canceled a request to call 911");
        return;
	}
	else if (buttonIndex == 1)
	{
        // Yes, 
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://911"]];
        return;
    }
}

//
// load the data from the .plist file
-(void) loadDataFromFile {
	
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		return;
	}
	
	// Load the Dictionary 
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		return;
	}
	
	// Populate data from  Dictionary 
	
	listData = [dictionary objectForKey:@"Accidently-Reports"];
	
	
	if (listData == nil) {
		listData = [[NSArray alloc] init];
	}
	
	reportSentStatus = [dictionary objectForKey:@"Accidently-ReportSentStatus"];
	
	if (reportSentStatus == nil) {
		reportSentStatus = [[NSMutableDictionary alloc] init];
	}
	
}

-(void) saveDataToFile {
	
	// In  case the dictionary is nil
	if (dictionary == nil) {
		dictionary =[[NSMutableDictionary alloc] init];
	}
	
	// Add an item to the dictionary 
	[dictionary setValue:listData forKey:@"Accidently-Reports"];
	
	//Set the report email sent statuses to the Dictionary
	[dictionary setValue:reportSentStatus forKey:@"Accidently-ReportSentStatus"];
	
	//Persist the  contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL res = [dictionary writeToFile:dataFile atomically:YES];
	if (res == NO) {
		NSLog(@"[ERROR]: While saving information about Reports (ReportsViewController), Failed to save data to Accidently.plist file!");
	}
}

// Navigate to the subview to create another report.
-(IBAction) navigateToReportDetailedView:(id)sender {
	
	if (reportDetailedView == nil) {
		reportDetailedView = [[DateAndTimeLeaf alloc] initWithNibName:@"DateAndTimeLeaf" bundle:nil];
	}

	
   
	//Display new view as modal window
	[self presentModalViewController:reportDetailedView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[self loadDataFromFile];
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	return [self.listData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString * generalIdentifier = @"GeneralIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: generalIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier: generalIdentifier] autorelease];
	}
	
	// Change the text color to White
	cell.textLabel.textColor = [UIColor whiteColor]; 
	NSUInteger row = [indexPath row];
	
	NSString *reportName = [listData objectAtIndex: row];
	// Set the text label
	cell.textLabel.text = reportName;
	
	
	NSString *sentStatus = [reportSentStatus valueForKey: reportName];
	NSInteger sentStatusInt = [sentStatus intValue];
	if (sentStatusInt == 1) {
		cell.detailTextLabel.text = @"Pending";
	} else{
		cell.detailTextLabel.text = @"Sent";
	}
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	[reportName release];
	
	
	// set the details icon
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	return cell;
}

/**
 ** The user selected a report 
 **/
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	RootViewController *rootView = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    
    // Get the active report
    reportTitle = [listData objectAtIndex:row];
    
    // Save the active report
    NSString *activeReportKey = @"Accidently-ActiveReport"; 
    [dictionary setObject:reportTitle forKey: activeReportKey];
    [self saveDataToFile];
    
    // Set the active report on the next page.
	rootView.reportTitle = reportTitle;
	[self.navigationController pushViewController:rootView animated:YES];
}


/*
 * Handling the delete.
 */

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

-  (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    NSUInteger row = [indexPath row];
    NSUInteger count = [listData count];
	
    if (row < count) {
        
        [self deleteReportFromDictionary:row];
    
    
    }
}

/**
 ** Delete the report from the dictionary
 **/
- (void) deleteReportFromDictionary: (NSUInteger) row {

    NSString *deletedReportName = [[NSString alloc] initWithString:[listData objectAtIndex:row]];
   
    NSString *key = @"Accidently-";
    key = [key stringByAppendingString:deletedReportName];
    
     // Delete the report name from the dictionary 
    NSString *dKey = [key stringByAppendingString:@"-DateAndTime"];
    [dictionary removeObjectForKey:dKey];
    
    //Delete the report from the status list
    [reportSentStatus removeObjectForKey:deletedReportName];
    
    // delete the tip presented key
    NSString *tKey = [key stringByAppendingString: @"-tipPresented"];
    NSString *tipPresented = [dictionary objectForKey:tKey];
    if ([tipPresented isEqualToString:@"YES"]) {
        [dictionary removeObjectForKey: tKey];
    }
    
    // Delete the report's imagenames
    NSString *inKey = [key stringByAppendingString: @"-ImageNames"];
    NSMutableArray *images = [dictionary objectForKey:inKey];
    if (images != nil ){
        [dictionary removeObjectForKey: inKey];
    }
   
    
    //must haves
    NSString *nameKey  = [key stringByAppendingString:@"-OtherDriverName"];	
    NSString *nameVal  = [dictionary objectForKey:nameKey];
    if (nameVal != nil ){
        [dictionary removeObjectForKey: nameKey];
    }
	
    NSString *maKey = [key stringByAppendingString:@"-OtherDriverVehicleMake"];
    NSString *maVal  = [dictionary objectForKey:maKey];
    if (maVal != nil ){
        [dictionary removeObjectForKey: maKey];
    }
    
    NSString *moKey = [key stringByAppendingString:@"-OtherDriverVehicleModel"];
    NSString *moVal  = [dictionary objectForKey:moKey];
    if (moVal != nil ){
        [dictionary removeObjectForKey: moKey];
    }
	
    NSString *yKey =[key stringByAppendingString:@"-OtherDriverVehicleYear"];
	NSString *yVal  = [dictionary objectForKey:yKey];
    if (yVal != nil ){
        [dictionary removeObjectForKey: yKey];
    }
    
    // remove the Descriprion information 
    NSString *descKey = [key stringByAppendingString: @"-Description"];
    NSString *descVal  = [dictionary objectForKey:descKey];
    if (descVal != nil ){
        [dictionary removeObjectForKey: descKey];
    }
    
    //Remove the location information 
	NSString *addressKey = [key stringByAppendingString: @"-Address"];
    NSString *addressVal  = [dictionary objectForKey:addressKey];
    if (addressVal != nil ){
        [dictionary removeObjectForKey: addressKey];
    }
    
	NSString *cityKey = [key stringByAppendingString: @"-City"];
    NSString *cityVal  = [dictionary objectForKey:cityKey];
    if (cityVal != nil ){
        [dictionary removeObjectForKey: cityKey];
    }
    
	NSString *stateKey = [key stringByAppendingString: @"-State"];
    NSString *stateVal  = [dictionary objectForKey:stateKey];
    if (stateVal != nil ){
        [dictionary removeObjectForKey: stateKey];
    }
    
    // Remove the Police Report information
	NSString *pdKey = [key stringByAppendingString:@"-PoliceDepartmentInvestigating"];
    NSString *pdVal  = [dictionary objectForKey:pdKey];
    if (pdVal != nil ){
        [dictionary removeObjectForKey: pdKey];
    }
    
	NSString *pdrnKey = [key stringByAppendingString:@"-PoliceReportNumber"];
    NSString *pdrnVal  = [dictionary objectForKey:pdrnKey];
    if (pdrnVal != nil ){
        [dictionary removeObjectForKey: pdrnKey];
    }
    
    
    // remove the Towing company information
    NSString *tcKey = [key stringByAppendingString:@"-TowingCompanyName"];
    NSString *tcVal  = [dictionary objectForKey:tcKey];
    if (tcVal != nil ){
        [dictionary removeObjectForKey: tcKey];
    }
    
	NSString *pnKey = [key stringByAppendingString:@"-TowingCompanyPhoneNumber"];
    NSString *pnVal  = [dictionary objectForKey:pnKey];
    if (pnVal != nil ){
        [dictionary removeObjectForKey: pnKey];
    }
    
    // Removing the other driver's information 
    NSString *otherNameKey  = [key stringByAppendingString:@"-OtherDriverName"];
    NSString *otherNameVal  = [dictionary objectForKey:otherNameKey];
	if (otherNameVal != nil ){
        [dictionary removeObjectForKey: otherNameKey];
    }
    
    NSString *otherAddressKey = [key stringByAppendingString:@"-OtherDriverAddress1"];
    NSString *otherAddressVal = [dictionary objectForKey:otherAddressKey];
    if (otherAddressVal != nil ){
        [dictionary removeObjectForKey: otherAddressKey];
    }
    
	NSString *hpKey  = [key stringByAppendingString:@"-OtherDriverHomePhone"];
    NSString *hpVal  = [dictionary objectForKey:hpKey];
	if (hpVal!= nil ){
        [dictionary removeObjectForKey: hpKey];
    }
    
    NSString *cpKey = [key stringByAppendingString:@"-OtherDriverCellPhone"];
    NSString *cpVal  = [dictionary objectForKey:cpKey];
    if (cpVal != nil ){
        [dictionary removeObjectForKey: cpKey];
    }
    
	NSString *lnKey = [key stringByAppendingString:@"-OtherDriverLicenseNumber"];
    NSString *lnVal  = [dictionary objectForKey:lnKey];
    if (lnVal != nil ){
        [dictionary removeObjectForKey: lnKey];
    }
    
    NSString *oKey = [key stringByAppendingString:@"-OtherDriverVehicleOwner"];
    NSString *oVal  = [dictionary objectForKey:oKey];
    if (oVal != nil ){
        [dictionary removeObjectForKey: oKey];
    }
    
    // remove the other driver's vehicle information 
	NSString *lpKey = [key stringByAppendingString:@"-OtherDriverVehicleLicensePlate"];
    NSString *lpVal  = [dictionary objectForKey:lpKey];
    if (lpVal != nil ){
        [dictionary removeObjectForKey: lpKey];
    }
    
	NSString *ipKey = [key stringByAppendingString:@"-OtherDriverInsurancePolicy"];
    NSString *ipVal  = [dictionary objectForKey:ipKey];
    if (ipVal != nil ){
        [dictionary removeObjectForKey: ipKey];
    }
    
    NSString *odpnKey = [key stringByAppendingString:@"-OtherDriverPolicyNumber"];
    NSString *odpnVal  = [dictionary objectForKey:odpnKey];
    if (odpnVal != nil ){
        [dictionary removeObjectForKey: odpnKey];
    }
    
    
	NSString *edKey = [key stringByAppendingString:@"-OtherDriverExpirationDate"];
    NSString *edVal  = [dictionary objectForKey:edKey];
    if (edVal != nil ){
        [dictionary removeObjectForKey: edKey];
    }
    
    // Remove other people's involved data:
    
    
    NSString        *kNamesKey = [key stringByAppendingString:@"-OtherPeopleListData"];
    NSMutableArray  *kNamesVal = [dictionary objectForKey:kNamesKey]; 
    if (kNamesVal != nil ){
        
        // walk through it 
        
        if ( [kNamesVal count] > 0 ) {
            
            int i = [kNamesVal count];
            while ( i-- ) {
                
                NSString *contactNameKey = @"Contact-"; 
                contactNameKey = [contactNameKey stringByAppendingString:[kNamesVal objectAtIndex:i]];
                               
                NSString *contactVal = [dictionary objectForKey:contactNameKey];
                if (contactVal != nil) {
                    [dictionary removeObjectForKey:contactNameKey];
                }
                
                contactNameKey = nil;
                contactVal = nil;     
            }
            
        }
        // remove the list
        [dictionary removeObjectForKey: kNamesKey];
    }
        
    NSString *kTypesKey = [key stringByAppendingString:@"-OtherPeopleTypesListData"];
    NSMutableArray *kTypesVal  = [dictionary objectForKey:kTypesKey];
    if (kTypesVal != nil ){
        [dictionary removeObjectForKey: kTypesKey];
    }
    
    // Remove the professional contacts data
    NSString        *kcpNamesKey = [key stringByAppendingString:@"-ContactProfessionalsListData"];
    NSMutableArray  *kcpVal = [dictionary objectForKey:kcpNamesKey];
    if (kcpVal != nil ){
        
        // walk through it 
        
        if ( [kcpVal count] > 0 ) {
            
            int i = [kcpVal count];
            while ( i-- ) {
                
                NSString *profContactNameKey = @"ProfessionalContact-"; 
                profContactNameKey = [profContactNameKey stringByAppendingString:[kcpVal objectAtIndex:i]];
                
                NSString *profContactVal = [dictionary objectForKey:profContactNameKey];
                if (profContactVal != nil) {
                    [dictionary removeObjectForKey:profContactNameKey];
                }
                
                profContactNameKey = nil;
                profContactVal = nil;     
            }
            
        }
        // remove the list
        [dictionary removeObjectForKey: kcpNamesKey];
    }
    
	NSString *kcpTypesKey = [key stringByAppendingString:@"-ContactProfessionalsTypesListData"];
    NSMutableArray *kcpTypesVal  = [dictionary objectForKey:kcpTypesKey];
    if (kcpTypesVal != nil ){
        [dictionary removeObjectForKey: kcpTypesKey];
    }
    
    // Delete the object from ListData
    [listData removeObjectAtIndex:row];
    
    // Save the new list data
    [self saveDataToFile];
    
    
    //load data from file 
    [self loadDataFromFile];
    
    // Refresh the table view
    [self.tableView reloadData];

}

/**
 * Refresh Display 
 */
- (void)refreshDisplay:(UITableView *)tableView {
    [tableView reloadData]; 
}


/**
 * Edit 
 */

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	NSString *reporTitle = [listData objectAtIndex:row];
	
	DateAndTimeLeaf * detailedView = [[DateAndTimeLeaf alloc] initWithNibName:@"DateAndTimeLeaf" bundle:nil];
	detailedView.reportTitle = reporTitle;
	detailedView.addFlag = NO;
	
	//Display new view as modal window
	[self presentModalViewController:detailedView animated:YES];
}   

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about reports, Accidently received a a memory warning!");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	listData            = nil;
	reportDetailedView	= nil;
	reportSentStatus    = nil;
    bannerView          = nil;
}

- (void)dealloc {
	[reportDetailedView release];
	[listData           release];
	[reportSentStatus   release];
    [bannerView         release];
    [super              dealloc];
}
@end

