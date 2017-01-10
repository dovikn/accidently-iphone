//
//  RootViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/22/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "GeneralDetailedView.h"
#import "OtherDriverViewController.h"
#import "OtherPeopleViewController.h"
#import "TodoViewController.h"
#import "ShareViewController.h"
#import "MustHavesView.h"
#import "CameraViewController.h"
#import "ContactProfessionalsViewController.h"
#import "BumpAPI.h"
#import "Bumper.h"
#import "BumpViewLeaf.h"


@interface RootViewController : UITableViewController <BumpAPIDelegate> {
	NSArray                             *listData; 
	MustHavesView                       *mustView;
	CameraViewController                *imageView;
	OtherDriverViewController           *otherDriverView;
	OtherPeopleViewController           *otherPeopleView;
	TodoViewController                  *todoView;
	UIImageView                         *background;
	NSString                            *reportTitle; 
	ShareViewController                 *shareView;
    GeneralDetailedView                 *generalView;
    ContactProfessionalsViewController  *profsView;
    BumpViewLeaf                        *bumpView;
    BumpAPI                             *bumpObject;
    NSString                            *tipPresented;

}

@property (nonatomic, retain) NSArray                       *listData;
@property (nonatomic, retain) MustHavesView                 *mustView;
@property (nonatomic, retain) CameraViewController          *imageView;
@property (nonatomic, retain) OtherDriverViewController     *otherDriverView;
@property (nonatomic, retain) OtherPeopleViewController     *otherPeopleView;
@property (nonatomic, retain) TodoViewController            *todoView;
@property (nonatomic, retain) UIImageView                   *background;
@property (nonatomic, retain) NSString                      *reportTitle;
@property (nonatomic, retain) ShareViewController           *shareView;
@property (nonatomic, retain) GeneralDetailedView           *generalView;
@property (nonatomic, retain) ContactProfessionalsViewController *profsView;
@property (nonatomic, retain) BumpAPI                       *bumpObject;
@property (nonatomic, retain) BumpViewLeaf                  *bumpView;
@property (nonatomic, retain) NSString                      *tipPresented;

// Method declarations
- (BOOL)        isInternetConnectionAvailable;
- (void)        configBump;
- (void)        startBump;
- (NSString *)  dataFilePath;
- (void)        loadDataFromFile;
- (void)        saveDataToFile;
@end
