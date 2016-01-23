//
//  DivisionStep.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "DivisionStep.h"


@implementation DivisionStep

- (DivisionStep *) initWithOperands: (DigitField *) iRightOperandDF :(NSMutableArray *) iLeftOperandDFArray :
	(DigitField *) iTargetDF {
	rightOperandDF = iRightOperandDF;
	leftOperandDFArray = iLeftOperandDFArray;
	targetDF = iTargetDF;
	return self;
}

- (NSMutableArray *) getLeftOperandDFArray {
	return (leftOperandDFArray);
}

- (DigitField *) getTargetDF {
	return (targetDF);
}

- (NSMutableArray *) doStep:(bool) silentFlag {
	int divisor = [[rightOperandDF getCharValue] intValue];
	NSString *dividendStr = @"";
	for (int i = 0; i < [leftOperandDFArray count]; i++) {
		dividendStr = [dividendStr stringByAppendingString:
					   [[leftOperandDFArray objectAtIndex:i] getCharValue]];
	}
	int dividend = [dividendStr intValue];
	NSDecimalNumber *resultDecimalNumber = [self getResultWholeNumber: dividend :divisor];
	
	[targetDF setCharValue:[resultDecimalNumber stringValue]];	
	if (!silentFlag) {
		[targetDF getTextField].text = [targetDF getCharValue];
	}
		
	return ([NSMutableArray arrayWithObject:targetDF]);
}

- (NSString *) getHint {
	NSString *divisorStr = [[rightOperandDF getTextField] text];
	NSString *dividendStr = @"";
	for (int i = 0; i < [leftOperandDFArray count]; i++) {
		dividendStr = [dividendStr stringByAppendingString
					   :[[[leftOperandDFArray objectAtIndex:i] getTextField] text]];
	}
	int divisor = [divisorStr intValue];
	int dividend = [dividendStr intValue];
	NSString *resultStr = @"";
	NSDecimalNumber *resultDecimalNumber = [self getResultWholeNumber: dividend :divisor];
	NSNumber *remainderNumber = [self getRemainderNumber: dividend :divisor];
	NSString *resultWholeNumberStr = [resultDecimalNumber stringValue];	
	NSString *resultRemainderStr = [remainderNumber stringValue];
	if ([resultRemainderStr isEqualToString:@"0"]) {
		resultStr = resultWholeNumberStr;
	}
	else {
		resultStr = [[resultWholeNumberStr stringByAppendingString: @" remainder "] stringByAppendingString:resultRemainderStr];
	}
	NSString *hintStr = [dividendStr stringByAppendingString:@" ÷ "];
	hintStr = [hintStr stringByAppendingString:divisorStr];
	hintStr = [hintStr stringByAppendingString:@" = "];
	hintStr = [hintStr stringByAppendingString:resultStr];
		
	return (hintStr);
}

- (NSDecimalNumber *) getResultWholeNumber: (int) iDividend : (int) iDivisor {
	NSDecimalNumberHandler* roundingBehavior = 
	[[NSDecimalNumberHandler alloc] 
	 initWithRoundingMode:NSRoundDown scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
	float result = iDividend/iDivisor;
	NSDecimalNumber *resultDec = [[NSDecimalNumber alloc] initWithFloat:result];
	NSDecimalNumber *roundedResultDec = [resultDec decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
	
	/* release objects */
	
	return roundedResultDec;
}

- (NSNumber *) getRemainderNumber: (int) iDividend : (int) iDivisor {
	int remainder = iDividend - ([[self getResultWholeNumber: iDividend: iDivisor] intValue] * iDivisor);
	return ([NSNumber numberWithInt:remainder]);
}

- (bool) checkForCorrectEntry: (UITextField *) iTextField {
	bool retFlag = false;
	if ([targetDF getTextField] == iTextField) {
		[self doStep:true];
		if ([[targetDF getCharValue] isEqualToString:iTextField.text]) {
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
