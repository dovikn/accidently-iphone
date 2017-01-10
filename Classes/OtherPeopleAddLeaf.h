//
//  OtherPeopleAddLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h";

#define kFileName @"accidently.plist"


@interface OtherPeopleAddLeaf : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	UIPickerView *typeOfPersonPicker;
	NSArray *pickerDataSource;
	NSString *pickerSelected;
	UITextField *nameField;
	UITextField *phoneField;
	UITextField *emailField;
	UIButton *addButton;
	UIButton *cancelButton;
	NSMutableArray *listData;
	NSMutableArray *typesListData;
	NSString *selectedPerson;
	NSUInteger selectedIndex;
    UILabel *typeLabel;
	UILabel *nameLabel;
	UILabel *phoneLabel;
	UILabel *emailLabel;
	UILabel *viewTitle;
	NSString *reportTitle; 
    UINavigationBar *naviBar;
    UIScrollView    *scrollBar;
    NSMutableDictionary  *activePerson;
}

@property (nonatomic, retain) IBOutlet UIPickerView *typeOfPersonPicker;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *phoneField;
@property (nonatomic, retain) NSArray *pickerDataSource;
@property (nonatomic, retain) NSString *pickerSelected;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSMutableArray *typesListData;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *viewTitle;
@property (nonatomic, retain) IBOutlet UITextField * emailField;
@property (nonatomic, retain) NSString *selectedPerson;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, retain) NSString *reportTitle;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *activePerson;


// Mehod definitisions
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(IBAction) savePerson: (id) sender;
-(IBAction) cancelAction: (id) sender;
-(void) loadDataFromFile;
-(void) saveDataToFile;

@end