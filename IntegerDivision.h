//
//  IntegerDivision.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"
#import "DigitField.h"

@interface IntegerDivision : Operation {
	int leftOperand;
	int rightOperand;
	DigitField *targetDigitField;	
}

- (IntegerDivision *) initWithOperands: (int) iLeftOperand :(int) iRightOperand :(DigitField *) iTargetDigitField;
- (NSDecimalNumber *) getResultWholeNumber;
- (NSNumber *) getRemainderNumber;

@end
