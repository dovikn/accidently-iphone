//
//  LocationViewLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Corelocation/CoreLocation.h>
#define kFileName @"accidently.plist"



@interface LocationViewLeaf : UIViewController <CLLocationManagerDelegate, MKReverseGeocoderDelegate>{
	UITextField         *addressField;
	UITextField         *cityField;
	UITextField         *stateField;
	UILabel             *addressLabel;
	UILabel             *cityLabel; 
	UILabel             *stateLabel;
	NSString            *reportTitle;
	UIButton            *saveButton;
	UIButton            *cancelButton;
	UIButton            *locateMeButton; 
	UINavigationBar     *navBar;
	CLLocationManager   *locationManager;
	CLLocation          *myLocation;
    UIScrollView        *scrollView;
}
@property (nonatomic, retain) IBOutlet UITextField      *addressField;
@property (nonatomic, retain) IBOutlet UITextField      *cityField;
@property (nonatomic, retain) IBOutlet UITextField      *stateField;
@property (nonatomic, retain) IBOutlet UILabel          *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel          *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel          *stateLabel;
@property (nonatomic, retain)  NSString                 *reportTitle; 
@property (nonatomic, retain) IBOutlet UIButton         *saveButton; 
@property (nonatomic, retain) IBOutlet UIButton         *cancelButton;
@property (nonatomic, retain) IBOutlet UINavigationBar  *navBar;
@property (nonatomic, retain) IBOutlet UIButton         *locateMeButton;
@property (nonatomic, retain) CLLocation                *myLocation;
@property (nonatomic, retain) IBOutlet UIScrollView              *scrollView;

//Methods
-(IBAction) locateMe: (id) sender;
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(void)		saveDataToFile;
-(void)		loadDataFromFile;
-(IBAction) save:(id)sender;
-(IBAction) cancel: (id) sender;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation ;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;



@end
