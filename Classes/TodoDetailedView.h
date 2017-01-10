//
//  TodoDetailedView.h
//  Accident-ly
//
//  Created by Dovik Nissim on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"
#import "TodoViewController.h"


@interface TodoDetailedView : UIViewController {
	UITextField			*textField;
	UISegmentedControl	*segmentedPriorities;
	UILabel				*priorityLabel;
	UILabel				*descriptionLabel;
	UIButton			*updateButton;
	UIButton			*cancelButton;
	Todo				*todo;
	sqlite3				*database;
	BOOL				dirty;
	BOOL				addNewFlag;
	NSString			*reportTitle;
	UINavigationBar		*naviBar;
    UIScrollView        *scrollView;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedPriorities;
@property (nonatomic, retain) IBOutlet UILabel *priorityLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) Todo *todo;
@property  (nonatomic)sqlite3 *database;
@property (nonatomic) BOOL addNewFlag;
@property (nonatomic, retain) NSString *reportTitle;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


//Method declarations 
-(IBAction) updatePriority:(id)sender;
-(IBAction) updateText: (id) sender;
-(IBAction) addNewOrEditTask: (id) sender;
-(IBAction) cancel: (id) sender;
-(IBAction) textFieldDoneEditing: (id) sender;
-(IBAction) backgroundTap: (id)sender;

-(void) addNewTask;
-(void) editExistingTask;
-(void) editExistingTaskInDatabase;
- (NSInteger) insertNewTaskIntoDatabase;
- (void) insertNewTaskToTaskList: (NSInteger)pk;

@end
