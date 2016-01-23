//
//  IntegerSubtraction.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntegerSubtraction.h"
#import "Utilities.h"

@implementation IntegerSubtraction

@synthesize utils;

- (IntegerSubtraction *) initWithOperands :
	(int) iLeftOperand :
	(int) iLeftOperandDecimalPosition :
	(int) iRightOperand :
	(NSMutableArray *) iTargetDigitFieldArray {
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
	int result = [self compute];
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

- (NSString *) getHint {
	NSString *hint = @"";
	NSNumber *leftOperandNumber = [NSNumber numberWithInt:self.leftOperand];
	NSNumber *rightOperandNumber = [NSNumber numberWithInt:self.rightOperand];
	NSNumber *resultNumber = [NSNumber numberWithInt:[self compute]];
	NSString *operandString = [leftOperandNumber stringValue];
	hint = [hint stringByAppendingString:operandString];
	hint = [hint stringByAppendingString:@" - "];
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

- (int) compute {
	return (self.leftOperand - self.rightOperand);
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
