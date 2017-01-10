//
//  OtherPeopleAddLeaf.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OtherPeopleAddLeaf.h"
#import "OtherPeopleViewController.h"

@implementation OtherPeopleAddLeaf


@synthesize typeOfPersonPicker;
@synthesize pickerDataSource;
@synthesize pickerSelected;
@synthesize nameField;
@synthesize phoneField;
@synthesize addButton;
@synthesize cancelButton;
@synthesize listData;
@synthesize typesListData;
@synthesize typeLabel;
@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize viewTitle;
@synthesize selectedPerson;
@synthesize selectedIndex;
@synthesize emailField;
@synthesize reportTitle;
@synthesize emailLabel;
@synthesize naviBar;
@synthesize scrollView;
@synthesize activePerson;


// the main dictionary
NSMutableDictionary *dictionary;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//load Data from .plist before presenting the page
	[self loadDataFromFile];
	
	// set the UIPickerView
	typeOfPersonPicker.frame = CGRectMake(20.0, 70.0, 280.0, 70);
	self.pickerDataSource = [NSArray arrayWithObjects:
					   @"Passanger in your car",
					   @"Passanger in other car",
					   @"Witness",
                       @"Other",
					   nil];	
	[typeOfPersonPicker reloadAllComponents];
	[typeOfPersonPicker selectRow:0 inComponent:0 animated:YES];
	pickerSelected = [pickerDataSource objectAtIndex:2];
	
	// enable the edit button
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.editButtonItem.title = @"Edit";
			
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the labels to White
	UILabel *nLabel = [self nameLabel]; 
	nLabel.textColor = [UIColor whiteColor];
	[nLabel setFont:[UIFont boldSystemFontOfSize:20]];
	
	UILabel *tLabel = [self typeLabel];
	tLabel.textColor = [UIColor whiteColor];
	[tLabel setFont:[UIFont boldSystemFontOfSize:20]];

	
	UILabel *pLabel	= [self phoneLabel]; 
	pLabel.textColor = [UIColor whiteColor];
	[pLabel setFont:[UIFont boldSystemFontOfSize:20]];
	
	UILabel *eLabel	= [self emailLabel]; 
	eLabel.textColor = [UIColor whiteColor];
	[eLabel setFont:[UIFont boldSystemFontOfSize:20]];
	
	[nLabel release];
	[pLabel release];
	[tLabel release];
	[eLabel release];
    
    // Set the color of the navigation bar to black
	[naviBar setTintColor:[UIColor blackColor]];
    
    //Enable Scrolling
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
	
	// Set the color of the title to white
	UILabel *vTitle = [self viewTitle]; 
	vTitle.textColor = [UIColor whiteColor];
	// set the font of the title to bold
	vTitle.font = [UIFont boldSystemFontOfSize:20];	
	
	

	// If selected Person is nil, than it is a "create new person"	
	if ([self.selectedPerson length] == 0 ) {
		return;
	}
	
	// otherwise it is a detailed view:
	NSString *lKey = [[NSString alloc] initWithString:@"Contact-"];
	lKey = [lKey stringByAppendingString:selectedPerson];
	
	NSMutableDictionary *lPerson = (NSMutableDictionary *) [dictionary objectForKey:lKey];
	
	if ([lPerson count] > 0) {
			
		nameField.text = (NSString *)[lPerson objectForKey:@"p_name"];
		phoneField.text = [lPerson objectForKey:@"p_phone"];
		emailField.text = [lPerson objectForKey:@"p_email"];
		
        // Set the active Person
        activePerson = lPerson;
        
        
		// set the text fields to edit mode 
		[self setEditing:YES animated: YES];
		
		
		
		
		// edit the name of the "add" button to edit 
		UIButton *aButton = [self addButton];
		
		[aButton setTitle:@"Edit" forState:UIControlStateNormal];
		[aButton release]; 
		
	}
}

// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}



// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	[typeOfPersonPicker resignFirstResponder];
	[nameField resignFirstResponder];
	[phoneField resignFirstResponder];
	[emailField resignFirstResponder];

}

// set Editting mode 
-(void)setEditing: (BOOL)editing animated:(BOOL)animated {
		// the user can only edit the textfields when in edit mode 
	[super setEditing: editing animated:animated];
	nameField.enabled = editing;
	phoneField.enabled = editing;
	emailField.enabled = editing;
	
	
}

// Get the accidently .plist file in the documents directory
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
	
	// if file exists, load Dictionary from file.
	
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
	listData = [dictionary objectForKey:keyNames];
	
	if (listData == nil) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.listData = array;
		[array release];
	}
	
	typesListData = [dictionary objectForKey:keyTypes];
	
	if (typesListData == nil) {
		NSMutableArray *tArray = [[NSMutableArray alloc] init];
		self.listData = tArray;
		[tArray release];
	}
}

/**
 ** Save Data to File
 **/
