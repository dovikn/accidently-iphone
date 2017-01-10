//
//  Utilities.m
//  Accident-ly
//
//  Created by Dovik Nissim on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities


NSMutableDictionary *dictionary;

// Get the accidently .plist file in the documents directory
-(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

-(void) loadDataFromFile {
	
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		return;
	}
	
	// if file exists, load Dictionary from file.
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		dictionary = [[NSMutableDictionary alloc] init];
		return;
	}
}

/**
 * Initialize
 */

-(void) initialize: (BOOL) print {
    
    if (print) {
        NSLog(@"[DEBUG]: ===============");
        NSLog(@"[DEBUG]: Initializing...");
        NSLog(@"[DEBUG]: ===============");
    }
    
    // Get the number of reports
    NSInteger reportsCount = 0;
    NSArray *reportsList = [dictionary objectForKey:@"Accidently-Reports"];
	if (reportsList == nil) {
		reportsCount = 0;
	} else {
        reportsCount = [reportsList count];
    }
    
    if (print) {
        NSLog(@"[DEBUG]: Number of Reports listed in the dictionary is %d", reportsCount);
      
    }
    
    // Get the number of Report Statuses:
    NSInteger reportsStatusesCount = 0;
    NSArray *reportsStatuses = [dictionary objectForKey:@"Accidently-ReportSentStatus"];
	if (reportsStatuses == nil) {
		reportsStatusesCount = 0;
	} else {
        reportsStatusesCount = [reportsStatuses count];
    }
    
    if (print) {
        NSLog(@"[DEBUG]: Number of Report Statuses listed in the dictionary is %d", reportsStatusesCount);
    }
    
    // Check the validity of the data.
    if (reportsStatusesCount == reportsCount) {
        if (print) {
            NSLog(@"[DEBUG]: Data is synchronized");
        }
        
    } else {
        NSLog(@"[ERROR]: Data is not synchronized!, running reset...");
        
        // Reseting data
        [self reset:print];
    }
    
    // check the validity of the report statuses list
    if ([self validateReportStatusesList:print]) {
        if (print) {
            NSLog(@"[DEBUG]: Reports statuses list is valid.");
        }
    } else {
        NSLog(@"[ERROR]: Reports statuses list is invalid, reseting user data...");
        
        // Reseting data
        [self reset:print];
    }
}


/**
 * Reset Data
 **/
-(void) reset: (BOOL) print {
    
    if (print) {
        NSLog(@"[DEBUG]: =====================");
        NSLog(@"[DEBUG]: Reseting user data...");
    }
    
    [self resetDectionary:nil];
    
    if (print) {
        NSLog(@"[DEBUG]: Reset completed...");
        NSLog(@"[DEBUG]: =====================");
    }
}

/**
 * Validate Report Status list
 **/
-(BOOL) validateReportStatusesList: (BOOL) print {
   
    if (print) {
        NSLog(@"[DEBUG]: Validating the report status list...");
    }
    
    // load data from file
    [self loadDataFromFile];
    
    // Get the report list: 
    NSArray *reportsList = [dictionary objectForKey:@"Accidently-Reports"];
    if (reportsList == nil || [reportsList count] == 0) {
        if (print) {
            NSLog(@"[DEBUG]: The report status list is empty and hence valid");
        }
        return YES;
    }
    
    // Get the the list of report Statuses:
    NSMutableDictionary *reportsStatuses = [dictionary objectForKey:@"Accidently-ReportSentStatus"];
    if (reportsStatuses == nil || [reportsStatuses count] == 0) {
        if (print) {
            NSLog(@"[ERROR]: The report status list is empty while the report list is not - hence it is invalid!");
        }
        return NO;
    }

    
    int i = [reportsList count];
    while ( i-- ) {
		NSString *s = [reportsList objectAtIndex:i];
        if (s == nil) {
            if (print) {
                NSLog(@"[ERROR]: The reports list contains an empty entry at index %d.", i);      
            }
            return NO;  
        }
        
        NSString *val = [reportsStatuses objectForKey:s];
        if (val == nil || [val length] == 0) {
            if (print) {
                NSLog(@"[ERROR]: The reports statuses list contains an empty entry for report name %@.", s);      
            }
            return NO;      
        }
	}
    
    if (print) {
        NSLog(@"[DEBUG]: The report status list is valid");
    }
    return YES;
}


