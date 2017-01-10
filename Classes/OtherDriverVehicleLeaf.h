//
//  OtherDriverVehicleLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"

@interface OtherDriverVehicleLeaf : UIViewController {
	UITextField *ownerField; 
	UITextField *makeField;
	UITextField *modelField;
	UITextField *yearField;
	UITextField *licensePlateField;
	UILabel *ownerLabel;
	UILabel *makeLabel;
	UILabel *modelLabel;
	UILabel *yearLabel;
	UILabel *licensePlateLabel;
	NSString *reportTitle; 
	UIButton *saveButton;
	UIButton *cancelButton;
	UINavigationBar *naviBar;
    UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField *ownerField; 
@property (nonatomic, retain) IBOutlet UITextField *makeField;
@property (nonatomic, retain) IBOutlet UITextField *modelField;
@property (nonatomic, retain) IBOutlet UITextField *yearField; 
@property (nonatomic, retain) IBOutlet UITextField *licensePlateField;
@property (nonatomic, retain) IBOutlet UILabel *ownerLabel;
@property (nonatomic, retain) IBOutlet UILabel *makeLabel;
@property (nonatomic, retain) IBOutlet UILabel *modelLabel;
@property (nonatomic, retain) IBOutlet UILabel *yearLabel;
@property (nonatomic, retain) IBOutlet UILabel *licensePlateLabel;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) NSString *reportTitle;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


// Method Declarations
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(IBAction) save: (id)sender;
-(IBAction) cancel: (id)sender;
-(void) loadDataFromFile; 
-(void) saveDataToFile;


@end
