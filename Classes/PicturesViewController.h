//
//  PicturesViewController.h
//  Accident-ly
//
//  Created by Dovik Nissim on 1/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PicturesViewController : UIViewController {
	UITabBarController *tabController;
}
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;

@end
