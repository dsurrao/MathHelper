    //
//  MainMenuController.m
//  MathHelp
//
//  Created by Dominic Surrao on 3/12/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "MainMenuController.h"
#import "MultiplicationMainViewController.h"
#import "DivisionMainViewController.h"
#import "DivisionRemainderMainViewController.h"

@implementation MainMenuController

@synthesize multiplicationButton;
@synthesize divisionButton;
@synthesize divisionRemainderButton;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (bool)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction) loadMultiplicationView: (id)sender {
    MultiplicationMainViewController *multiplicationMainViewController = 
		[[MultiplicationMainViewController alloc] initWithNibName:@"MultiplicationMain" bundle:[NSBundle mainBundle]];
	[[self navigationController] pushViewController:multiplicationMainViewController animated:YES];
}

- (IBAction) loadDivisionView: (id)sender {
	DivisionMainViewController *divisionMainViewController = 
		[[DivisionMainViewController alloc] initWithNibName:@"DivisionMain" bundle:[NSBundle mainBundle]];
	[[self navigationController] pushViewController:divisionMainViewController animated:YES];
}

- (IBAction) loadDivisionRemainderView: (id)sender {
	DivisionRemainderMainViewController *divisionRemainderMainViewController = 
	[[DivisionRemainderMainViewController alloc] initWithNibName:@"DivisionRemainderMainViewController" 
														  bundle:[NSBundle mainBundle]];
	[[self navigationController] pushViewController:divisionRemainderMainViewController animated:YES];
}

- (IBAction) openInAppStore: (id)sender {
    #define YOUR_APP_STORE_ID 413868164 //Change this one to your ID
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=MathHelperid=%d";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]];
    
    [[UIApplication sharedApplication] openURL:(url)];
}

@end


