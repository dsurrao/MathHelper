//
//  CarryStep.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"
#import "DigitField.h"

@interface CarryStep : Step {
	DigitField *carryDF;
	DigitField *targetDF;
	int stepNumber;
}

- (CarryStep *) initWithOperands: (DigitField *) iCarryDF : (DigitField *) iTargetDF : (int) iStepNumber;
- (DigitField *) getCarryDF;
- (int) getStepNumber;

@end
