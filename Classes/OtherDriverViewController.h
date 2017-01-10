//
//  OtherDriverViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherDriverDetailsLeaf.h"
#import "OtherDriverVehicleLeaf.h"
#import "OtherDriverInsuranceLeaf.h"


@interface OtherDriverViewController : UITableViewController {
	NSArray *listData; 
	OtherDriverDetailsLeaf *driverView;
	OtherDriverVehicleLeaf *vehicleView;
	OtherDriverInsuranceLeaf *insuranceView;
	NSString *reportTitle;
}
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) OtherDriverDetailsLeaf *driverView;
@property (nonatomic, retain) OtherDriverVehicleLeaf *vehicleView;
@property (nonatomic, retain) OtherDriverInsuranceLeaf *insuranceView;
@property (nonatomic, retain) NSString *reportTitle;
@end

