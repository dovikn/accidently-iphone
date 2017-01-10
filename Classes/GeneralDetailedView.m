//
//  GeneralDetailedView.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GeneralDetailedView.h"


@implementation GeneralDetailedView

@synthesize listData;
@synthesize dateAndTime;
@synthesize locationView;
@synthesize policeView;
@synthesize towingView;
@synthesize reportTitle;
@synthesize descriptionView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	NSArray *array = [[NSArray alloc] initWithObjects:	@"Date & Time", 
														@"Description",
														@"Location Information", 
														@"Police Report Information",
														@"Towing Information", nil];
	self.listData = array;
	self.title= @"Basic Information";
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
	
	//Change the text color to White
	cell.textLabel.textColor = [UIColor whiteColor]; 

	NSUInteger row = [indexPath row];
	
	cell.textLabel.text = [listData objectAtIndex: row];
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	int row = [indexPath row];
	
	if (row == 0) {
		
		if (dateAndTime  == nil) {
			dateAndTime = [[DateAndTimeLeaf alloc] initWithNibName:@"DateAndTimeLeaf" bundle:nil];
		}
		dateAndTime.addFlag = NO;
		dateAndTime.reportTitle = self.reportTitle;
		[self presentModalViewController:dateAndTime animated:YES];
	}
	
	if (row == 1) {
		
		if (descriptionView  == nil) {
			descriptionView = [[DescriptionViewLeaf alloc] initWithNibName:@"DescriptionViewLeaf" bundle:nil];
		}
		descriptionView.reportTitle = self.reportTitle;
		[self presentModalViewController:descriptionView animated:YES];
	}
	if (row == 2) {
		
		if (locationView  == nil) {
			locationView = [[LocationViewLeaf alloc] initWithNibName:@"LocationViewLeaf" bundle:nil];
		}
		locationView.reportTitle = self.reportTitle;
		
		[self presentModalViewController:locationView animated:YES];
	}
	
	if (row == 3) {
		
		if (policeView  == nil) {
			policeView = [[PoliceViewLeaf alloc] initWithNibName:@"PoliceViewLeaf" bundle:nil];
		}
		policeView.reportTitle = self.reportTitle;
		[self presentModalViewController:policeView animated:YES];
	}
	
	if (row == 4) {
		
		if (towingView  == nil) {
			towingView = [[TowingViewLeaf alloc] initWithNibName:@"TowingViewLeaf" bundle:nil];
		}
		towingView.reportTitle = self.reportTitle;
		[self presentModalViewController:towingView animated:YES];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While displaying a detailed view of the report (GeneralDetailedView), Accidently received a a memory warning!");
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	dateAndTime		= nil;
	locationView	= nil;
	policeView		= nil;
	towingView		= nil;
	reportTitle		= nil;
	descriptionView = nil;
}


- (void)dealloc {
	[dateAndTime	release];
	[locationView	release];
	[policeView		release];
	[towingView		release];
	[reportTitle	release];
	[descriptionView release];
    [super dealloc];
}


@end

