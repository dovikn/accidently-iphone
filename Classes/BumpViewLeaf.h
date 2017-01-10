//
//  BumpViewLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "BumpAPI.h"
#import "Bumper.h"


@interface BumpViewLeaf : UIViewController <BumpAPIDelegate> {

	UITextField     *nameField;
	UITextField     *phoneField;
	UITextField     *emailField;
	UIButton        *bumpButton;
	UIButton        *cancelButton;
	NSMutableArray  *listData;
	NSMutableArray  *typesListData;
	UILabel         *nameLabel;
	UILabel         *phoneLabel;
	UILabel         *emailLabel;
	NSString        *reportTitle; 
    UINavigationBar *naviBar;
    BumpAPI         *bumpObject;
    UIScrollView    *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField  *nameField;
@property (nonatomic, retain) IBOutlet UITextField  *phoneField;
@property (nonatomic, retain) IBOutlet UIButton     *bumpButton;
@property (nonatomic, retain) IBOutlet UIButton     *cancelButton;
@property (nonatomic, retain) NSMutableArray        *listData;
@property (nonatomic, retain) NSMutableArray        *typesListData;
@property (nonatomic, retain) IBOutlet UILabel      *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel      *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel      *phoneLabel;
@property (nonatomic, retain) IBOutlet UITextField  *emailField;
@property (nonatomic, retain) NSString              *reportTitle;
@property (nonatomic, retain) IBOutlet UINavigationBar       *naviBar;
@property (nonatomic, retain) BumpAPI               *bumpObject;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


// Method Declarations.
- (IBAction) textFieldDoneEditing:   (id) sender;
- (IBAction) backgroundTap:          (id)sender;
- (IBAction) saveAndBump:            (id) sender;
- (IBAction) cancel:                 (id) sender;
- (void) loadDataFromFile;
- (void) saveDataToFile;

- (BOOL) isInternetConnectionAvailable;
- (void) configBump;
- (void) startBump;

@end