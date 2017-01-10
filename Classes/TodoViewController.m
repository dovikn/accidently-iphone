//
//  TodoViewController.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TodoViewController.h"


@implementation TodoViewController
@synthesize todos;
@synthesize reportTitle;

static sqlite3_stmt * delete_statement = nil;
static UIImage *priority1Image = nil;
static UIImage *priority2Image = nil;
static UIImage *priority3Image = nil;

+ (void) initialize {
	priority1Image = [[UIImage imageNamed:@"red.png"] retain];
	priority2Image = [[UIImage imageNamed:@"yellow.png"] retain];				   
	priority3Image = [[UIImage imageNamed:@"green.png"] retain];
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Notes";
	
	//Add the "add" button
	UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add"
															   style: UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(addTodo:)];
	self.navigationItem.rightBarButtonItem = addBtn;
	
		
	// Set the background image
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];
	
	// Set the color of the navigation bar to black
	UINavigationBar *navBar = [self.navigationController navigationBar];
	[navBar setTintColor:[UIColor blackColor]];

}

/*
 * Handling the Add.
 */

- (void) addTodo:(id) sender {
	
	// Create the detailed View
	TodoDetailedView *detailedView = [[TodoDetailedView alloc] initWithNibName:@"TodoDetailedView" bundle:nil];
	
	// Assign the database 
	detailedView.database = database;
	
	// "light" the 'add Flag'
	detailedView.addNewFlag = YES;
	
	// Add report title
	detailedView.reportTitle = self.reportTitle;

	
	// go to the detailed viewz
	 [self presentModalViewController:detailedView animated:YES];
	
}


-(void) viewWillAppear:(BOOL)animated {

	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];

	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

/**
 * Delete From Database
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

-  (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			// Identify the task to be removed 
			Todo * td = [todos objectAtIndex:indexPath.row];
			//remove the task
			[self removeTask:td];
			// Refresh the table view
			[self.tableView reloadData];
		}
}

-(void) removeTask:(Todo *)task {
	// delet the task from the database	
	[self deleteTaskFromDatabase:task];
	//remove the task from the task list
	[todos removeObject:task];
}


-(void) deleteTaskFromDatabase: (Todo *) task {
	if (delete_statement == nil){
		static char * sql = "DELETE FROM todos where pk=?";
		if (sqlite3_prepare_v2(database, sql, -1, &delete_statement,NULL) != SQLITE_OK) {
			NSAssert1 (0, @"Error: failed to prepare delete statement with message '%s'", sqlite3_errmsg(database));
		}
		sqlite3_bind_int(delete_statement, 1, task.primaryKey);
		int success = sqlite3_step(delete_statement);
		if (success != SQLITE_DONE) {
			NSAssert1 (0, @"Error: failed to delete with message '%s'", sqlite3_errmsg(database));
		}
		
	sqlite3_reset(delete_statement);	
		
	}	
}

- (void) createEditableCopyOfDatabaseIfNeeded {
 // first check existance
	
	BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"accidently.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	// The writable path doesn't exist so copy default to the right location
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"accidently.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1 (0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}


-(void) initializeDatabase {

	//initialize the todos array
	NSMutableArray *todoArray = [[NSMutableArray alloc] init];
	self.todos = todoArray;
	[todoArray release];
	
	// We access the database and open it 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"accidently.sqlite"];
	// Open the database. the database was prepared outside the application 
	if (sqlite3_open ([path UTF8String], &database) == SQLITE_OK) {
		// access the data 
		// get the primary key for all books 
		const char *sql = "SELECT pk FROM todos where report=?";
		sqlite3_stmt *statement = nil;
		
		
		// running the SQL
		if (sqlite3_prepare_v2(database,sql,-1,&statement, NULL)== SQLITE_OK) {
			
			sqlite3_bind_text(statement, 1, [self.reportTitle UTF8String], -1, SQLITE_TRANSIENT);
			
			// stepping through the sql results 
			while (sqlite3_step(statement) == SQLITE_ROW) {
			
				// retrieve the primary key 
				int primaryKey = sqlite3_column_int (statement,0);
				
				// create a todo with it.
				Todo *td = [[Todo alloc] initWithPrimaryKey:primaryKey database:database];
				[todos addObject:td];
				[td release];
				
			}
		}
		
		// finalize the statement - release resources associated with the statement 
		sqlite3_finalize (statement);
		
	} else {
		sqlite3_close (database);
		NSAssert1 (0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
}

#pragma mark -
#pragma mark Table Delegate Methods


-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	return [self.todos count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString * generalIdentifier = @"GeneralIdentifier";
	TodoCell *cell = (TodoCell *) [tableView dequeueReusableCellWithIdentifier: generalIdentifier];
	// Create a TodoCell.
	if(cell == nil) {
		cell = [[[TodoCell alloc] initWithFrame:CGRectZero reuseIdentifier:generalIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	Todo * td = (Todo *) [todos objectAtIndex: row];
	NSString *textString = td.text;
	

	cell.todoTextLabel.text= textString;
	
	

	//Set the Priority Label;
	switch(td.priority) {
		case 1:
			cell.todoPriorityLabel.text = @"Medium";
			break;
		case 0:
			cell.todoPriorityLabel.text = @"Low";
			break;	
		case 2:
			cell.todoPriorityLabel.text = @"High";
			break;	
			
		default:
			cell.todoPriorityLabel.text = @"High";
			break;
	}
	
	//Set the priority Image
	cell.todoPriorityImageView.image = [self imageForPriority:td.priority];
	return cell;
}

- (UIImage *) imageForPriority:(NSInteger)priority {
	
	switch (priority) {
			
		case 0:
			return priority3Image;
			break;
		case 1:
			return priority2Image;
			break;
		case 2:
			return priority1Image;
			break;
			
		default:
			return priority1Image;
			break;
			
	}
	return nil;
	
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	Todo * td = [todos objectAtIndex:indexPath.row];
	TodoDetailedView *todoView = [[TodoDetailedView alloc] initWithNibName:@"TodoDetailedView" bundle:nil];
	//[self.navigationController pushViewController:todoView animated:YES];
	[self presentModalViewController:todoView animated:YES];
	todoView.todo = td;
	todoView.title = td.text;
	[todoView.textField setText: td.text];
	todoView.reportTitle = self.reportTitle;
	
	// Set the priority
	NSInteger priority = td.priority;
	[todoView.segmentedPriorities setSelectedSegmentIndex:priority];
		
	// Make sure that the add new flag is turned off 
	todoView.addNewFlag = NO;
	
	// set the database: 
	todoView.database = database;
	
}
- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information about notes (TodoViewController), Accidently received a a memory warning!");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    todos = nil;
	reportTitle = nil;
}

- (void)dealloc {
	[todos release];
	[reportTitle release];
    [super dealloc];
}


@end

