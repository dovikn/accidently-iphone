//
//  PoliceViewLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"

@interface PoliceViewLeaf : UIViewController {

	UITextField         *policeDepartmentField;
	UITextField         *policeReportNumberField;
	UILabel             *policeDepartmentLabel;
	UILabel             *policeReportNumberLabel;
	NSString            *reportTitle; 
	UIButton            *saveButton; 
	UIButton            *cancelButton;
	UINavigationBar     *navBar;
    UIScrollView        *scrollView;
	
}

@property (nonatomic, retain) IBOutlet UITextField  *policeDepartmentField;
@property (nonatomic, retain) IBOutlet UITextField  *policeReportNumberField;
@property (nonatomic, retain) IBOutlet UILabel      *policeDepartmentLabel;
@property (nonatomic, retain) IBOutlet UILabel      *policeReportNumberLabel;
@property (nonatomic, retain) IBOutlet NSString     *reportTitle;
@property (nonatomic, retain) IBOutlet UIButton     *saveButton;
@property (nonatomic, retain) IBOutlet UIButton     *cancelButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

//Method
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(IBAction) save: (id) sender;
-(IBAction) cancel: (id) sender;
-(void) loadDataFromFile;
-(void) saveDataToFile;



@end