//
//  Utilities.h
//  Accident-ly
//
//  Created by Dovik Nissim on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"accidently.plist"
//DEBUG
#import <objc/runtime.h>

@interface Utilities : UITableViewCell {
}

// Method declarations:
- (NSString *)  dataFilePath;
- (void)        loadDataFromFile;
- (void)        resetReportList: (id) sender;
- (void)        resetDectionary: (id) sender;
- (void)        printDictionary: (NSMutableDictionary *) dic;
- (void)        printObjectMethodList;
- (void)        initialize: (BOOL) print;
- (void)        reset: (BOOL) print;
- (BOOL)        validateReportStatusesList: (BOOL) print;
- (NSInteger)   numberOfPendingReports; 
- (void)        printListData: (NSMutableArray *) list;

@end
