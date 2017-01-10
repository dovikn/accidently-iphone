//
//  Todo.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Todo.h"

//This will hold our initialize statement when retrieving todo data 
static sqlite3_stmt * init_statement = nil;

static sqlite3_stmt * insert_statement = nil;
static sqlite3_stmt *dehydrate_statement =nil;

@implementation Todo

@synthesize primaryKey, text, priority, status;

+ (NSInteger) insertNewTodoIntoDatabase:(sqlite3 *)database {

	// create the insert statement
	if(insert_statement == nil) {
		static char *sql = "INSERT INTO todos (text, priority,complete, report) VALUES ('New Todo', '3', '0', 'New Report')";
		//prepare the statement
		if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1 (0, @"ERROR: Failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	// run the query
	int success = sqlite3_step(insert_statement);
	
	sqlite3_reset(insert_statement);
	if (success != SQLITE_ERROR) {
		return sqlite3_last_insert_rowid(database);
		
	}
	
	NSAssert1 (0, @"ERROR: Failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	return -1;
}


-(id) initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
	
	// Makes sure that the super class (NSObject) initilizes properly before we initilize a todo object.
	if (self = [super init]) {
	    //set the local primary key and database objects to the parameters{
		primaryKey = pk;
		database = db;
		// compile the query for retreiving data
		if (init_statement == nil) {
			const char* sql = "SELECT text,priority, complete FROM todos WHERE pk =?";
			if (sqlite3_prepare_v2(database, sql, -1,&init_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: Failed to prepare statement with message '%s'.",	sqlite3_errmsg(database));
			}
		}
		// bind the primary key to the only ? 
		sqlite3_bind_int(init_statement, 1, primaryKey);
		
	    //This method executes the SQL statement on the database. 
		if (sqlite3_step(init_statement) == SQLITE_ROW) {
			//The sqlite3_column_text method tells SQL that we want to retrieve a string object from the database
			//It has 2 parameters.  The first, is just a reference to the SQL statement that was used.  
			//The second is the column number that we wish to get text from.  
			self.text = [NSString stringWithUTF8String:(char *) sqlite3_column_text(init_statement, 0)];
			self.priority = sqlite3_column_int (init_statement, 1);
			self.status = sqlite3_column_int(init_statement, 2);
		} else {
			self.text = @"Nothing";
		}
		// Reset statement for future use
		sqlite3_reset(init_statement);
	}
	return self;
}

-(void) updateStatus:(NSInteger)newStatus {
	self.status = newStatus;
	dirty = YES;
}

-(void) updatePriority:(NSInteger)newPriority {
	
	self.priority = newPriority;
	dirty = YES;
}

-(void) dehydrate {

	if (dirty) {
	
		if (dehydrate_statement ==nil) {
			
		const char *sql = "UPDATE todos SET text =? priority = ?, complete= ? WHERE pk=?";
			if(sqlite3_prepare_v2 (database, sql, -1, &dehydrate_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: failed to prepare statement with error '%s'.", sqlite3_errmsg(database));
				
			}
		}

		
		sqlite3_bind_int(dehydrate_statement, 4, self.primaryKey);
		sqlite3_bind_int(dehydrate_statement, 3, self.status);
		sqlite3_bind_int(dehydrate_statement, 2, self.priority);
		sqlite3_bind_text(dehydrate_statement, 1, [self.text UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(dehydrate_statement);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_reset(dehydrate_statement);
		dirty = NO;
	}
	
}

@end
