//
//  OtherPeopleViewController.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OtherPeopleViewController.h"


@implementation OtherPeopleViewController

@synthesize listData;
@synthesize typesListData;
@synthesize addView;
@synthesize reportTitle;

NSMutableDictionary *dictionary;


- (void)viewDidLoad {	
	[super viewDidLoad];

	// Set the title 
	self.title= @"Other people Involved";
	
	// Set the background image
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	UINavigationBar *navBar = [self.navigationController navigationBar];
	[navBar setTintColor:[UIColor blackColor]];
	
	
	// Add the plus sign on the top right (in the navigation bar)
	UIBarButtonItem *addButton  =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
	target: self
	action:@selector(navigateToOtherPeopleAddNew:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}


// Get the accidently .plist file path within the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

// load the data from the .plist file
-(void) loadDataFromFile {
	
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		return;
	}
	
	// Load the Dictionary 
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		return;
	}
	
	NSString *key = @"Accidently-";
	NSString *keyNames =@"";
	NSString *keyTypes =@"";
	
	key = [key stringByAppendingString:reportTitle];
	keyNames = [key stringByAppendingString:@"-OtherPeopleListData"];
	keyTypes = [key stringByAppendingString:@"-OtherPeopleTypesListData"];
	
	
	// Populate data from  Dictionary 
	listData = [dictionary objectForKey: keyNames];
	
	
	if (listData == nil) {
		listData = [[NSArray alloc] init];
	
	}
	
	// Populate the types list data from  Dictionary 
	typesListData = [dictionary objectForKey:keyTypes];
	
	
	if (typesListData == nil) {
		typesListData = [[NSArray alloc] init];
	}
}

-(void) saveDataToFile {
	
	// In  case the dictionary is nil
	if (dictionary == nil) {
		dictionary =[[NSMutableDictionary alloc] init];
	}
	
	NSString *key = @"Accidently-";
	NSString *keyNames =@"";
	NSString *keyTypes =@"";
	
	key = [key stringByAppendingString:reportTitle];
	keyNames = [key stringByAppendingString:@"-OtherPeopleListData"];
	keyTypes = [key stringByAppendingString:@"-OtherPeopleTypesListData"];
	
	// Add an item to the dictionary 
	[dictionary setValue:listData forKey: keyNames];
	
	// Add the types to the dictionary 
	[dictionary setValue:typesListData forKey:keyTypes];
	
	
	//Persist the  contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL res = [dictionary writeToFile:dataFile atomically:YES];
	if (res == NO) {
		NSLog(@"[ERROR]: While saving information about other people involved with the accident (OtherPeopleView Controller), Failed to save data to Accidently.plist file!");
	}
}

// Navigate to the subview to create another contact.
-(IBAction) navigateToOtherPeopleAddNew:(id)sender {
	
	if (addView == nil) {
		addView = [[OtherPeopleAddLeaf alloc] initWithNibName:@"OtherPeopleAddLeaf" bundle:nil];
	}
	
	// Present the new contact window as a modal window 
	OtherPeopleAddLeaf *addNewView = [[OtherPeopleAddLeaf alloc] init];
	addNewView.reportTitle = self.reportTitle;
    [self presentModalViewController:addNewView animated:YES];
}

 - (void)viewWillAppear:(BOOL)animated {
	 [self loadDataFromFile];
	 [self.tableView reloadData];
	 [super viewWillAppear:animated];
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
				// initWithStyle:UITableViewCellStyleSubtitle
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier: generalIdentifier] autorelease];
	}
	
	//Change the text color to White
	cell.textLabel.textColor = [UIColor whiteColor]; 
	NSUInteger row = [indexPath row];
	
	// Set the text label
	cell.textLabel.text = [listData objectAtIndex: row];
	
	NSString *type = [typesListData objectAtIndex:row];
	cell.detailTextLabel.text = type;
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	[type release];
	
	// set the details icon
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	OtherPeopleAddLeaf *editNewView = [[OtherPeopleAddLeaf alloc] init];
	editNewView.reportTitle = self.reportTitle;
	
	NSString *selectedName = [listData objectAtIndex:row];
	
	if (selectedName == nil) {
		[self presentModalViewController:editNewView animated:YES];
		return;
	}
	
	editNewView.selectedPerson= selectedName;
	editNewView.selectedIndex = row;
	[self presentModalViewController:editNewView animated:YES];

   
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	NSString *selected = [listData objectAtIndex:indexPath.row];
	
	
	// Present the new contact window as a modal window 
	OtherPeopleAddLeaf *addNewView = [[OtherPeopleAddLeaf alloc] init];
	addNewView.selectedPerson= selected;
    addNewView.reportTitle = self.reportTitle;
    [self presentModalViewController:addNewView animated:YES];
	
} 

/*
 * Handling the delete.
 */

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

-  (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger row = [indexPath row];
    NSUInteger count = [listData count];
	
    if (row < count) {
        
        //1. Dictionary 
        NSString *prsnName = [[NSString alloc] initWithString:[listData objectAtIndex:row]];
        NSString *cKey = [[NSString alloc] initWithString:@"Contact-"];
        cKey = [cKey stringByAppendingString:prsnName];
        [dictionary removeObjectForKey:cKey];
        
        //2. listData
        [listData removeObjectAtIndex:row];
        
        
        //3. typeListData
        [typesListData removeObjectAtIndex:row];
        
		
		// Save the new list data
		[self saveDataToFile];
		
		// Refresh the table view 
		[self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about other people, Accidently received a a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	listData = nil;
	typesListData = nil;
	addView = nil;
    reportTitle = nil;
}


- (void)dealloc {
	[addView release];
	[listData release];
	[typesListData release];
	[reportTitle release];
    [super dealloc];
}


@end

