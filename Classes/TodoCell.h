//
//  TodoCell.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"


@interface TodoCell : UITableViewCell {

	Todo * todo;
	UILabel *todoTextLabel;
	UILabel *todoPriorityLabel;
	UIImageView *todoPriorityImageView;
}

@property (nonatomic, retain) UILabel *todoTextLabel;
@property (nonatomic, retain) UILabel *todoPriorityLabel;
@property (nonatomic, retain) UIImageView *todoPriorityImageView;
@property (nonatomic, retain) Todo  *todo;

-(UIImageView *)imageForPriority:(NSInteger)priority;

-(Todo*) todo;
- (void) setTodo: (Todo *) newTodo;

@end
