//
//  LocationLeaf.h
//  Accident-ly
//
//  Created by Dovik Nissim on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocationLeaf : UIViewController {
	UITextField *address;
	UITextField *city;
	UITextField *state;
	UILabel *instruction;
	UILabel *addressLabel;
	UILabel *cityLabel; 
	UILabel *stateLabel;
}

@property (nonatomic, retain) IBOutlet UITextField *address;
@property (nonatomic, retain) IBOutlet UITextField *city;
@property (nonatomic, retain) IBOutlet UITextField *state;
@property (nonatomic, retain) IBOutlet UILabel *instruction;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *stateLabel;

-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;


@end
