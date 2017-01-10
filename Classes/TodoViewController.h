//
//  TodoViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"
#import <sqlite3.h>
#import "Todo.h"
#import "TodoCell.h"
#import "TodoDetailedView.h"


@interface TodoViewController : UITableViewController {
	NSMutableArray *todos;
	sqlite3 *database;
	NSString *reportTitle;
}


@property (nonatomic, retain) NSMutableArray *todos;
@property (nonatomic, retain) NSString * reportTitle;
- (void) createEditableCopyOfDatabaseIfNeeded;
- (void) initializeDatabase;
- (void) addTodo:(id)sender;
-(void) deleteTaskFromDatabase: (Todo *)task;
- (void) removeTask: (Todo *) task;
- (UIImage *) imageForPriority:(NSInteger)priority;



@end
