//
//  OtherPeopleViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherPeopleAddLeaf.h";
#define kFileName @"accidently.plist"

@interface OtherPeopleViewController : UITableViewController {

	NSMutableArray *listData;
	NSMutableArray *typesListData;
	OtherPeopleAddLeaf *addView;
	NSString *reportTitle;
	
}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSMutableArray *typesListData;
@property (nonatomic, retain) OtherPeopleAddLeaf *addView;
@property (nonatomic, retain) NSString *reportTitle;

-(IBAction) navigateToOtherPeopleAddNew:(id) sender;


@end
