//
//  MultiplicationStep.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"
#import "DigitField.h"


@interface MultiplicationStep : Step {
	DigitField *leftOperandDF;
	DigitField *rightOperandDF;
	NSMutableArray *targetDFArray;
	int stepNumber;
}

- (MultiplicationStep *) initWithOperands :
	(DigitField *) iLeftOperandDF :
	(DigitField *) iRightOperandDF :
	(NSMutableArray *) iTargetDFArray :
	(int) iStepNumber;

- (DigitField *) getLeftOperandDF;

- (int) getStepNumber;

- (bool) isComplete;

@end
