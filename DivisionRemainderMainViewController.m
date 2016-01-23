//
//  DivisionRemainderMainViewController.m
//  MathHelp
//
//  Created by Dominic Surrao on 11/30/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "DivisionRemainderMainViewController.h"
#import "DivisionRemainderViewController.h"

@implementation DivisionRemainderMainViewController

@synthesize dividendWhole;
@synthesize dividendFraction;
@synthesize divisor;
@synthesize continueButton;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									  target:self 
									  action:@selector(loadDivisionRemainderView:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (bool)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) loadDivisionRemainderView:(id)sender {
	NSString *divisorStr = [divisor text];
	NSString *dividendStr = [dividendWhole text];
	dividendStr = [dividendStr stringByAppendingString:@"."];
	dividendStr = [dividendStr stringByAppendingString:[dividendFraction text]];
	
	if (![dividendStr isEqualToString:@"."] && ![divisorStr isEqualToString:@""]) {
		DivisionRemainderViewController *divisionRemainderViewController 
			= [[DivisionRemainderViewController alloc] 
			   initWithNibName:@"DivisionRemainderViewController" bundle:[NSBundle mainBundle]];
		divisionRemainderViewController.divisor = [divisorStr intValue];	
		divisionRemainderViewController.dividend = [NSDecimalNumber decimalNumberWithString:dividendStr];
		[[self navigationController] pushViewController:divisionRemainderViewController animated:YES];		
	}
	else {
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Incomplete entry"
                                            message:@"Please enter a complete problem"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
	}
}

/* Ensures that a maximum of 1 digit for divisor and 2 digits for each dividend text box is entered */
- (bool)textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	int maxLength;
	if ([textField isEqual:divisor]) {
		maxLength = 1;
	}
	else {
		maxLength = 2;
	}
	if ([string length] == maxLength) {
		textField.text = string;
		[textField resignFirstResponder];
	}
	return !([newString length] > maxLength);	
}

/*
 When the user hits return, check if the correct entry has been made in the text field.
 */
- (bool)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

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




@end
