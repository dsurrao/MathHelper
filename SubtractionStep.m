//
//  SubtractionStep.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "SubtractionStep.h"
#import "Utilities.h"

@implementation SubtractionStep

- (SubtractionStep *) initWithOperands: (NSMutableArray *) iLeftOperandDFArray :(NSMutableArray *) iRightOperandDFArray :(DigitField *) iTargetDF {
	leftOperandDFArray = iLeftOperandDFArray;
	rightOperandDFArray = iRightOperandDFArray;
	targetDF = iTargetDF;
	return self;
}

- (NSMutableArray *) doStep:(bool) silentFlag {
	int i;
	NSString *leftOperandStr = @"";
	NSString *rightOperandStr = @"";
	for (i = 0; i < [leftOperandDFArray count]; i++) {
		leftOperandStr = [leftOperandStr stringByAppendingString:
						  [[leftOperandDFArray objectAtIndex:i] getCharValue]];
	}
	for (i = 0; i < [rightOperandDFArray count]; i++) {
		rightOperandStr = [rightOperandStr stringByAppendingString:
						  [[rightOperandDFArray objectAtIndex:i] getCharValue]];
	}
	int result = [leftOperandStr intValue] - [rightOperandStr intValue];
	[targetDF setCharValue:[[NSNumber numberWithInt:result] stringValue]];
	if (!silentFlag) {
		[targetDF getTextField].text = [targetDF getCharValue];
	}
	
	return ([NSMutableArray arrayWithObject:targetDF]);
}

- (NSString *) getHint {
	int i;
	NSString *leftOperandStr = @"";
	NSString *rightOperandStr = @"";
	for (i = 0; i < [leftOperandDFArray count]; i++) {
		leftOperandStr = [leftOperandStr stringByAppendingString:
						  [[leftOperandDFArray objectAtIndex:i] getTextField].text];
	}
	for (i = 0; i < [rightOperandDFArray count]; i++) {
		rightOperandStr = [rightOperandStr stringByAppendingString:
						   [[rightOperandDFArray objectAtIndex:i] getTextField].text];
	}
	int result = [leftOperandStr intValue] - [rightOperandStr intValue];
	
	NSString *hintStr = [leftOperandStr stringByAppendingString:@" - "];
	hintStr = [hintStr stringByAppendingString:rightOperandStr];
	hintStr = [hintStr stringByAppendingString:@" = "];
	hintStr = [hintStr stringByAppendingString:[[NSNumber numberWithInt:result] stringValue]];
	return (hintStr);
}

- (NSMutableArray *) getLeftOperandDFArray {
	return (leftOperandDFArray);
}

- (NSMutableArray *) getRightOperandDFArray {
	return (rightOperandDFArray);
}

- (bool) checkForCorrectEntry: (UITextField *) iTextField {
	bool retFlag = false;
	if ([targetDF getTextField] == iTextField) {
		[self doStep:true];
		if ([[targetDF getCharValue] isEqualToString:[iTextField text]]) {
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
