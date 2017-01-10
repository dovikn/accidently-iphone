//
//  OtherDriverInsuranceLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"


@interface OtherDriverInsuranceLeaf : UIViewController {
	UITextField *insuranceCompanyField;;
	UITextField *policyNumberField;;
	UITextField *expirationDateField;;
	UILabel *insuranceCompanyLabel;
	UILabel *policyNumberLabel;
	UILabel *expirationDateLabel;
	UILabel *viewTitle;
	NSString *reportTitle;
	UIButton *saveButton;
	UIButton *cancelButton;
	UINavigationBar *naviBar;
    UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField *insuranceCompanyField;
@property (nonatomic, retain) IBOutlet UITextField *policyNumberField;;
@property (nonatomic, retain) IBOutlet UITextField *expirationDateField;

@property (nonatomic, retain) IBOutlet UILabel *insuranceCompanyLabel;
@property (nonatomic, retain) IBOutlet UILabel *policyNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *expirationDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *viewTitle;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet NSString *reportTitle;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


// Method Declaration
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(IBAction) save: (id) sender;
-(IBAction) cancel: (id) sender;
-(void) loadDataFromFile;
-(void) saveDataToFile;
@end
