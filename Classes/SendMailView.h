//
//  SendMailView.h
//  Accident-ly
//
//  Created by Dovik Nissim on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#define kFileName @"accidently.plist"

@interface SendMailView : UIViewController <MFMailComposeViewControllerDelegate>{
	
	UITextField			*recipientsField;
	UIButton			*sendButton;
	UIButton			*cancelButton;
	UILabel				*recipientsLabel;
	NSString			*reportTitle;
	UINavigationBar		*naviBar;
	NSMutableDictionary *reportSentStatus;
}

@property (nonatomic, retain) IBOutlet UITextField		*recipientsField;
@property (nonatomic, retain) IBOutlet UIButton			*sendButton;
@property (nonatomic, retain) IBOutlet UIButton			*cancelButton;
@property (nonatomic, retain) IBOutlet UINavigationBar	*naviBar;
@property (nonatomic, retain) IBOutlet UILabel			*recipientsLabel;;
@property (nonatomic, retain) NSString					*reportTitle;
@property (nonatomic, retain) NSMutableDictionary		*reportSentStatus;

-(IBAction) backgroundTap: (id)sender;
-(IBAction) textFieldDoneEditing: (id)sender;	 
-(IBAction) sendMail: (id) sender;
-(IBAction) mailIt;
-(IBAction) cancel: (id) sender;
-(void) loadDataFromFile;
-(void) saveDataToFile;

	 
@end
