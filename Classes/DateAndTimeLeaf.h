//
//  DateAndTimeLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"

//DEBUG
#import <objc/runtime.h>


@interface DateAndTimeLeaf : UIViewController <UIPickerViewDelegate> {
	BOOL				addFlag;
	UILabel				*reportNameLabel;
	UITextField			*textField;
	UILabel				*dateLabel;
	UIButton			*saveButton;
	UIButton			*cancelButton;
	NSMutableArray		*reportsList;
	NSMutableDictionary *reportSentStatus;
	NSString			*dateAsString;
	NSString			*reportTitle;
	UINavigationBar		*naviBar;
	
}

@property (nonatomic) BOOL addFlag; 
@property (nonatomic, retain) IBOutlet UILabel  *reportNameLabel;
@property (nonatomic, retain) IBOutlet UILabel  *dateLabel;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) NSString *dateAsString;
@property (nonatomic, retain) NSString *reportTitle;
@property (nonatomic, retain) NSMutableDictionary *reportSentStatus;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;

-(NSString *)dataFilePath;
- (void) loadDataFromFile;
- (IBAction) saveDataToFile;
-(IBAction) cancelReport:(id) sender;
-(BOOL) reportNameExists:(NSString *) name;
	
// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender;

// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender;


@end
