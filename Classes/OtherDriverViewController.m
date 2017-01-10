//
//  OtherDriverViewController.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OtherDriverViewController.h"


@implementation OtherDriverViewController

@synthesize listData;
@synthesize driverView;
@synthesize vehicleView;
@synthesize insuranceView;
@synthesize reportTitle;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {	
	[super viewDidLoad];
	NSArray *array = [[NSArray alloc] initWithObjects:	
					  @"Other Driver's Information", 
					  @"Other Driver's Vehicle", 
					  @"Other Driver's Insurance", 
					  nil];
	
	self.listData = array;
	self.title= @"Other Driver/ Vehicle";
	[array release];

	// Set the background image
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	UINavigationBar *navBar = [self.navigationController navigationBar];
	[navBar setTintColor:[UIColor blackColor]];
}

#pragma mark -
#pragma mark Table Delegate Methods


-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	return [self.listData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString * generalIdentifier = @"GeneralIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: generalIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier: generalIdentifier] autorelease];
	}
	

	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [listData objectAtIndex: row];

	//Change the text color to White
	cell.textLabel.textColor = [UIColor whiteColor]; 
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row];
	
	//The other driver
	if (row == 0) {
		
		if (driverView == nil) {
			driverView = [[OtherDriverDetailsLeaf alloc] initWithNibName:@"OtherDriverDetailsLeaf" bundle:nil];
		}
		driverView.reportTitle = self.reportTitle;
		[self presentModalViewController:driverView animated:YES];
	
	}
	//the other vehicle
	if (row == 1) {
		
		if (vehicleView == nil) {
			vehicleView = [[OtherDriverVehicleLeaf alloc] initWithNibName:@"OtherDriverVehicleLeaf" bundle:nil];
		}
		vehicleView.reportTitle = self.reportTitle;
		[self presentModalViewController:vehicleView animated:YES];	
		
		
	}
	// the other insurance
	if (row == 2) {
		if (insuranceView == nil) {
			insuranceView = [[OtherDriverInsuranceLeaf alloc] initWithNibName:@"OtherDriverInsuranceLeaf" bundle:nil];
		}
		insuranceView.reportTitle = self.reportTitle;
		[self presentModalViewController:insuranceView animated:YES];

	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about other drivers (OtherDriverViewController), Accidently received a a memory warning!");
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	listData = nil;
	driverView = nil;
	vehicleView = nil;
	insuranceView = nil;
	reportTitle = nil;
}


- (void)dealloc {
	[listData release];
	[driverView release];
	[vehicleView release];
	[insuranceView release];
	[reportTitle release];
	[super dealloc];
}


@end

