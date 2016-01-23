//
//  MultiplicationStep.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "MultiplicationStep.h"
#import "NumberParser.h"

@implementation MultiplicationStep

- (MultiplicationStep *) initWithOperands: 
	(DigitField *) iLeftOperandDF :
	(DigitField *) iRightOperandDF :
	(NSMutableArray *) iTargetDFArray :
	(int) iStepNumber{
	leftOperandDF = iLeftOperandDF;
	rightOperandDF = iRightOperandDF;
	targetDFArray = iTargetDFArray;
	stepNumber = iStepNumber;
	return self;
}

- (int) getStepNumber {
	return stepNumber;
}

- (NSMutableArray *) doStep:(bool) silentFlag {
	int m1 = [[leftOperandDF getCharValue] intValue];
	int m2 = [[rightOperandDF getCharValue] intValue];
	int result = m1 * m2;
	NumberParser *numParser = [[NumberParser alloc] init];
	NSMutableArray *resultArray = [numParser parseInteger:result];
	int j;
	for (int i = 0; i < [resultArray count]; i++) {
		if ([resultArray count] == 1) {
			j = (int)[targetDFArray count] - 1;
		}
		else {
			j = (int)[resultArray count] - 1 - i;
		}
		[[targetDFArray objectAtIndex:j] setCharValue:[[resultArray objectAtIndex:i] stringValue]];
		if (!silentFlag) {
			[[targetDFArray objectAtIndex:j] getTextField].text = [[targetDFArray objectAtIndex:j] getCharValue];
		}
	}
	return (targetDFArray);
}

- (NSString *) getHint {
	int m1 = [[[leftOperandDF getTextField] text] intValue];
	int m2 = [[[rightOperandDF getTextField] text] intValue];
	int result = m1 * m2;
	NSString *hintStr = [[[leftOperandDF getTextField] text] stringByAppendingString:@" × "];
	hintStr = [hintStr stringByAppendingString:[[rightOperandDF getTextField] text]];
	hintStr = [hintStr stringByAppendingString:@" = "];
	hintStr = [hintStr stringByAppendingString:[[NSNumber numberWithInt:result] stringValue]];
	return (hintStr);
}

- (DigitField *) getLeftOperandDF {
	return (leftOperandDF);
}

- (bool) checkForCorrectEntry: (UITextField *) iTextField {
	bool retFlag = false;
	for (int i = 0; i < [targetDFArray count]; i++) {
		if ([[targetDFArray objectAtIndex:i] getTextField] == iTextField) {
			[self doStep:true];
			if ([[[targetDFArray objectAtIndex:i] getCharValue] isEqualToString:iTextField.text]) {
				retFlag = true;
				break;
			}
		}
	}
	return retFlag;
}

- (bool) isComplete {
	bool retFlag = true;
	DigitField *digitField;
	for (int i = 0; i < [targetDFArray count]; i++) {
		digitField = [targetDFArray objectAtIndex:i];
		[self doStep:true];
		if (![[digitField getCharValue] isEqualToString:[digitField getTextField].text]) {
			retFlag = false;
			break;
		}
	}
	return retFlag;
}

- (bool) targetContainsTextField:(UITextField *) iTextField {
	bool containsFlag = false;
	for (int i = 0; i < [targetDFArray count]; i++) {
		if ([[targetDFArray objectAtIndex:i] getTextField] == iTextField) {
			containsFlag = true;
			break;
		}
	}
	return (containsFlag);
}

- (void) undo {
	for (int i = 0; i < [targetDFArray count]; i++) {
		[[targetDFArray objectAtIndex:i] getTextField].text = @"";
	}
}

@end
