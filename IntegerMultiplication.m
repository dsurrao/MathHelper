//
//  IntegerMultiplication.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntegerMultiplication.h"
#import "Utilities.h"
#import "DigitField.h"

@implementation IntegerMultiplication

@synthesize utils;

- (IntegerMultiplication *) initWithOperands :(int) iLeftOperand :(int) iLeftOperandDecimalPosition :(int) iRightOperand :(NSMutableArray *) iTargetDigitFieldArray {
    self = [super init];
	self.leftOperand = iLeftOperand;
	self.leftOperandDecimalPosition = iLeftOperandDecimalPosition;
	self.rightOperand = iRightOperand;
	self.targetDigitFieldArray = iTargetDigitFieldArray;
	self.utils = [[Utilities alloc] init];
    
	return self;
}

- (int) getLeftOperand {
	return self.leftOperand;
}

- (int) getRightOperand {
	return self.rightOperand;
}

- (int) execute {
	int result = (int) [self compute];
	int resultDecimalPosition = self.leftOperandDecimalPosition;
	[utils populateTarget: self.targetDigitFieldArray: result: resultDecimalPosition];
	[utils disableDigitFields:self.targetDigitFieldArray];
	return (result);
}

- (void) undo {
	DigitField *digitField;
	for (int i = 0; i < [self.targetDigitFieldArray count]; i++) {
		digitField = [self.targetDigitFieldArray objectAtIndex:i];
		[digitField getTextField].text = @"";
	}
	[self enableTargetDigitFields];
}

- (int) compute {
	return (self.leftOperand * self.rightOperand);
}

- (NSString *) getHint {
	NSString *hint = @"";
	NSNumber *leftOperandNumber = [NSNumber numberWithInt:self.leftOperand];
	NSNumber *rightOperandNumber = [NSNumber numberWithInt:self.rightOperand];
	NSNumber *resultNumber = [NSNumber numberWithInt:[self compute]];
	NSString *operandString = [leftOperandNumber stringValue];
	hint = [hint stringByAppendingString:operandString];
	hint = [hint stringByAppendingString:@" x "];
	operandString = [rightOperandNumber stringValue];
	hint = [hint stringByAppendingString:operandString];
	hint = [hint stringByAppendingString:@" = "];
	operandString = [resultNumber stringValue];
	hint = [hint stringByAppendingString:operandString];
	return hint;
}

- (int) checkForCorrectEntry: (UITextField *) iTextField {
	int ret = -1;
	DigitField *targetDigitField;
	
	int result = (int) [self compute];
	int resultDecimalPosition = self.leftOperandDecimalPosition;
	
	for (int i = 0; i < [self.targetDigitFieldArray count]; i++) {
		targetDigitField = [self.targetDigitFieldArray objectAtIndex:i];
		if (iTextField == [targetDigitField getTextField]) {
			if ([utils validateTargetDigitField: targetDigitField: result: resultDecimalPosition] == true) {
				if ([utils validateTarget: self.targetDigitFieldArray: result: resultDecimalPosition] == true) {
					ret = 1;
				}
				else {
					ret = 0;
				}
			}
		}
	}
		
	return ret;
}

- (void) enableTargetDigitFields {
	int result = (int) [self compute];
	int resultDecimalPosition = self.leftOperandDecimalPosition;
	[utils enableTargetDigitFields: self.targetDigitFieldArray: result: resultDecimalPosition];
}

- (void) disableTargetDigitFields {
	[utils disableDigitFields:self.targetDigitFieldArray];
}

- (void) clearTargetDigitFields {
	[utils clearDigitFields:self.targetDigitFieldArray];
}

@end
