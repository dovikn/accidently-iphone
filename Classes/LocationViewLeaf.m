//
//  LocationViewLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationViewLeaf.h"


@implementation LocationViewLeaf

@synthesize addressField;
@synthesize cityField;
@synthesize stateField;
@synthesize addressLabel;
@synthesize cityLabel;
@synthesize stateLabel;
@synthesize reportTitle;
@synthesize saveButton, cancelButton;
@synthesize navBar;
@synthesize locateMeButton;
@synthesize myLocation;
@synthesize scrollView;

NSMutableDictionary *dictionary;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadDataFromFile];


	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	[navBar setTintColor:[UIColor blackColor]];
    
	UILabel *aLabel = [self addressLabel];
	aLabel.textColor = [UIColor whiteColor];
	[aLabel setFont:[UIFont boldSystemFontOfSize:30]];
	[aLabel release];
	
	UILabel *cLabel = [self cityLabel];
	cLabel.textColor = [UIColor whiteColor];
	[cLabel setFont:[UIFont boldSystemFontOfSize:30]];
	[cLabel release];
	
	
	UILabel *sLabel = [self stateLabel];
	sLabel.textColor = [UIColor whiteColor];
	[sLabel setFont:[UIFont boldSystemFontOfSize:30]];
	[sLabel release];

    
    // enable scrolling:
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocatio{
    
    // Convert longtitude/ latitude to an address: 
    CLLocationCoordinate2D coord = [newLocation coordinate];
	
    
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
	[geocoder setDelegate:self];
	[geocoder start];
    
	// Stop the location updates
	[locationManager stopUpdatingLocation];
 
}
//

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSLog(@"DEBUG: Location Identification successful, Reverse Geocoder completed successfully!"); 
    MKPlacemark *myPlacemark = placemark;
    
    
    if (myPlacemark != nil) {
        NSString * myAddress = [myPlacemark.addressDictionary objectForKey:(NSString *) kABPersonAddressStreetKey];
        NSString * myCity = [myPlacemark.addressDictionary objectForKey:(NSString *) kABPersonAddressCityKey];
        NSString * myState = [myPlacemark.addressDictionary objectForKey:(NSString *) kABPersonAddressStateKey];
        NSString * myCountry = [myPlacemark.addressDictionary objectForKey:(NSString *) kABPersonAddressCountryKey];
        NSString * myZipcode = [myPlacemark.addressDictionary objectForKey:(NSString *) kABPersonAddressZIPKey];
        
        // Address
        if (myAddress != nil) {
            self.addressField.text = myAddress;
            //[myAddress release];
        }
        
        
        // city 
        if (myCity != nil) {
            self.cityField.text = myCity;
            [myCity release];
        }
        
        
        NSString *stateCountryZip = @""; 
        
        // State 
        if (myState != nil) {
            stateCountryZip = [stateCountryZip stringByAppendingString:myState];
            [myState release];
        }
       
        
        // Country
        if (myCountry != nil) {
            stateCountryZip = [stateCountryZip stringByAppendingString:@", "];
            stateCountryZip = [stateCountryZip stringByAppendingString:myCountry];
            //[myCountry release];
        }
        
        
        if (myZipcode != nil) {
            stateCountryZip = [stateCountryZip stringByAppendingString:@", "];
            stateCountryZip = [stateCountryZip stringByAppendingString:myZipcode];
            //[myZipcode release];
        }
       
        
        if ([stateCountryZip length] > 0) {
            self.stateField.text = stateCountryZip;
            //[stateCountryZip release];
        }
        
    }
    
    
    NSLog(@"Address of placemark: %@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO));  
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
   NSLog(@"DEBUG: Location Identification failed, Reverse Geocoder Errored. The Error: %@", error); 
   self.addressField.text =@ "Location unknown";
}



- (IBAction) locateMe: (id) sender {
	// Instantiate the locationManager
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move.
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //100m
	[locationManager startUpdatingLocation];
}

-(void) viewWillDisappear:(BOOL)animated {
	[self saveDataToFile];
}

- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

-(IBAction) backgroundTap: (id)sender {
	[addressField resignFirstResponder];
	[cityField resignFirstResponder];
	[stateField resignFirstResponder];
}

-(IBAction) save:(id) sender {

	[self saveDataToFile];
	[self dismissModalViewControllerAnimated:YES];
	
	
}

-(IBAction) cancel:(id) sender {

	[self dismissModalViewControllerAnimated:YES];
	
}
//

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
	
	NSString *addresKey = @"-Address";
	addresKey = [key stringByAppendingString: addresKey];

	NSString *cityKey = @"-City";
	cityKey = [key stringByAppendingString: cityKey];
	
	NSString *stateKey = @"-State";
	stateKey = [key stringByAppendingString: stateKey];
	
	
	// populate data from  Dictionary 
	addressField.text = [dictionary objectForKey:addresKey];
	cityField.text = [dictionary objectForKey:cityKey];
	stateField.text = [dictionary objectForKey:stateKey];
}


-(void) saveDataToFile {
	
	NSString *key = @"Accidently-";
	key = [key stringByAppendingString:reportTitle];
	
	NSString *addressKey = @"-Address";
	addressKey = [key stringByAppendingString: addressKey];
	
	NSString *cityKey = @"-City";
	cityKey = [key stringByAppendingString: cityKey];
	
	NSString *stateKey = @"-State";
	stateKey = [key stringByAppendingString: stateKey];
	
	
	// set the values to the dictionary 
	
	if (addressField.text == nil) {
		addressField.text = @"";
	}
	if (cityField.text == nil) {
		cityField.text = @"";
	}	
	if (stateField.text == nil) {
		stateField.text = @"";
	}
	
	
	[dictionary setObject:addressField.text forKey:addressKey];
	[dictionary setObject:cityField.text forKey:cityKey];
	[dictionary setObject:stateField.text forKey:stateKey];

	
	//Otherwise save/ persist the contents of dictionary to the .plist.

	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While saving information about the Location  (LocationViewLeaf), Failed to save data to Accidently.plist file!");
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about location, Accidently received a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}

/**
 * If the Location Manager failed
 **/

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error{
    NSLog(@"[ERROR] LocationManager failed with error %@.",error);   
    
    // Present an alert for that 
  	UIAlertView *failedToLocateAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Alert!"
                                     message:@"Failed to find your current location, please type in your location details."
                                     delegate: self
                                     cancelButtonTitle: @"OK"
                                     otherButtonTitles:nil];
    [failedToLocateAlert show];
    [failedToLocateAlert release];
}


- (void)viewDidUnload {
	addressField=nil;
	cityField = nil;
	stateField =nil;
	reportTitle =nil;
	dictionary = nil;
	saveButton = nil;
	cancelButton = nil;
	navBar= nil;
	locateMeButton = nil;;
	myLocation = nil;
    scrollView      = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [reportTitle release];
	[saveButton release];
	[cancelButton release];
	[addressField release];
	[cityField release];
	[stateField release];
	[dictionary release];
	[navBar release];
	[locateMeButton release];
    [scrollView release];
	[myLocation release];
	[super dealloc];
}



@end
