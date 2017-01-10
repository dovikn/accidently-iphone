//
//  GeneralDetailedView.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateAndTimeLeaf.h";
#import "LocationViewLeaf.h";
#import "PoliceViewLeaf.h";
#import "TowingViewLeaf.h";
#import "DescriptionViewLeaf.h"


@interface GeneralDetailedView : UITableViewController {
	NSArray				*listData;
	DateAndTimeLeaf		*dateAndTime;
	LocationViewLeaf	*locationView;
	PoliceViewLeaf		*policeView;
	TowingViewLeaf		*towingView;
	DescriptionViewLeaf *descriptionView;
	NSString			*reportTitle;
}
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) DateAndTimeLeaf  *dateAndTime;
@property (nonatomic, retain) LocationViewLeaf *locationView;
@property (nonatomic, retain) PoliceViewLeaf   *policeView;
@property (nonatomic, retain) TowingViewLeaf   *towingView;
@property (nonatomic, retain) NSString		   *reportTitle;
@property (nonatomic, retain) DescriptionViewLeaf *descriptionView;


@end
