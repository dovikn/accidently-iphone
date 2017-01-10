//
//  LocationLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationLeaf.h"


@implementation LocationLeaf

@synthesize address;
@synthesize city;
@synthesize state;
@synthesize addressLabel;
@synthesize cityLabel;
@synthesize stateLabel;
@synthesize instruction;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Create and add the instruction
	instruction = [[UILabel alloc] init];
	instruction.frame = CGRectMake(10, 10, 300, 40);
	instruction.text = @"Specify the location:";
	instruction.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:instruction];
	
	//Create and add the address label
	addressLabel = [[UILabel alloc] init];
	addressLabel.frame = CGRectMake(10, 40, 300, 40);
	addressLabel.text = @"Address:";
	addressLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:addressLabel];
	
	
	//Create and add the address text field
	address = [[UITextField alloc] init];
	address.frame = CGRectMake(10, 80, 300, 40);
	[self.view addSubview:address];
	
	//Create and add the city label
	cityLabel = [[UILabel alloc] init];
	cityLabel.frame = CGRectMake(10, 120, 300, 40);
	cityLabel.text = @"City:";
	cityLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:cityLabel];
	
	
	//Create and add the city text field
	city = [[UITextField alloc] init];
	city.frame = CGRectMake(10, 160, 300, 40);
	[self.view addSubview:city];
	
	//Create and add the state label
	stateLabel = [[UILabel alloc] init];
	stateLabel.frame = CGRectMake(10, 200, 300, 40);
	stateLabel.text = @"State:";
	stateLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:stateLabel];
	
	
	//Create and add the city text field
	state = [[UITextField alloc] init];
	state.frame = CGRectMake(10, 240, 300, 40);
	[self.view addSubview:state];
	
	
	
}

- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}

-(IBAction) backgroundTap: (id)sender {
	[address resignFirstResponder];
	[city resignFirstResponder];
	[state resignFirstResponder];
	[addressLabel resignFirstResponder];
	[cityLabel resignFirstResponder];
	[stateLabel resignFirstResponder];
	[instruction resignFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	address=nil;
	city = nil;
	state =nil;
	instruction = nil;
	addressLabel = nil;
	cityLabel = nil;
	stateLabel = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [instruction release];
	[address release];
	[city release];
	[state release];
	[addressLabel release];
	[cityLabel release];
	[stateLabel release];
	
	[super dealloc];
}


@end