/**
 * print Dictionary
 **/
- (void) printDictionary: (NSMutableDictionary *) dic {
    NSLog(@"Printing Dictionary");
    NSLog(@"===================");
    
    if (dic == nil) {
        NSLog(@"Dictionary is empty!");
        return;
    }
    if ([dic count] ==0) {
        NSLog(@"The dictionary is empty!");
        return;
        
    }
    

    NSArray *keyArray =  [dic allKeys];

    int count = [keyArray count];
    
    NSLog(@"The dictionary contains %d items." , count);
    
    for (int i=0; i < count; i++) {
        NSString *key = [ keyArray objectAtIndex:i];
    
        NSString  *val = [dic objectForKey:key];
        
        NSLog(@"Key: %@ val: %@\n", key,val);
        NSLog(@"===================");
        
        key = nil;
        val = nil;
        
    }
    return;
}

	
/**
 * Reset the report list
 */

- (void) resetReportList: (id) sender {
	
	// load the dictionary 
	[self loadDataFromFile];
	
	NSMutableArray *listData = [[NSMutableArray alloc] init];
	[dictionary setValue:listData forKey:@"Accidently-Reports"];
	
	
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While Reseting the report list , Failed to save data to Accidently.plist file!");
	}
}

/**
 *  Reset the report sent status list
 **/ 
- (void) resetReportSentStatusList: (id) sender {
	
	// load the dictionary 
	[self loadDataFromFile];
	
	NSMutableArray *reportSentStatuses = [[NSMutableArray alloc] init];
	[dictionary setValue:reportSentStatuses forKey:@"Accidently-ReportSentStatus"];
    
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While Reseting the report statuses list , Failed to save data to Accidently.plist file!");
	}
} 


/**
 * Reset the dictionary
 */

- (void) resetDectionary: (id) sender {
	
	// load the dictionary 
	[self loadDataFromFile];
	
	dictionary = [[NSMutableDictionary alloc] init]; 
	
	
	NSString *dataFile = [self dataFilePath];
	BOOL ret = [dictionary writeToFile:dataFile atomically:YES];
	if (ret == NO) {
		NSLog(@"[ERROR]: While Reseting the report list , Failed to save data to Accidently.plist file!");
	}
	
}

-(void) printObjectMethodList {
    
        if (self == nil ) {
            NSLog(@"DEBUG: Self is nil!");  
        
        }
        
        int i=0;
        unsigned int mc = 0;
        Method * mlist = class_copyMethodList(object_getClass(self), &mc);
        NSLog(@"DEBUG: NSObject has %d methods", mc);
        for(i=0;i<mc;i++)
            NSLog(@"DEBUG: Method no #%d: %s", i, sel_getName(method_getName(mlist[i])));
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}


- (void)dealloc {
    [super dealloc];
}

-(NSInteger) numberOfPendingReports {
    
	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		dictionary = [[NSMutableDictionary alloc] init];
		return 0;
	}
	
	// if file exists, load Dictionary from file.
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		return 0;
	}
	
	// check if the dictionary is empty 
	if ([dictionary count] == 0) {
		return 0;
	}
	
	// set the reportSentStatus Dictionary 
	NSMutableDictionary * md = [dictionary objectForKey:@"Accidently-ReportSentStatus"];
	
	if (md == nil) {
		return 0;
	}
	
	if ([md count] == 0) {
		return 0;
	}
	
	NSArray *allValues = [md allValues];
	NSInteger sum = 0;
	int i = [allValues count];
	while ( i-- ) {
		NSString *s = [allValues objectAtIndex:i];
		sum = sum + [s intValue];
	}
	return sum;	
}


/**
 ** Print listData
 **/ 
- (void) printListData: (NSMutableArray *) list {
    
    NSLog(@"Printing list");
    NSLog(@"===================");
    
    if (list == nil) {
        NSLog(@"The list is empty!");
        return;
    }
    
    if ([list count] == 0) {
        NSLog(@"The list is empty!");
        return;
    }
    
    int count = [list count];
    int i =0;
    
    NSLog(@"The list contains %d items." , count);
    
    NSEnumerator *e = [list objectEnumerator];
    id object;
    
    while (object = [e nextObject]) {
        
        NSString *val = (NSString *) object;
        NSLog(@"Index: %d val: %@\n", i,val);
        i++;
        val = nil;
    }
    return;
}




@end
