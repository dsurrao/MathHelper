//
//  MainMenuController.h
//  MathHelp
//
//  Created by Dominic Surrao on 3/12/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainMenuController : UIViewController <UINavigationBarDelegate> {
	UIButton *__weak multiplicationButton;
	UIButton *__weak divisionButton;
	UIButton *__weak divisionRemainderButton;
}

@property (nonatomic, weak) IBOutlet UIButton *multiplicationButton;
@property (nonatomic, weak) IBOutlet UIButton *divisionButton;
@property (nonatomic, weak) IBOutlet UIButton *divisionRemainderButton;

- (IBAction)loadMultiplicationView:(id)sender;
- (IBAction)loadDivisionView:(id)sender;
- (IBAction)loadDivisionRemainderView:(id)sender;
- (IBAction)openInAppStore:(id)sender;

@end
