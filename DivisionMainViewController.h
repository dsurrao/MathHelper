//
//  DivisionMainViewController.h
//  MathHelp
//
//  Created by Dominic Surrao on 9/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DivisionMainViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource> {
	UILabel *__weak label;
	UITableView *__weak problemsTableView;
	NSDictionary *outlineData;
	NSMutableArray *problems;
}

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UITableView *problemsTableView;
@property (nonatomic, strong) NSDictionary *outlineData;
@property (nonatomic, strong) NSMutableArray *problems;

@end
