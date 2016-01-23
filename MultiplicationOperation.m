//
//  MultiplicationOperation.m
//  MathHelp
//
//  Created by Dominic Surrao on 1/26/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "MultiplicationOperation.h"
#import "NumberParser.h"

@implementation MultiplicationOperation

- (MultiplicationOperation *) initWithOperands: 
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
		
		/* if the target digit field has a carry target digit field, populate it */
		DigitField *carryTargetDigitField = [targetDigitField getCarryTargetDigitField];
		if (carryTargetDigitField != NULL) {
			[carryTargetDigitField getTextField].text = [[resultArray objectAtIndex:1] stringValue];
			retCarry = 0; /* no need to return carry value as digit field is already populated */
		}
		
	}
	return (retCarry);
}

- (int) compute {
	int leftOperand = [[[leftOperandDigitField getTextField] text] intValue];
	int rightOperand = [[[rightOperandDigitField getTextField] text] intValue];
	int result = (leftOperand * rightOperand) + carriedOverVal;
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
	NSString *hint = [[leftOperandDigitField getTextField] text];	
	hint = [hint stringByAppendingString:@" × "];
	hint = [hint stringByAppendingString:[[rightOperandDigitField getTextField] text]];
	if (carriedOverVal > 0) {
		NSNumber *carriedOverValNumber = [NSNumber numberWithInt:carriedOverVal];
		NSString *openParen = @"(";
		hint = [openParen stringByAppendingString:hint];
		hint = [hint stringByAppendingString:@") + "];
		hint = [hint stringByAppendingString:[carriedOverValNumber stringValue]];
		hint = [hint stringByAppendingString:@"(carry)"];
	}
	hint = [hint stringByAppendingString:@" = "];
	hint = [hint stringByAppendingString:[resultNumber stringValue]];
	return hint;		
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
				else if ([[[[targetDigitField getCarryTargetDigitField] getTextField] text] isEqualToString:[[resultArray objectAtIndex:1] stringValue]]) {
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
					if ([[[targetDigitField getTextField] text] isEqualToString:[[resultArray objectAtIndex:0] stringValue]]) {
						ret	= 1;
					}
					else if ([[[targetDigitField getTextField] text] isEqualToString:@""]) {
						ret = 2;
					}
				}
			}
		}
	}
	
	return ret;
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

- (void) clearTargetDigitFields {
	[targetDigitField getTextField].text = @"";
	if ([targetDigitField getCarryTargetDigitField] != NULL) {
		[[targetDigitField getCarryTargetDigitField] getTextField].text = @"";
	}
}

@end
