//
//  DivisionStep.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"
#import "DigitField.h"

@interface DivisionStep : Step {
	DigitField *rightOperandDF;
	NSMutableArray *leftOperandDFArray;
	DigitField *targetDF;
}

- (DivisionStep *) initWithOperands :
	(DigitField *) iRightOperandDF :
	(NSMutableArray *) iLeftOperandDFArray : 
	(DigitField *) iTargetDF;

- (NSMutableArray *) getLeftOperandDFArray;

- (DigitField *) getTargetDF;

@end
