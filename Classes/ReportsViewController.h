//
//  ReportsViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DateAndTimeLeaf.h"
#import "RootViewController.h"
#import "Utilities.h"
#import "GADBannerView.h"
#define kFileName @"accidently.plist"

@interface ReportsViewController : UITableViewController {

	NSMutableArray		*listData;
	DateAndTimeLeaf		*reportDetailedView; 
	UILabel             *titleLabel;
	NSString            *reportTitle;
	NSMutableDictionary *reportSentStatus;
	GADBannerView       *bannerView;

}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) DateAndTimeLeaf *reportDetailedView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) NSMutableDictionary *reportSentStatus;
@property (retain, nonatomic) IBOutlet      GADBannerView   *bannerView;


- (void)refreshDisplay:(UITableView *)tableView;
- (IBAction)    navigateToAddNewReport:(id) sender;
- (IBAction)    navigateToCall911 : (id) sender;
- (void)        loadDataFromFile;
- (void)		saveDataToFile;
- (void)        deleteReportFromDictionary: (NSUInteger) row;

@end
