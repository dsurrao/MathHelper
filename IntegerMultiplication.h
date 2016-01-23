//
//  IntegerMultiplication.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//	Used for division by DivisionViewController
//	as distinct from the class MultiplicationOperation used for multiplication by MultiplicationViewController

#import <Foundation/Foundation.h>
#import "Operation.h"
#import "Utilities.h"

@interface IntegerMultiplication : Operation

@property int leftOperand;
@property int leftOperandDecimalPosition;
@property int rightOperand;
@property(nonatomic, strong) NSMutableArray *targetDigitFieldArray;
@property(nonatomic, strong) Utilities *utils;

- (IntegerMultiplication *) initWithOperands :(int)iLeftOperand :(int)iLeftOperandDecimalPosition :(int)iRightOperand :(NSMutableArray *) iTargetDigitFieldArray;
- (int) compute;

@end
