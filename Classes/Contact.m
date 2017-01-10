//
//  Contact.m
//  Accident-ly
//
//  Created by Dovik Nissim on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"


@implementation Contact
@synthesize name;
@synthesize type;
@synthesize address;
@synthesize phone;

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super init]) // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
	{
		self.name = [[aDecoder decodeObjectForKey:@"name"] retain];
		self.type = [[aDecoder decodeObjectForKey:@"type"] retain];
		self.address = [[aDecoder decodeObjectForKey:@"address"] retain];
		self.phone = [[aDecoder decodeObjectForKey:@"phone"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:type forKey:@"type"];
	[encoder encodeObject:address forKey:@"address"];
	[encoder encodeObject:phone forKey:@"phone"];
}


@end
