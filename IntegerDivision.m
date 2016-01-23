//
//  IntegerDivision.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntegerDivision.h"
#import "Utilities.h"

@implementation IntegerDivision

- (IntegerDivision *) initWithOperands :(int) iLeftOperand :(int) iRightOperand :(DigitField *) iTargetDigitField {
	leftOperand = iLeftOperand;
	rightOperand = iRightOperand;
	targetDigitField = iTargetDigitField;
	return self;
}

- (int) getLeftOperand {
	return leftOperand;
}

- (int) getRightOperand {
	return rightOperand;
}

- (int) execute {	
	NSString *resultWholeNumberStr = [[self getResultWholeNumber] stringValue];
	UITextField *targetTextField = [targetDigitField getTextField];
	targetTextField.text = resultWholeNumberStr;
	[targetDigitField disable];
	return ([resultWholeNumberStr intValue]);
}

- (void) undo {
	[targetDigitField getTextField].text = @"";
	[targetDigitField enable];	
}

- (NSString *) getHint {
	NSNumber *rightOperandNumber = [NSNumber numberWithInt:rightOperand];
	NSNumber *leftOperandNumber = [NSNumber numberWithInt:leftOperand];
	NSNumber *remainderNumber = [self getRemainderNumber];
	NSString *hint = [leftOperandNumber stringValue];	
	hint = [hint stringByAppendingString:@" ÷ "];
	hint = [hint stringByAppendingString:[rightOperandNumber stringValue]];
	hint = [hint stringByAppendingString:@" = "];
	hint = [hint stringByAppendingString:[[self getResultWholeNumber] stringValue]];
	if ([remainderNumber intValue] > 0) {
		hint = [hint stringByAppendingString:@" remainder "];
		hint = [hint stringByAppendingString:[remainderNumber stringValue]];
	}
	return hint;		
}

- (int) checkForCorrectEntry: (UITextField *) iTextField {
	int ret = -1;
	if (iTextField == [targetDigitField getTextField]) {
		if ([[iTextField text] isEqualToString:[[self getResultWholeNumber] stringValue]]) {
			ret = 1;
		}
	}
	return ret;
}

- (NSDecimalNumber *) getResultWholeNumber {
	NSDecimalNumberHandler* roundingBehavior = 
		[[NSDecimalNumberHandler alloc] 
	initWithRoundingMode:NSRoundDown scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
	float result = leftOperand/rightOperand;
	NSDecimalNumber *resultDec = [[NSDecimalNumber alloc] initWithFloat:result];
	NSDecimalNumber *roundedResultDec = [resultDec decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
	return roundedResultDec;
}

- (NSNumber *) getRemainderNumber {
	int remainder = leftOperand - ([[self getResultWholeNumber] intValue] * rightOperand);
	return ([NSNumber numberWithInt:remainder]);
}

- (void) enableTargetDigitFields {
	[targetDigitField enable];
}

- (void) disableTargetDigitFields {
	[targetDigitField disable];
}

- (void) clearTargetDigitFields {
	targetDigitField.getTextField.text = @"";
}

@end
