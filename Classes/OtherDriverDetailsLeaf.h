//
//  OtherDriverDetailsLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"


@interface OtherDriverDetailsLeaf : UIViewController {
	UITextField *nameField;
	UILabel *nameLabel;
	UITextField *address1Field;
	UILabel *addressLabel;
	UITextField *homePhoneField;
	UILabel *phoneLabel;
	UITextField *cellPhoneField;
	UITextField *licenseNumberField;
	UILabel *licenseNumberLabel;
	NSString *reportTitle; 
	UIButton *saveButton; 
	UIButton *cancelButton;
	UINavigationBar *naviBar;
    UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *address1Field;
@property (nonatomic, retain) IBOutlet UITextField *homePhoneField;
@property (nonatomic, retain) IBOutlet UITextField *cellPhoneField;
@property (nonatomic, retain) IBOutlet UITextField *licenseNumberField;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *licenseNumberLabel;
@property (nonatomic, retain) NSString *reportTitle;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

//Method Declarations
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(IBAction) save: (id)sender;
-(IBAction) cancel: (id)sender;
-(IBAction) saveDataToFile;
-(IBAction) loadDataFromFile;

@end
