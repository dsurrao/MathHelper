//
//  MultiplicationOperation.h
//  MathHelp
//
//  Created by Dominic Surrao on 1/26/11.
//  Copyright 2011 MathHelp. All rights reserved.
//
//  Used for multiplication by MultiplicaionViewController
//	as distinct from the class IntegerMultiplication used for division by DivisionViewController


#import <Foundation/Foundation.h>
#import "Operation.h"
#import "DigitField.h"

@interface MultiplicationOperation : Operation {
	DigitField *leftOperandDigitField;		// digit from the second multiplicand
	DigitField *rightOperandDigitField;		// digit from the first multiplicand
	DigitField *targetDigitField;
	int carriedOverVal;
}

- (MultiplicationOperation *) initWithOperands: 
	(DigitField *) iLeftOperandDigitField :
	(DigitField *) iRightOperandDigitField :
	(DigitField *) iTargetDigitField :
	(int) iCarriedOverVal;

- (int) compute;

@end
