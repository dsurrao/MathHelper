    //
//  DivisionMainViewController.m
//  MathHelp
//
//  Created by Dominic Surrao on 9/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DivisionMainViewController.h"
#import "DivisionViewController.h"

@implementation DivisionMainViewController

@synthesize label, problemsTableView, outlineData, problems;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization	
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *finalPath = [path stringByAppendingPathComponent:@"problems.plist"];
		NSDictionary *d;
		NSArray *a;
		NSMutableArray *problem;
		NSNumber *keyNum, *dividendNum, *divisorNum;
		outlineData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		problems = [[NSMutableArray alloc] init];
		NSArray	*fileProblemArray = [outlineData objectForKey:@"Problems"];
		for (int i = 0; i < [fileProblemArray count]; i++) {
			d = [fileProblemArray objectAtIndex:i];
			keyNum = [NSNumber numberWithInt:i+1];
			a = [d objectForKey:[keyNum stringValue]];			
			dividendNum = [a objectAtIndex:0];
			divisorNum = [a objectAtIndex:1];
			problem = [[NSMutableArray alloc] init];
			[problem addObject:[dividendNum stringValue]];
			[problem addObject:[divisorNum stringValue]]; 
			[problems addObject:problem];
		}
    }
    return self;
}


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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [problems count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Solve: ";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
	NSMutableArray *problemRow = [problems objectAtIndex:indexPath.row];	
	cell.textLabel.text = [[[problemRow objectAtIndex:0] stringByAppendingString:@" ÷ "]
						   stringByAppendingString:[problemRow objectAtIndex:1]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	DivisionViewController *divisionViewController = [[DivisionViewController alloc] 
													  initWithNibName:@"Division" bundle:[NSBundle mainBundle]];
	NSMutableArray *problemRow = [problems objectAtIndex:indexPath.row];	
	divisionViewController.dividend = [[problemRow objectAtIndex:0] intValue];
	divisionViewController.divisor = [[problemRow objectAtIndex:1] intValue];
	[[self navigationController] pushViewController:divisionViewController animated:YES];
}

@end


