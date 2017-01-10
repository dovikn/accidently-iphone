//
//  DescriptionViewLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"

@interface DescriptionViewLeaf : UIViewController {

	UITextView			*textView;
	UILabel				*textViewLabel;
	NSString			*reportTitle;
	UIButton			*saveButton;
	UIButton			*cancelButton;
	UINavigationBar		*navBar;
    UIScrollView        *scrollView;
}
@property (nonatomic, retain) IBOutlet UITextView	*textView;
@property (nonatomic, retain) IBOutlet UILabel		*textViewLabel;
@property (nonatomic, retain)		   NSString		*reportTitle; 
@property (nonatomic, retain) IBOutlet UIButton		*saveButton; 
@property (nonatomic, retain) IBOutlet UIButton		*cancelButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;
-(void)		saveDataToFile;
-(void)		loadDataFromFile;
-(IBAction) save:(id)sender;
-(IBAction) cancel: (id) sender;


@end