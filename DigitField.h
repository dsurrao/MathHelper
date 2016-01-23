//
//  DigitField.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  
//	Modifications
//	5/29/2011 Added charValue property, displayCharValue method
//

#import <Foundation/Foundation.h>


@interface DigitField : NSObject {
	UITextField *textField;				/* the text field holding the digit */
	DigitField *carryDigitField;		/* the field from which to get a carry digit */
	DigitField *carryTargetDigitField;	/* the field to which the carry digit is copied */
	int decimalPosition;				/* indicates whether this is ones, tens or hundreds */
	NSString *charValue;				/* new field to store result if in silent mode */
}

-(DigitField *) initWithTextField: (UITextField *)iTextField :(int)iDecimalPosition;
-(UITextField *) getTextField;
-(DigitField *) getCarryDigitField;
-(DigitField *) getCarryTargetDigitField;
-(int) getDecimalPosition;
-(void) setCarryDigitField: (DigitField *) iCarryDigitField;
-(void) setCarryTargetDigitField: (DigitField *) iCarryTargetDigitField;
-(void) enable;
-(void) disable;
-(bool) isEnabled;
-(NSString *) getCharValue;
-(void) setCharValue: (NSString *) iCharValue;
-(void) displayCharValue;
@end
