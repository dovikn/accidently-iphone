//
//  Contact.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Contact : NSObject <NSCoding> {
	NSString *name;
	NSString *type;
	NSString *address;
	NSString *phone;
	
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *phone;


@end
