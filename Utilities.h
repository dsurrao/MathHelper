//
//  Utilities.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DigitField.h"

@interface Utilities : NSObject {

}

-(void) populateTarget: 
	(NSMutableArray *) iTargetDigitFieldArray :(int) iValue :(int) iValueDecimalPosition;

-(void) enableTargetDigitFields: 
	(NSMutableArray *) iTargetDigitFieldArray :(int) iValue :(int) iValueDecimalPosition;

-(bool) validateTarget:
	(NSMutableArray *) iTargetDigitFieldArray :(int) iValue :(int) iValueDecimalPosition;

-(bool) validateTargetDigitField:
	(DigitField *) iTargetDigitField :(int) iValue :(int) iValueDecimalPosition;

-(DigitField *) getLeastPopulatedDigitField: (NSMutableArray *) iTargetDigitFieldArray;

- (void) enableDigitFields:(NSMutableArray *) iDigitFieldArray;

- (void) disableDigitFields:(NSMutableArray *) iDigitFieldArray;

- (void) clearDigitFields:(NSMutableArray *) iDigitFieldArray;

- (NSString *) getNumberStringAtDecimalPosition :(int) iValue :(int) iValueDecimalPosition :(int) iDigitFieldDecimalPosition;


@end
