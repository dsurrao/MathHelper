//
//  DivisionRemainderMainViewController.h
//  MathHelp
//
//  Created by Dominic Surrao on 11/30/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DivisionRemainderMainViewController : UIViewController {
	UITextField *__weak dividendWhole;
	UITextField *__weak dividendFraction;
	UITextField *__weak divisor;
	UIButton *__weak continueButton;
}

@property (nonatomic, weak) IBOutlet UITextField *dividendWhole;
@property (nonatomic, weak) IBOutlet UITextField *dividendFraction;
@property (nonatomic, weak) IBOutlet UITextField *divisor;
@property (nonatomic, weak) IBOutlet UIButton *continueButton;

- (IBAction) loadDivisionRemainderView:(id)sender;

@end
