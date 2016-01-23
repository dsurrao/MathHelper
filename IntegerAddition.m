//
//  IntegerAddition.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntegerAddition.h"


@implementation IntegerAddition

- (IntegerAddition *) initWithOperands: (int) iLeftOperand: (int) iRightOperand: (UITextField *) iTargetTextField {
	leftOperand = iLeftOperand;
	rightOperand = iRightOperand;
	targetTextField = iTargetTextField;
	return self;
}

- (int) execute {
	int result = leftOperand + rightOperand;
	targetTextField.text = [[[NSNumber alloc] initWithInt:result] stringValue];
	return (result);
}


- (NSString *) getHint {
	return @"addition hint";
}

@end
