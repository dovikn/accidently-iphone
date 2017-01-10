//
//  Todo.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>




@interface Todo : NSObject {

	sqlite3 *database;
	NSInteger primaryKey;
	NSString *text;
	NSInteger priority;
	NSInteger status;
	BOOL dirty;
}
@property (nonatomic, assign, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString *text; 
@property (nonatomic) NSInteger priority; 
@property (nonatomic) NSInteger status;


-(id)initWithPrimaryKey: (NSInteger)pk database: (sqlite3 *)db;
-(void) updateStatus:(NSInteger) newStatus;
-(void) updatePriority:(NSInteger) newPriority;
-(void) dehydrate;

+(NSInteger) insertNewTodoIntoDatabase: (sqlite3 *)database;



@end
