//
//  DigitField.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//	Modifications
//	5/29/2011 Added charValue property, displayCharValue method
//

#import "DigitField.h"

@implementation DigitField

-(DigitField *) initWithTextField:(UITextField *) iTextField : (int) iDecimalPosition {
	textField = iTextField;	
	decimalPosition = iDecimalPosition;
	[self setCharValue:[iTextField text]];
	return self;
}

-(UITextField *) getTextField {
	return textField;
}

-(DigitField *) getCarryDigitField {
	return carryDigitField;
}

-(int) getDecimalPosition {
	return decimalPosition;
}

-(void) setCarryDigitField:(DigitField *)iCarryDigitField {
	carryDigitField = iCarryDigitField;
}

-(DigitField *) getCarryTargetDigitField {
	return carryTargetDigitField;
}

-(void) setCarryTargetDigitField:(DigitField *)iCarryTargetDigitField {
	carryTargetDigitField = iCarryTargetDigitField;
}

-(NSString *) getCharValue {
	return charValue;
}

-(void) setCharValue:(NSString *)iCharValue {
	 /* release any previous value */
	charValue = iCharValue;	
}

-(void) displayCharValue {
	textField.text = charValue;
}

/*
 colors from
 http : //www.colourlovers.com/web/blog/2008/04/22/all-120-crayon-names-color-codes-and-fun-facts
 */
-(void) enable {
	textField.userInteractionEnabled = YES;
	textField.backgroundColor = [UIColor whiteColor];
	textField.borderStyle = UITextBorderStyleBezel;
}

-(void) disable {
	textField.userInteractionEnabled = NO;
	textField.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:0.2];
	textField.borderStyle = UITextBorderStyleLine;
}

-(bool) isEnabled {
	if (textField.userInteractionEnabled == YES) {
		return (true);
	}
	else {
		return (false);
	}
}


@end
