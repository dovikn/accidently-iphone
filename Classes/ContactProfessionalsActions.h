//
//  ContactProfessionalsActions.h
//  Accident-ly
//
//  Created by Dovik Nissim on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"
#import <MessageUI/MessageUI.h>

@interface ContactProfessionalsActions : UIViewController <MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate> {
    UILabel         *nameLabel;
    UILabel         *emailLabel;
    UILabel         *telLabel;
    UIButton        *emailButton;
    UIButton        *telButton;
    UIButton        *cancelButton;
    NSString        *profName;
    NSString        *reportTitle;
    UINavigationBar *naviBar;
    NSMutableArray  *profsListData;
    NSMutableArray  *profsTypesListData;
    NSMutableDictionary *selectedPerson;
}

@property (retain, nonatomic) IBOutlet UILabel           *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel           *emailLabel;
@property (retain, nonatomic) IBOutlet UILabel           *telLabel;
@property (retain, nonatomic) IBOutlet UIButton          *emailButton;
@property (retain, nonatomic) IBOutlet UIButton          *telButton;
@property (retain, nonatomic) IBOutlet UIButton          *cancelButton;
@property (retain, nonatomic) NSString                   *profName;
@property (retain, nonatomic) NSString                   *reportTitle;
@property (retain, nonatomic) IBOutlet UINavigationBar   *naviBar;
@property (nonatomic, retain) IBOutlet NSMutableArray    *profsListData;
@property (nonatomic, retain) IBOutlet NSMutableArray    *profsTypesListData;
@property (nonatomic, retain) IBOutlet NSMutableDictionary *selectedPerson;

-(IBAction) callNow: (id) sender;
-(IBAction) emailNow:(id) sender;
-(IBAction) textNow: (id) sender;
-(IBAction) cancel:  (id) sender;
-(void) loadDataFromFile;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;

@end
