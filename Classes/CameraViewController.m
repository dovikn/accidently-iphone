//
//  CameraViewController.m
//  Accident-ly
//
//  Created by Dovik Nissim on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"


@implementation CameraViewController

@synthesize imageView;
@synthesize takePhotoBtn;
@synthesize naviBar;
@synthesize reportTitle;
@synthesize imageNames;
@synthesize cancelBtn;

NSMutableDictionary *dictionary;

/**
 ** viewDidLoad
 **/
- (void)viewDidLoad {
    
    // Load data from File
	[self loadDataFromFile];
	
	// set the title to be black
	[naviBar setTintColor:[UIColor blackColor]];
	
	// Set the background image
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.png"]];	
    
	//in case there is no camera, hide the take picture button.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        takePhotoBtn.hidden = YES;
    }
    
    NSString *activeReportKey = @"Accidently-ActiveReport"; 
    if (reportTitle != nil) {
        [dictionary setObject:reportTitle forKey: activeReportKey];
    }
}


/**
 ** Get the accidently .plist file path within the documents directory
**/
 -(NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirecory  = [paths objectAtIndex:0];
	return [documentsDirecory stringByAppendingPathComponent:kFileName];
}

/**
 ** load the data from the .plist file
 **/
-(void) loadDataFromFile {

	// Get the .plist URL
	NSString *dataFilePath = [self dataFilePath];
	
	//check if file exists, if it doesn't - nothing to do.
	if([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]== NO){
		return;
	}
	
	// Load the Dictionary 
	dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataFilePath];
	if (dictionary == nil) {
		return;
	}

    reportTitle = (NSString *) [dictionary objectForKey:@"Accidently-ActiveReport"];
    
    NSString *key = @"Accidently-";
    key = [key stringByAppendingString:reportTitle];
	key = [key stringByAppendingString:@"-ImageNames"];

	// Populate data from  Dictionary 
	imageNames = [dictionary objectForKey: key];
	if (imageNames == nil) {
		imageNames = [[NSMutableArray alloc] init];
    }
}

/**
 ** Save the dictionary to the database
 **/
-(void) saveDataToFile {

    
   	// In  case the dictionary is nil
	if (dictionary == nil) {
		dictionary =[[NSMutableDictionary alloc] init];
	}
	
	//Persist the  contents of dictionary to the .plist.
	NSString *dataFile = [self dataFilePath];
	BOOL res = [dictionary writeToFile:dataFile atomically:YES];
	
    if (res == NO) {
		NSLog(@"[ERROR]: While saving information about pictures that were taken (CameraViewController), Failed to save data to Accidently.plist file!");
	}
}

/**
 ** Open the camera
 **/
- (IBAction)getCameraPicture:(id)sender {
    
    UIImagePickerController *picker =[[UIImagePickerController alloc] init];
	
    // Set source to the camera
	picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    
    // picker.allowsImageEditing = YES;
    
    [self presentModalViewController:picker animated:YES];
 
}


/**
 ** The user click cancel
**/

-(IBAction) cancel: (id) sender{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    // Was there an error?
    if (error != nil)
    {
        // Show error message...
        NSLog(@"[ERROR] While saving a photo, the following error was presented %@", [error description]);
        return;
       // 
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog (@"[WARNING] While saving a photo, the image was successfuly saved");
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // Access the uncropped image from info dictionary
	UIImage *myImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	UIImageWriteToSavedPhotosAlbum(myImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	
    //
    // Save image to disk 
	[self saveImage:myImage];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

/**
 ** Save the image to the .plist
 **/
- (IBAction) saveImage: (UIImage *) image {

	// Get the URL for the documents library
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	// create the image name
	NSString *imageName = @"Accidently-";
    
    // get the report title
    [self loadDataFromFile];
    imageName = [imageName stringByAppendingString:reportTitle];
    imageName = [imageName stringByAppendingString:@"-"];
   
    // add random number
    NSInteger randomNumber =   arc4random() % 999;//
	NSString *randomString = [NSString stringWithFormat:@"%d", randomNumber];
	imageName = [imageName stringByAppendingString:randomString];
   
    // add a suffix
    NSString *imageNameWithSuffix = imageName;
	imageNameWithSuffix = [imageNameWithSuffix stringByAppendingString:@".jpg"];

	// Create the path
	NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageNameWithSuffix];
	
	// save the image to the disk
	NSData *imageData = UIImageJPEGRepresentation(image,1.0);
	[imageData writeToFile:savedImagePath atomically:NO];	
    
    // add the image name to the list of saved images
	[imageNames addObject:imageNameWithSuffix];
    
    // save the image names.
    NSString *imageNamesKey = @"Accidently-";
    imageNamesKey = [imageNamesKey stringByAppendingString:reportTitle];
	imageNamesKey = [imageNamesKey stringByAppendingString:@"-ImageNames"];
	
	// Add an item to the dictionary 
    [dictionary setObject:imageNames forKey: imageNamesKey];
    
    [self saveDataToFile];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	NSLog(@"[WARNING] While saving information relatedz to pictures (CameraViewController), Accidently received a memory warning!");
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    imageView       = nil;
	takePhotoBtn    = nil;
	naviBar         = nil;
	reportTitle     = nil;
	imageNames      = nil;
}

- (void)dealloc {
	[naviBar        release];
	[imageView      release];
	[takePhotoBtn   release];
    [reportTitle    release];
	[imageNames     release];
	[super          dealloc];
}

@end
