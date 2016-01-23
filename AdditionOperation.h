//
//  AdditionOperation.h
//  MathHelp
//
//  Created by Dominic Surrao on 2/5/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"
#import "DigitField.h"

@interface AdditionOperation : Operation {
	DigitField *leftOperandDigitField;		// digit from first product
	DigitField *rightOperandDigitField;		// digit from second product
	DigitField *targetDigitField;
	int carriedOverVal;
}

- (AdditionOperation *) initWithOperands: 
	(DigitField *) iLeftOperandDigitField :
	(DigitField *) iRightOperandDigitField :
	(DigitField *) iTargetDigitField :
	(int) iCarriedOverVal;

- (int) compute;

@end
