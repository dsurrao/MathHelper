//
//  AdditionOperation.m
//  MathHelp
//
//  Created by Dominic Surrao on 2/5/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "AdditionOperation.h"
#import "NumberParser.h"

@implementation AdditionOperation

- (AdditionOperation *) initWithOperands: 
	(DigitField *) iLeftOperandDigitField :
	(DigitField *) iRightOperandDigitField :
	(DigitField *) iTargetDigitField :
	(int) iCarriedOverVal {
	leftOperandDigitField = iLeftOperandDigitField;
	rightOperandDigitField = iRightOperandDigitField;
	targetDigitField = iTargetDigitField;
	carriedOverVal = iCarriedOverVal;
	return self;
}

- (int) execute {
	int retCarry;
	int result = [self compute];
	if (result < 10) {
		[targetDigitField getTextField].text = [[NSNumber numberWithInt:result] stringValue];
		retCarry = 0;
	}
	else {
		NumberParser *numParser = [[NumberParser alloc] init];
		NSMutableArray *resultArray = [numParser parseInteger:result];
		[targetDigitField getTextField].text = [[resultArray objectAtIndex:0] stringValue];
		retCarry = [[resultArray objectAtIndex:1] intValue];
	}
	return (retCarry);
}

- (int) compute {
	int leftOperand = 0;
	int rightOperand = 0;
	if (leftOperandDigitField != NULL) {
		leftOperand = [[[leftOperandDigitField getTextField] text] intValue];
	}
	if (rightOperandDigitField != NULL) {
		rightOperand = [[[rightOperandDigitField getTextField] text] intValue];
	}
	int result = leftOperand + rightOperand + carriedOverVal;
	return (result);
}

- (void) undo {
	DigitField *carryTargetDigitField = nil;
	[targetDigitField getTextField].text = @"";
	carryTargetDigitField = [targetDigitField getCarryTargetDigitField];
	if (carryTargetDigitField != nil) {
		[carryTargetDigitField getTextField].text = @"";
	}
}

- (NSString *) getHint {
	int result = [self compute];
	NSNumber *resultNumber = [NSNumber numberWithInt:result];
	NSString *leftOperandStr = @"0";
	NSString *rightOperandStr = @"0";
	if (leftOperandDigitField != NULL) {
		if (![[[leftOperandDigitField getTextField] text] isEqualToString:@""]) {
			leftOperandStr = [[leftOperandDigitField getTextField] text];
		}
	}
	if (rightOperandDigitField != NULL) {
		if (![[[rightOperandDigitField getTextField] text] isEqualToString:@""]) {
			rightOperandStr = [[rightOperandDigitField getTextField] text];
		}
	}
	NSString *hint = leftOperandStr;	
	hint = [hint stringByAppendingString:@" + "];
	hint = [hint stringByAppendingString:rightOperandStr];
	if (carriedOverVal > 0) {
		NSNumber *carriedOverValNumber = [NSNumber numberWithInt:carriedOverVal];
		hint = [hint stringByAppendingString:@" + "];
		hint = [hint stringByAppendingString:[carriedOverValNumber stringValue]];
		hint = [hint stringByAppendingString:@"(carry)"];
	}
	hint = [hint stringByAppendingString:@" = "];
	hint = [hint stringByAppendingString:[resultNumber stringValue]];
	return hint;		
}

- (void) enableTargetDigitFields {
	[targetDigitField enable];	
	int result = [self compute];
	if (result >= 10) {
		if ([targetDigitField getCarryTargetDigitField] != NULL) {
			[[targetDigitField getCarryTargetDigitField] enable];
		}
	}	
}

- (int) checkForCorrectEntry: (UITextField *) iTextField {	
	int ret = -1;
	NumberParser *numParser = [[NumberParser alloc] init];
	int result = [self compute];
	NSMutableArray *resultArray = [numParser parseInteger:result];
	if ([targetDigitField getTextField] == iTextField) {
		if ([[[resultArray objectAtIndex:0] stringValue] isEqualToString:[iTextField text]]) {
			if ([resultArray count] > 1) {
				if ([targetDigitField getCarryTargetDigitField] == NULL) {
					ret = 1;
				}
				else {
					ret = 2;
				}
			} 
			else {
				ret = 1;
			}
		}
	}	
	else if ([targetDigitField getCarryTargetDigitField] != NULL) {
		if ([[targetDigitField getCarryTargetDigitField] getTextField] == iTextField) {
			if ([resultArray count] > 1) {
				if ([[[resultArray objectAtIndex:1] stringValue] isEqualToString:[iTextField text]]) {
					ret	= 1;
				}
			}
		}
	}
	
	return ret;	
}

- (void) clearTargetDigitFields {
	[targetDigitField getTextField].text = @"";
	if ([targetDigitField getCarryTargetDigitField] != NULL) {
		[[targetDigitField getCarryTargetDigitField] getTextField].text = @"";
	}
}

@end
