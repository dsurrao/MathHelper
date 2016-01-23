//
//  MultiplicationMainViewController.h
//  MathHelp
//
//  Created by Dominic Surrao on 3/12/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiplicationMainViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource> {
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
