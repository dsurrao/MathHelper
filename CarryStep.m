//
//  CarryStep.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "CarryStep.h"


@implementation CarryStep

- (CarryStep *) initWithOperands: (DigitField *) iCarryDF : (DigitField *) iTargetDF : (int) iStepNumber {
	carryDF	= iCarryDF;
	targetDF = iTargetDF;
	stepNumber = iStepNumber;
	return self;
}

- (DigitField *) getCarryDF {
	return carryDF;
}

- (int) getStepNumber {
	return stepNumber;
}

- (NSMutableArray *) doStep:(bool) silentFlag {
	[targetDF setCharValue:[carryDF getCharValue]];
	if (!silentFlag) {
		if ([[targetDF getCharValue] isEqualToString:@""]) {
			[targetDF getTextField].text = @"0";
			[targetDF setCharValue:@"0"];
		}
		else {
			[targetDF getTextField].text = [targetDF getCharValue];
		}
	}
	return ([NSMutableArray arrayWithObject:targetDF]);
}

- (NSString *) getHint {
	NSString *hintStr = @"Bring down ";
	NSString *carryStr = @"";
	[self doStep:true];
	if ([[targetDF getCharValue] isEqualToString:@""]) {
		carryStr = @"0";
	}
	else {
		carryStr = [targetDF getCharValue];
	}
	hintStr = [hintStr stringByAppendingString:carryStr];
	return (hintStr);
}

- (bool) checkForCorrectEntry: (UITextField *) iTextField {
	bool retFlag = false;
	if ([targetDF getTextField] == iTextField) {
		[self doStep:true];
		if ([[targetDF getCharValue] isEqualToString:@""] & [[iTextField text] isEqualToString:@"0"]) {
			retFlag = true;
		}
		else if ([[targetDF getCharValue] isEqualToString:[iTextField text]]) {
			retFlag = true;
		}
	}
	return retFlag;
}

- (bool) targetContainsTextField:(UITextField *) iTextField {
	if ([targetDF getTextField] == iTextField) {
		return true;
	}
	else {
		return false;
	}

}

- (void) undo {
	[targetDF getTextField].text = @"";
}

@end
