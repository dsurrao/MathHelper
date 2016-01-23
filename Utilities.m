//
//  Utilities.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import "NumberParser.h"
#import "DigitField.h"

@implementation Utilities

-(void) populateTarget: 
	(NSMutableArray *) iTargetDigitFieldArray :(int) iValue :(int) iValueDecimalPosition {
	
	DigitField *digitField;
	
	/* loop through each digit field and populate it as appropriate */
	for (int i = 0; i < [iTargetDigitFieldArray count]; i++) {
		digitField = [iTargetDigitFieldArray objectAtIndex:i];
		digitField.getTextField.text = 
			[self getNumberStringAtDecimalPosition: iValue: iValueDecimalPosition: [digitField getDecimalPosition]];
	}
}

-(void) enableTargetDigitFields: 
	(NSMutableArray *) iTargetDigitFieldArray :(int) iValue :(int) iValueDecimalPosition {
	
	DigitField *digitField;
	
	/* loop through each digit field and enable it as appropriate */
	for (int i = 0; i < [iTargetDigitFieldArray count]; i++) {
		digitField = [iTargetDigitFieldArray objectAtIndex:i];
		if (![[self getNumberStringAtDecimalPosition: iValue: iValueDecimalPosition: [digitField getDecimalPosition]] 
			 isEqualToString:@""]) {
			[digitField enable];
		}
	}
}

-(bool) validateTarget: 
	(NSMutableArray *) iTargetDigitFieldArray :(int) iValue :(int) iValueDecimalPosition {
	bool validateRet = true;
	DigitField *digitField;
	NSString *numberStr;
	
	/* loop through each digit field and populate it as appropriate */
	for (int i = 0; i < [iTargetDigitFieldArray count]; i++) {
		digitField = [iTargetDigitFieldArray objectAtIndex:i];
		numberStr = [self getNumberStringAtDecimalPosition: iValue: iValueDecimalPosition: [digitField getDecimalPosition]];
		if (![digitField.getTextField.text isEqualToString:numberStr]) {
			validateRet = false;
			break;
		}
	}
	
	return validateRet;
}

-(bool) validateTargetDigitField:
	(DigitField *) iTargetDigitField :
	(int) iValue :
	(int) iValueDecimalPosition {
	
	bool validateRet = false;
	NSString *numberStr = [self getNumberStringAtDecimalPosition: iValue: iValueDecimalPosition: 
						   [iTargetDigitField getDecimalPosition]];	
	if ([iTargetDigitField.getTextField.text isEqualToString:numberStr]) {
		validateRet = true;
	}
	
	return validateRet;
}

- (DigitField *) getLeastPopulatedDigitField: (NSMutableArray *) digitFieldArray {
	DigitField *digitField = nil;
	for (int i = 0; i < [digitFieldArray count]; i++) {
		digitField = [digitFieldArray objectAtIndex:i];
		if (![[[digitField getTextField] text] isEqualToString:@""]) {
			if (![digitField isEnabled]) {
				break;
			}
		}
	}
	return digitField;
}


- (void) enableDigitFields:(NSMutableArray *) iDigitFieldArray {
	DigitField *digitField;
	for (int i = 0; i < [iDigitFieldArray count]; i++) {
		digitField = [iDigitFieldArray objectAtIndex:i];
		[digitField enable];
	}
}

- (void) disableDigitFields:(NSMutableArray *) iDigitFieldArray {
	DigitField *digitField;
	for (int i = 0; i < [iDigitFieldArray count]; i++) {
		digitField = [iDigitFieldArray objectAtIndex:i];
		[digitField disable];
	}
}

- (void) clearDigitFields:(NSMutableArray *) iDigitFieldArray {
	DigitField *digitField;
	for (int i = 0; i < [iDigitFieldArray count]; i++) {
		digitField = [iDigitFieldArray objectAtIndex:i];
		digitField.getTextField.text = @"";
	}
}

/*
	returns the digit at position 'iDecimalPosition' in 'iValue' if there is one;
	returns empty string otherwise
	e.g., 
		if iValue = 5, iValueDecimalPosition = 10, iDecimalPosition = 10, return '5'
		if iValue = 5, iValueDecimalPosition = 10, iDecimalPosition = 100, return ''
 */
-(NSString *) getNumberStringAtDecimalPosition: 
	(int) iValue :
	(int) iValueDecimalPosition : 
	(int) iDigitFieldDecimalPosition  {
	
	NSString *retStr = @"";
	
	/* left pad array with minus one */
	NumberParser *numParser = [[NumberParser alloc] init];
	NSMutableArray *valueArray = [numParser parseInteger:iValue];
	NSNumber *minusOne = [[NSNumber alloc] initWithInt:-1];
	for (int i = 1; i < iValueDecimalPosition; i = i * 10) {
		[valueArray insertObject:minusOne atIndex:0];
	}
	
	if (iDigitFieldDecimalPosition == 1) {
		if ([valueArray count] > 0) {
			if ([[valueArray objectAtIndex:0] intValue] != -1) {
				retStr = [[valueArray objectAtIndex:0] stringValue];
			}
		}
	}
	else if (iDigitFieldDecimalPosition == 10) {
		if ([valueArray count] > 1) {
			if ([[valueArray objectAtIndex:1] intValue] != -1) {
				retStr = [[valueArray objectAtIndex:1] stringValue];
			}
		}
	}
	else if (iDigitFieldDecimalPosition == 100) {
		if ([valueArray count] > 2) {
			if ([[valueArray objectAtIndex:2] intValue] != -1) {
				retStr = [[valueArray objectAtIndex:2] stringValue];
			}
		}
	}
	
	return retStr;
}

@end
