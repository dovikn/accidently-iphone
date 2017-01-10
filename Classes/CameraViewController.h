//
//  CameraViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <stdlib.h>
#import "Utilities.h"
#define kFileName @"accidently.plist"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate , UINavigationControllerDelegate> {
    UIImageView             *imageView;
    UIButton                *takePhotoBtn;
    UIButton                *cancelBtn;
	UINavigationBar         *naviBar; 
	NSString                *reportTitle;
	NSMutableArray          *imageNames;
   
}

@property(nonatomic,retain)     IBOutlet UIImageView        *imageView;
@property(nonatomic,retain)     IBOutlet UIButton           *takePhotoBtn;
@property(nonatomic,retain)     IBOutlet UIButton           *cancelBtn;
@property(nonatomic,retain)     IBOutlet UINavigationBar    *naviBar; 
@property(nonatomic,retain)              NSString           *reportTitle;
@property(nonatomic,retain)              NSMutableArray     *imageNames;


// Method declarations
-(void)         loadDataFromFile;
-(void)         saveDataToFile;
-(IBAction)     getCameraPicture:   (id)sender;
-(IBAction)     cancel:             (id)sender;
-(IBAction)     saveImage:          (UIImage *)image;

@end
