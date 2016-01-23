//
//  SubtractionStep.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"
#import "DigitField.h"

@interface SubtractionStep : Step {
	NSMutableArray *leftOperandDFArray;
	NSMutableArray *rightOperandDFArray;
	DigitField *targetDF;
}

- (SubtractionStep *) initWithOperands : (NSMutableArray *) iLeftOperandDFArray :
	(NSMutableArray *) iRightOperandDFArray : (DigitField *) iTargetDF;

- (NSMutableArray *) getLeftOperandDFArray;
- (NSMutableArray *) getRightOperandDFArray;

@end
