//
//  Hints.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Hints : NSObject {

}

- (NSString	*) getDivisionHint:(int) iDividend: (int) iDivisor;
- (NSString *) getMultiplicationHint: (int) iMultiplicand1: (int) iMultiplicand2;
- (NSString *) getSubtractionHint:(int) iSubtractFrom: (int) iSubtrahend;
- (NSString *) getAdditionHint:(int) iAmount1: (int) iAmount2;

@end
