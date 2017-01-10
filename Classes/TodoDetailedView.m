//
//  TodoDetailedView.m
//  Accident-ly
//
//  Created by Dovik Nissim on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TodoDetailedView.h"

static sqlite3_stmt * insert_statement = nil;
static sqlite3_stmt * update_statement = nil;

@implementation TodoDetailedView
@synthesize textField; 
@synthesize segmentedPriorities;
@synthesize priorityLabel, descriptionLabel;
@synthesize cancelButton;
@synthesize updateButton;
@synthesize addNewFlag;
@synthesize todo;
@synthesize database;
@synthesize reportTitle;
@synthesize naviBar;
@synthesize scrollView;


-(void) viewWillAppear:(BOOL)animated {

	if (!addNewFlag) {
		
		[updateButton setTitle:@"Edit" forState:UIControlStateNormal];
				
	}
	
	
}


-(void) viewDidLoad {
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	[naviBar setTintColor:[UIColor blackColor]];
	
	// Set the color of the labels to White
	UILabel *dLabel = [self descriptionLabel]; 
	dLabel.textColor = [UIColor whiteColor];
	[dLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[dLabel release];
	
	UILabel *pLabel = [self priorityLabel]; 
	pLabel.textColor = [UIColor whiteColor];
	[pLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[pLabel release];
	
    //Enable Scrolling
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 550)];
}

-(IBAction) cancel: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
	
}

/*
 * Add or Edit Task
 */
-(IBAction)addNewOrEditTask: (id)sender {
	
	if (addNewFlag) {
		[self addNewTask];
		addNewFlag = NO;
		
	} else {
	
		// otherwise edit
		[self editExistingTask];
	}
	//[self.navigationController popViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
	TodoViewController *todoView = [[TodoViewController alloc] initWithNibName:@"TodoViewController" bundle:nil];
	[todoView.tableView reloadData];
	return;
}

/**
 * Add new Task
 */

-(void) addNewTask {
	// Grab a new pk 
	NSInteger pk = [self insertNewTaskIntoDatabase];
	[self insertNewTaskToTaskList:pk];
	
	return;
}

- (NSInteger) insertNewTaskIntoDatabase{
	
	if (insert_statement == nil ) {
		static char * sql = "INSERT into todos (text,priority, complete, report) VALUES (? , ?, ?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &insert_statement,NULL) != SQLITE_OK) {
			NSAssert1 (0, @"Error: failed to prepare insert statement with message '%s'", sqlite3_errmsg(database));
		}
	}

	// Set the priority 
	NSInteger selectedPriorityIndex = segmentedPriorities.selectedSegmentIndex; 	
	sqlite3_bind_int(insert_statement, 3, 0); // new
	sqlite3_bind_int(insert_statement, 2, selectedPriorityIndex);
	sqlite3_bind_text(insert_statement, 1, [self.textField.text UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 4, [self.reportTitle UTF8String], -1, SQLITE_TRANSIENT);
	
	
	int success = sqlite3_step(insert_statement);
	sqlite3_reset(insert_statement);
	
	if (success != SQLITE_ERROR) {
		return sqlite3_last_insert_rowid(database);
		
	}
	NSAssert1 (0, @"Error: failed to  insert to the database  with message '%s'", sqlite3_errmsg(database));
	return -1;
}

- (void) insertNewTaskToTaskList: (NSInteger)pk  {

	Todo *td = [[Todo alloc] initWithPrimaryKey:pk database:database];
	// Set the priority 
	NSInteger selectedPriorityIndex = segmentedPriorities.selectedSegmentIndex; 
	td.priority = selectedPriorityIndex;
	// set status
	td.status = 0;
	td.text = textField.text;
	
	TodoViewController *todoView = [[TodoViewController alloc] initWithNibName:@"TodoViewController" bundle:nil];
	[todoView.todos addObject:td];
	
}


/**
 * Edit Task 
 */ 

-(void) editExistingTask {
	// Grab a new pk 
	[self editExistingTaskInDatabase];
	
	return;
}


-(void) editExistingTaskInDatabase {
	

	if (update_statement == nil) {
		
		const char *sql = "UPDATE todos SET text = ? ,priority = ?, complete = ? WHERE pk = ?";
		if(sqlite3_prepare_v2 (database, sql, -1, &update_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: failed to prepare update statement with error '%s'.", sqlite3_errmsg(database));
		}
		sqlite3_bind_int(update_statement, 4, self.todo.primaryKey);
		// Set the priority 
		NSInteger selectedPriorityIndex = segmentedPriorities.selectedSegmentIndex; 	
		sqlite3_bind_int(update_statement, 3, 0); // status new
		sqlite3_bind_int(update_statement, 2, selectedPriorityIndex);
		sqlite3_bind_text(update_statement, 1, [textField.text UTF8String], -1, SQLITE_TRANSIENT);
	}
	int success = sqlite3_step(update_statement);

	if (success != SQLITE_DONE) {
		NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
	}

	sqlite3_reset(update_statement);
	update_statement =nil;
}
//

-(IBAction) updateText: (id) sender {
	self.todo.text = self.textField.text;
	dirty= YES;
}

-(IBAction) updatePriority:(id)sender{
	int priority = [self.segmentedPriorities selectedSegmentIndex];
	[self.todo updatePriority: (2-priority +1)];
	dirty= YES;
}


// ensures that when you are done editing the keyboard disappears
- (IBAction) textFieldDoneEditing: (id)sender {
	[sender resignFirstResponder];
}



// Touch the background to make the keyboard disappear
-(IBAction) backgroundTap: (id)sender {
	[textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about a new note (TodoDetailedView), Accidently received a memory warning!");
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
	textField			= nil; 
	segmentedPriorities = nil;
	updateButton		= nil;
	priorityLabel		= nil; 
	descriptionLabel	= nil;
	cancelButton		= nil;
	reportTitle			= nil;
	naviBar				= nil;
	scrollView          = nil;
}


- (void)dealloc {
    [textField				release];
	[segmentedPriorities	release];
	[updateButton			release];
	[priorityLabel			release];
	[descriptionLabel		release];
	[cancelButton			release];
	[reportTitle			release];
	[naviBar				release];
    [scrollView             release];
	[super dealloc];

}


@end
