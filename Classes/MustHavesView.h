//
//  MustHavesView.h
//  Accident-ly
//
//  Created by Dovik Nissim on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"


@interface MustHavesView : UIViewController {
	UITextField		*nameField;
	UILabel			*nameLabel;
	UITextField		*carMakeModelYearField;
	UILabel			*carMakeModelYearLabel;
	UITextField		*cellPhoneField;
	UILabel			*cellPhoneLabel;
	UITextField		*insuranceNumberField;
	UILabel			*insuranceNumberLabel;
	NSString		*reportTitle; 
	UIButton		*saveButton; 
	UIButton		*cancelButton;
    UIScrollView    *scrollView; 
}

@property (nonatomic, retain) IBOutlet UITextField      *nameField;
@property (nonatomic, retain) IBOutlet UILabel          *nameLabel;
@property (nonatomic, retain) IBOutlet UITextField      *carMakeModelYearField;
@property (nonatomic, retain) IBOutlet UILabel          *carMakeModelYearLabel;
@property (nonatomic, retain) IBOutlet UITextField      *cellPhoneField;
@property (nonatomic, retain) IBOutlet UILabel          *cellPhoneLabel;
@property (nonatomic, retain) IBOutlet UITextField      *insuranceNumberField;
@property (nonatomic, retain) IBOutlet UILabel          *insuranceNumberLabel;
@property (nonatomic, retain) IBOutlet UIButton         *saveButton;
@property (nonatomic, retain) IBOutlet UIButton         *cancelButton;
@property (nonatomic, retain) NSString                  *reportTitle;
@property (nonatomic, retain) IBOutlet UIScrollView     *scrollView;



-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(IBAction) save: (id)sender;
-(IBAction) cancel: (id)sender;
-(IBAction) saveDataToFile;
-(IBAction) loadDataFromFile;

@end