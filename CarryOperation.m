//
//  CarryOperation.m
//  MathHelp
//
//  Created by Dominic Surrao on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CarryOperation.h"
#import "DigitField.h"
#import "Utilities.h"

@implementation CarryOperation

@synthesize utils, numberFormatter;

- (CarryOperation *) initWithOperands: (DigitField *) iLeastPopulatedDigitField {
    self = [super init];
	self.leastPopulatedDigitField = iLeastPopulatedDigitField;
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	self.utils = [[Utilities alloc] init];
	return self;
}

- (int) execute {	
	NSString *carryStr = [[[self.leastPopulatedDigitField getCarryDigitField] getTextField] text];
	UITextField *carryTarget = [[self.leastPopulatedDigitField getCarryTargetDigitField] getTextField];

	/*	populate empty digit slot with carry digit */
	carryTarget.text = carryStr;

	/*	
	 the carry digit field appended to the current subtraction digit becomes the left operand
	 for the next division operation
	 */
	NSString *prefixStr = [[self.leastPopulatedDigitField getTextField] text];
	NSString *leftOperandStr = [prefixStr stringByAppendingString:carryStr]; 	
	[[self.leastPopulatedDigitField getCarryTargetDigitField] disable];
	
	return [[numberFormatter numberFromString:leftOperandStr] intValue];
}

- (void) undo {
	UITextField *carryTarget = [[self.leastPopulatedDigitField getCarryTargetDigitField] getTextField];
	carryTarget.text = @""; 	/*	empty carry target digit slot */
	[self enableTargetDigitFields];
}

- (NSString *) getCarryStr {
	NSString *carryStr = [[[self.leastPopulatedDigitField getCarryDigitField] getTextField] text];
	return (carryStr);
}

- (NSString *) getHint {
	NSString *hint = @"Bring down ";
	hint = [hint stringByAppendingString:[self getCarryStr]];
	return hint;
}

- (void) enableTargetDigitFields {
	[[self.leastPopulatedDigitField getCarryTargetDigitField] enable];
}

- (void) disableTargetDigitFields {
	[[self.leastPopulatedDigitField getCarryTargetDigitField] disable];
}

- (void) clearTargetDigitFields {
	UITextField *target = [[self.leastPopulatedDigitField getCarryTargetDigitField] getTextField];
	if (target != NULL) {
		target.text = @"";
	}
}

- (int) checkForCorrectEntry:(UITextField *) iTextField {
	int ret = -1;
	NSString *enteredString = [[NSString alloc] initWithString: [iTextField text]];
	DigitField *carryDigitField = [self.leastPopulatedDigitField getCarryDigitField];
	DigitField *carryTargetDigitField = [self.leastPopulatedDigitField getCarryTargetDigitField];
	if (iTextField == [carryTargetDigitField getTextField]) {
		if ([enteredString isEqualToString:[[carryDigitField getTextField] text]]) {
			ret = 1;
		}
	}
	return ret;
}


@end
