//
//  TowingViewLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"


@interface TowingViewLeaf : UIViewController {
	UITextField             *towingCompanyNameField;
	UITextField             *towingCompanyPhoneNumberField;
	UILabel                 *towingCompanyNameLabel;
	UILabel                 *towingCompanyPhoneNumberLabel;
	NSString                *reportTitle; 
	UIButton                *saveButton;
	UIButton                *cancelButton;
	UINavigationBar         *naviBar;
    UIScrollView            *scrollView;

}

@property (nonatomic, retain) IBOutlet UITextField  *towingCompanyNameField;
@property (nonatomic, retain) IBOutlet UITextField  *towingCompanyPhoneNumberField;
@property (nonatomic, retain) IBOutlet UILabel      *towingCompanyNameLabel;
@property (nonatomic, retain) IBOutlet UILabel      *towingCompanyPhoneNumberLabel;
@property (nonatomic, retain) IBOutlet NSString     *reportTitle; 
@property (nonatomic, retain) IBOutlet UIButton     *saveButton;
@property (nonatomic, retain) IBOutlet UIButton     *cancelButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

//Methods
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(IBAction) save: (id)sender;
-(IBAction) cancel: (id)sender;
-(void) loadDataFromFile;
-(void) saveDataToFile;
	
@end
