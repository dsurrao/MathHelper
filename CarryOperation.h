//
//  CarryOperation.h
//  MathHelp
//
//  Created by Dominic Surrao on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"
#import "DigitField.h"
#import "Utilities.h"

@interface CarryOperation : Operation
	@property(nonatomic, strong) DigitField *leastPopulatedDigitField;
    @property(nonatomic, strong) Utilities *utils;
    @property(nonatomic, strong) NSNumberFormatter *numberFormatter;
    - (CarryOperation *) initWithOperands: (DigitField *) iLeastPopulatedDigitField;
@end