-(void) saveDataToFile {
	
	// if there is nothing to save
  	if (nameField.text == nil) {
		return;
	}
	
	// In  case the dictionary is nil
	if (dictionary == nil) {
		dictionary =[[NSMutableDictionary alloc] init];
	}
    
    // Get the picker selection 
    NSInteger row = [typeOfPersonPicker selectedRowInComponent:0];
    pickerSelected= [pickerDataSource objectAtIndex:row];
    
   
    NSMutableDictionary *person;

    NSString *cKey = [[NSString alloc] initWithString:@"Contact-"];
    cKey = [cKey stringByAppendingString:nameField.text];

    // In case  we are editing a person, First remove his current entries
    if ( [selectedPerson length] > 0) {
    
        NSString *contactName = [activePerson objectForKey:@"p_name"];
        
        NSUInteger index = [listData indexOfObject:contactName];
        
        //1. Dictionary 
        [dictionary removeObjectForKey:cKey];
    
        //2. listData
        [listData removeObjectAtIndex:index];
    
    
        //3. typeListData
        [typesListData removeObjectAtIndex:index];
    }
    
    // Create the contact object 
    person= [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								   nameField.text,    @"p_name",
								   pickerSelected,    @"p_type",
								   phoneField.text,   @"p_phone",
								   emailField.text,   @"p_email", 
								   nil];

   //
    
    // 1. Add the contact to the dictionary 
    [dictionary setValue:person forKey:cKey];

	
    // 2. add contact to the list data:
    if(listData ==nil) {
        listData = [[NSMutableArray alloc] init];
    }
	
	NSString *key = @"Accidently-";
	NSString *keyNames =@"";
	NSString *keyTypes =@"";
	
	key = [key stringByAppendingString:reportTitle];
	keyNames = [key stringByAppendingString:@"-OtherPeopleListData"];
	keyTypes = [key stringByAppendingString:@"-OtherPeopleTypesListData"];
	
	[listData addObject:nameField.text];
	[dictionary setValue:listData forKey: keyNames];

    
	// 3. Add contact to the types list data:
	if(typesListData ==nil) {
		typesListData = [[NSMutableArray alloc] init];
	}
	[typesListData addObject:pickerSelected];
	[dictionary setValue:typesListData forKey:keyTypes];
	
	
	
    //Persist the  contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];


	BOOL res = [dictionary writeToFile:dataFile atomically:YES];
	if (res == NO) {
		NSLog(@"[ERROR]: While saving information about a person involved with the accident (OtherPeopleAddLeaf), Failed to save data to Accidently.plist file!");	
    }
}

/**
 ** Save a Person to the database
 **/

-(IBAction) savePerson: (id)sender {
	
    /**
     ** Check if the other person's information is valid.
     **/  
    NSString *uName = nameField.text;
    
    if ( (uName == nil) || ([uName length] == 0 )) {
        
        UIAlertView *nilNameWarning = [[UIAlertView alloc]
                                       initWithTitle:@"Alert!"
                                       message:@"Apologies, the person's information is invalid! please review these details again."
                                       delegate: self
                                       cancelButtonTitle: @"OK"
                                       otherButtonTitles:nil];
		[nilNameWarning show];
		[nilNameWarning release];
        return;
    }
    
    
    /**
     ** When adding a new person Check if the other person's information already exist.
     **/
    NSString *cKey = [[NSString alloc] initWithString:@"Contact-"];
    cKey = [cKey stringByAppendingString: uName];
    
    if (selectedPerson == nil) { // if we are adding a new person
        BOOL userExists =  [listData containsObject: uName];
        if (userExists) {
            UIAlertView *userExistsWarning = [[UIAlertView alloc]
                                          initWithTitle:@"Alert!"
                                          message:@"Apologies, the person's information already exists in Accidently!"                                    delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles:nil];
            [userExistsWarning show];
            [userExistsWarning release];   
            return;
        }
    }
    
    // save the data
	[self saveDataToFile];

	
	//navigate back to the parent
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) cancelAction: (id)sender {
    //navigate back to the parent
	[self dismissModalViewControllerAnimated:YES];	
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about a person involved in the accident (OtherPeopleAddLeaf), Accidently received a memory warning!");
	[self saveDataToFile];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	typeOfPersonPicker  = nil;
	pickerDataSource    = nil;
	nameField           = nil;
    phoneField          = nil;
	listData            = nil;
	typesListData       = nil;
	addButton           = nil;
	cancelButton        = nil;
	typeLabel           = nil;
	nameLabel           = nil;
	phoneLabel          = nil;
	viewTitle           = nil;
	selectedPerson      = nil;
	emailField          = nil;
	emailLabel          = nil;
	reportTitle         = nil;
    naviBar              = nil;
    scrollView          = nil;
    activePerson        = nil;
}


- (void)dealloc {
	[typeOfPersonPicker release];
	[pickerDataSource release];
	[nameField release];
	[phoneField release];
	[listData release];
	[typesListData release];
	[addButton release];
	[cancelButton release];
	[typeLabel release];
	[nameLabel release];
	[phoneLabel release];
	[viewTitle release];
	[selectedPerson release];
	[emailField release];
	[emailLabel release];
	[reportTitle release];
    [naviBar      release];
    [scrollView   release];
    [activePerson release];
	[super dealloc];
}

	
- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
	return 1;
}
- (NSInteger) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent: (NSInteger) component {
	return [pickerDataSource count];
}

	 
- (NSString *) pickerView: (UIPickerView *) pickerView
	titleForRow: (NSInteger) row forComponent: (NSInteger) component {
	return [pickerDataSource objectAtIndex:row];
}
- (void) pickerView: (UIPickerView *) pickerView
	didSelectRow: (NSInteger) row inComponent: (NSInteger) component {
	pickerSelected = [pickerDataSource objectAtIndex:row];
}
	 
	 

@end
