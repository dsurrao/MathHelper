//
//  MultiplicationViewController.m
//  MathHelp
//
//  Created by Dominic Surrao on 1/29/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "MultiplicationViewController.h"
#import "NumberParser.h"
#import "MultiplicationOperation.h"
#import "AdditionOperation.h"

@implementation MultiplicationViewController

@synthesize multiplicand1;
@synthesize multiplicand2;
@synthesize multiplicand1Ones;
@synthesize multiplicand1Tens;
@synthesize multiplicand1Hundreds;
@synthesize multiplicand2Ones;
@synthesize multiplicand2Tens;
@synthesize product1Ones;
@synthesize product1Tens;
@synthesize product1Hundreds;
@synthesize product1Thousands;
@synthesize product2Tens;
@synthesize product2Hundreds;
@synthesize product2Thousands;
@synthesize product2TenThousands;
@synthesize resultOnes;
@synthesize resultTens;
@synthesize resultHundreds;
@synthesize resultThousands;
@synthesize resultTenThousands;
@synthesize carryTens;
@synthesize carryHundreds;
@synthesize carryThousands;
@synthesize multiplicationArray;
@synthesize additionArray;
@synthesize carriedOverValArray;
@synthesize multiplicand1DigitArray;
@synthesize multiplicand2DigitArray;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureDigitFields];
	
	_currentMultiplicationArrayIndex = 0;
	_currentAdditionArrayIndex = -1;
	/* value of -1 indicates that the controller is still processing multiplications */
	carriedOverValArray = [[NSMutableArray alloc] init];
	[carriedOverValArray addObject: [NSNumber numberWithInt:0]];
    
	NumberParser *numParser = [[NumberParser alloc] init];
	self.multiplicand1DigitArray = [numParser parseInteger:multiplicand1];
	self.multiplicand2DigitArray = [numParser parseInteger:multiplicand2];
	for (int i = 0; i < [multiplicand1DigitArray count]; i++) {
		if (i == 0) {
			[_multiplicand1OnesDigitField getTextField].text 
				= [[multiplicand1DigitArray objectAtIndex:i] stringValue];
		}
		else if (i == 1) {
			[_multiplicand1TensDigitField getTextField].text 
				= [[multiplicand1DigitArray objectAtIndex:i] stringValue];
			[_product1OnesDigitField setCarryTargetDigitField:NULL];
		}
		else if (i == 2) {
			[_multiplicand1HundredsDigitField getTextField].text 
				= [[multiplicand1DigitArray objectAtIndex:i] stringValue];
			[_product1TensDigitField setCarryTargetDigitField:NULL];
		}
	}
	for (int i = 0; i < [multiplicand2DigitArray count]; i++) {
		if (i == 0) {
			[_multiplicand2OnesDigitField getTextField].text 
				= [[multiplicand2DigitArray objectAtIndex:i] stringValue];
		}
		else if (i == 1) {
			[_multiplicand2TensDigitField getTextField].text 
				= [[multiplicand2DigitArray objectAtIndex:i] stringValue];
			if ([multiplicand1DigitArray count] > 1) {
				[_product2TensDigitField setCarryTargetDigitField:NULL];
			}
			if ([multiplicand1DigitArray count] > 2) {
				[_product2HundredsDigitField setCarryTargetDigitField:NULL];
			}
		}
	}
	
	/* examine the result and configure the result digit fields accordingly */
	int product1 = multiplicand1 * [[[self multiplicand2DigitArray] objectAtIndex:0] intValue];
	int product2 = 0;
	if ([multiplicand2DigitArray count] > 1) {
		product2 = multiplicand1 * [[[self multiplicand2DigitArray] objectAtIndex:1] intValue];
	}
	NSMutableArray *product1Array = [numParser parseInteger:product1];
	if ([product1Array count] > 1) {
		[_resultOnesDigitField setCarryTargetDigitField:NULL];
	}
	if ([product1Array count] > 2) {
		[_resultTensDigitField setCarryTargetDigitField:NULL];
	}
	if ([product1Array count] > 3) {
		[_resultHundredsDigitField setCarryTargetDigitField:NULL];
	}
	if (product2 != 0) {
		NSMutableArray *product2Array = [numParser parseInteger:product2];
		if ([product2Array count] > 0) {
			[_resultOnesDigitField setCarryTargetDigitField:NULL];
		}
		if ([product2Array count] > 1) {
			[_resultTensDigitField setCarryTargetDigitField:NULL];
		}
		if ([product2Array count] > 2) {
			[_resultHundredsDigitField setCarryTargetDigitField:NULL];
		}
		if ([product2Array count] > 3) {
			[_resultThousandsDigitField setCarryTargetDigitField:NULL];
		}
	}
    
	[self disableAllDigitFields];
	if ([self getNextOp] != NULL) {
		[[self getNextOp] enableTargetDigitFields];
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (bool)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/* Ensures that a maximum of 1 digit is entered in a text field */
- (bool)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if ([string length] == 1) {
		textField.text = string;
		[textField resignFirstResponder];
	}
	return !([newString length] > 1);	
}

/*
 When the user hits return, check if the correct entry has been made in the text field.
 */
- (bool)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (bool)textFieldDidBeginEditing:(UITextField *)textField {
    return YES;
}

- (bool)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 1) {
        [self checkForCorrectEntry:textField];
    }
	return YES;
}


- (void) configureDigitFields {
	/* initialize digit fields */
	_multiplicand1OnesDigitField = [[DigitField alloc] initWithTextField:multiplicand1Ones:1];
	_multiplicand1TensDigitField = [[DigitField alloc] initWithTextField:multiplicand1Tens:10];
	_multiplicand1HundredsDigitField = [[DigitField alloc] initWithTextField:multiplicand1Hundreds:100];
	_multiplicand2OnesDigitField = [[DigitField alloc] initWithTextField:multiplicand2Ones:1];
	_multiplicand2TensDigitField = [[DigitField alloc] initWithTextField:multiplicand2Tens:10];	
	_product1OnesDigitField = [[DigitField alloc] initWithTextField:product1Ones:1];	
	_product1TensDigitField = [[DigitField alloc] initWithTextField:product1Tens:10];	
	_product1HundredsDigitField = [[DigitField alloc] initWithTextField:product1Hundreds:100];	
	_product1ThousandsDigitField = [[DigitField alloc] initWithTextField:product1Thousands:100];
	_product2TensDigitField = [[DigitField alloc] initWithTextField:product2Tens:10];	
	_product2HundredsDigitField = [[DigitField alloc] initWithTextField:product2Hundreds:100];
	_product2ThousandsDigitField = [[DigitField alloc] initWithTextField:product2Thousands:1000];
	_product2TenThousandsDigitField = [[DigitField alloc] initWithTextField:product2TenThousands:10000];
	_resultOnesDigitField = [[DigitField alloc] initWithTextField:resultOnes:1];
	_resultTensDigitField = [[DigitField alloc] initWithTextField:resultTens:10];
	_resultHundredsDigitField = [[DigitField alloc] initWithTextField:resultHundreds:100];
	_resultThousandsDigitField = [[DigitField alloc] initWithTextField:resultThousands:1000];
	_resultTenThousandsDigitField = [[DigitField alloc] initWithTextField:resultTenThousands:10000];
	_carryTensDigitField = [[DigitField alloc] initWithTextField:carryTens:10];
	_carryHundredsDigitField = [[DigitField alloc] initWithTextField:carryHundreds:100];
	_carryThousandsDigitField = [[DigitField alloc] initWithTextField:carryThousands:1000];
	
	/* configure relationships between digit fields */
	[_product1OnesDigitField setCarryTargetDigitField: _product1TensDigitField];
	[_product1TensDigitField	setCarryTargetDigitField:_product1HundredsDigitField];
	[_product1HundredsDigitField setCarryTargetDigitField:_product1ThousandsDigitField];
	[_product2TensDigitField setCarryTargetDigitField:_product2HundredsDigitField];
	[_product2HundredsDigitField setCarryTargetDigitField:_product2ThousandsDigitField];
	[_product2ThousandsDigitField setCarryTargetDigitField:_product2TenThousandsDigitField];
	[_resultOnesDigitField setCarryTargetDigitField:_resultTensDigitField];
	[_resultTensDigitField setCarryTargetDigitField:_resultHundredsDigitField];
	[_resultHundredsDigitField setCarryTargetDigitField:_resultThousandsDigitField];
	[_resultThousandsDigitField setCarryTargetDigitField:_resultTenThousandsDigitField];

	/*	configure sequence of multiplications as an array of arrays 
		for each array, 1st element is left operand, 2nd is right operand, 3rd is target
	 */
	self.multiplicationArray = 
		[NSMutableArray arrayWithObjects:
		 [NSMutableArray arrayWithObjects:_multiplicand2OnesDigitField, _multiplicand1OnesDigitField, _product1OnesDigitField, nil],
		 [NSMutableArray arrayWithObjects:_multiplicand2OnesDigitField, _multiplicand1TensDigitField, _product1TensDigitField, nil],
		 [NSMutableArray arrayWithObjects:_multiplicand2OnesDigitField, _multiplicand1HundredsDigitField, _product1HundredsDigitField, nil],
		 [NSMutableArray arrayWithObjects:_multiplicand2TensDigitField, _multiplicand1OnesDigitField, _product2TensDigitField, nil],
		 [NSMutableArray arrayWithObjects:_multiplicand2TensDigitField, _multiplicand1TensDigitField, _product2HundredsDigitField, nil],
		 [NSMutableArray arrayWithObjects:_multiplicand2TensDigitField, _multiplicand1HundredsDigitField, _product2ThousandsDigitField, nil],
		 nil];
	
	/*	configure sequence of additions of the two products, also as an array of arrays 
		for each array, 1st element is left operand, 2nd is right operand, 3rd is target
	 */
	NSNull *nullValue = [NSNull null];
	self.additionArray =
		[NSMutableArray arrayWithObjects:
		 [NSMutableArray arrayWithObjects:_product1OnesDigitField, nullValue, _resultOnesDigitField, nil],
		 [NSMutableArray arrayWithObjects:_product1TensDigitField, _product2TensDigitField, _resultTensDigitField, nil],
		 [NSMutableArray arrayWithObjects:_product1HundredsDigitField, _product2HundredsDigitField, _resultHundredsDigitField, nil],
		 [NSMutableArray arrayWithObjects:_product1ThousandsDigitField, _product2ThousandsDigitField, _resultThousandsDigitField, nil],
		 [NSMutableArray arrayWithObjects:nullValue, _product2TenThousandsDigitField, _resultTenThousandsDigitField, nil],
		 nil];
		 
}

- (IBAction)doNextStep:(id)sender {
	DigitField *leftOperandDigitField;
	DigitField *rightOperandDigitField;
	DigitField *targetDigitField;
	bool endMultiplication = true;
	bool populateCarriedOverVal = false;
	int carriedOverVal = 0;
    
	Operation *op = [self getNextOp];
	if (op != NULL) {
		[self clearCarryDigitFields];
		
		if ([op isKindOfClass:[MultiplicationOperation class]]) {
			carriedOverVal = [op execute];
			[carriedOverValArray addObject:[NSNumber numberWithInt:carriedOverVal]];
			[self populateCarryDigitFields:carriedOverVal];
			_currentMultiplicationArrayIndex++;
			int nextMultiplicationArrayIndex = _currentMultiplicationArrayIndex;
				
			/* peek to see if there are any more multiplications */
			while (nextMultiplicationArrayIndex < [multiplicationArray count]) {
				leftOperandDigitField = 
					[[multiplicationArray objectAtIndex:nextMultiplicationArrayIndex] objectAtIndex:0];
				rightOperandDigitField = 
					[[multiplicationArray objectAtIndex:nextMultiplicationArrayIndex] objectAtIndex:1];				
				if (![[[leftOperandDigitField getTextField] text] isEqualToString:@""]
					&& ![[[rightOperandDigitField getTextField] text] isEqualToString:@""]) {
					endMultiplication = false;
					break;
				}
				else if	(nextMultiplicationArrayIndex == _currentMultiplicationArrayIndex) {
					populateCarriedOverVal = true;
				}
				nextMultiplicationArrayIndex++;
			}
			if (populateCarriedOverVal) {
				/* if there is still a carry over val, populate appropriate digit field with it */
				if ((carriedOverVal > 0) && (_currentMultiplicationArrayIndex < [multiplicationArray count])) {
					targetDigitField = [[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:2];
					[targetDigitField getTextField].text = [[NSNumber numberWithInt:carriedOverVal] stringValue];
				}
			}
			if (endMultiplication) {				/* multiplications complete, next additions */
				_currentAdditionArrayIndex++;		
				
				/* if the 2nd multiplicand has one digit, the problem is complete
				 so do all empty additions automatically */
				if (multiplicand2 < 10) {
					while ([self getNextOp] != NULL) {
						[self doNextStep:NULL];
					}
				}
			}
		}
		else if ([op isKindOfClass:[AdditionOperation class]]) {	/* if addition */
			carriedOverVal = [op execute];
			[carriedOverValArray addObject:[NSNumber numberWithInt:carriedOverVal]];
			_currentAdditionArrayIndex++;
			
			/* peek if there are any more additions */
			int endAddition = true;
			int nextAdditionArrayIndex = _currentAdditionArrayIndex;
			while (nextAdditionArrayIndex < [additionArray count]) {
				id leftOperand = [[additionArray objectAtIndex:nextAdditionArrayIndex] objectAtIndex:0];
				id rightOperand = [[additionArray objectAtIndex:nextAdditionArrayIndex] objectAtIndex:1];
				leftOperandDigitField = 
					[[additionArray objectAtIndex:nextAdditionArrayIndex] objectAtIndex:0];
				rightOperandDigitField = 
					[[additionArray objectAtIndex:nextAdditionArrayIndex] objectAtIndex:1];				
				if (leftOperand != [NSNull null]) {
					if (![[[leftOperandDigitField getTextField] text] isEqualToString:@""]) {
						endAddition = false;
						break;
					}
				}
				if (rightOperand != [NSNull null]) {
					if (![[[rightOperandDigitField getTextField] text] isEqualToString:@""]) {
						endAddition = false;
						break;
					}
				}
				nextAdditionArrayIndex++;
			}
			if (endAddition) {
				/* if there is still a carry over val, populate appropriate digit field with it */
				if (carriedOverVal > 0) {
					targetDigitField = [[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:2];
					[targetDigitField getTextField].text = [[NSNumber numberWithInt:carriedOverVal] stringValue];
					if ([carriedOverValArray count] > 0) {
						[carriedOverValArray removeLastObject];
					}					
				}
			}
			
		}
		
		[self disableAllDigitFields];
		if ([self getNextOp] != NULL) {
			[[self getNextOp] enableTargetDigitFields];
		}
		else {
            UIAlertController* alert =
            [UIAlertController alertControllerWithTitle:@"Problem solved!"
                                                message:[self getFinalResultMessage]
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            if ([self presentedViewController] == NULL) {
                [self presentViewController:alert animated:YES completion:nil];
            }
		}
	}
}

- (IBAction)undoLastStep:(id)sender {
	DigitField *targetDigitField = NULL;
	DigitField *leftOperandDigitField = NULL;
	DigitField *rightOperandDigitField = NULL;
	MultiplicationOperation *multOp;
	AdditionOperation *addOp;
	
	Operation *nextOp = [self getNextOp];
	if (nextOp != NULL) {
		[nextOp clearTargetDigitFields];
	}
	
	/* find out what the last operation was */
	if (_currentAdditionArrayIndex == -1) {	/* if current op is multiplication */
		if (_currentMultiplicationArrayIndex > 0) {
			
			/* go back to last multiplication performed */
			_currentMultiplicationArrayIndex--;
			while (_currentMultiplicationArrayIndex >= 0) {
				leftOperandDigitField = 
					[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:0];
				rightOperandDigitField = 
					[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:1];
				targetDigitField = 
					[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:2];
				if ([[[targetDigitField getTextField] text] isEqualToString: @""]) {
					_currentMultiplicationArrayIndex--;
				}
				else if (([[[leftOperandDigitField getTextField] text] isEqualToString: @""])
						 || ([[[rightOperandDigitField getTextField] text] isEqualToString: @""])) {
					_currentMultiplicationArrayIndex--;
				}
				else {
					break;
				}

			}
			if (_currentMultiplicationArrayIndex < 0) {	/* nothing has been executed yet */
				_currentMultiplicationArrayIndex = 0;	
			}
			else {
				/* invoke undo */
				multOp = [[MultiplicationOperation alloc] 
					initWithOperands:leftOperandDigitField : rightOperandDigitField : targetDigitField : 0];
				[multOp undo];
				if ([carriedOverValArray count] > 0) {
					[carriedOverValArray removeLastObject];
				}
			}
		}
	}
	else {										/* if current op is addition */
		if (_currentAdditionArrayIndex == 0) {
			/* go back to last multiplication performed */
			_currentAdditionArrayIndex--;
			_currentMultiplicationArrayIndex--;
			while (_currentMultiplicationArrayIndex >= 0) {
				leftOperandDigitField = 
					[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:0];
				rightOperandDigitField = 
					[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:1];
				targetDigitField = 
					[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:2];				
				if ([[[targetDigitField getTextField] text] isEqualToString: @""]) {
					_currentMultiplicationArrayIndex--;
				}
				else if (([[[leftOperandDigitField getTextField] text] isEqualToString: @""])
						 || ([[[rightOperandDigitField getTextField] text] isEqualToString: @""])) {
					_currentMultiplicationArrayIndex--;
				}
				else {
					break;
				}

			}
			
			/* invoke undo */
			multOp = [[MultiplicationOperation alloc] 
					  initWithOperands:leftOperandDigitField : rightOperandDigitField : targetDigitField : 0];
			[multOp undo];
			if ([carriedOverValArray count] > 0) {
				[carriedOverValArray removeLastObject];
			}
		}
		else {
			/* go back to last addition performed */
			_currentAdditionArrayIndex--;
			while (_currentAdditionArrayIndex >= 0) {
				leftOperandDigitField = 
					[[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:0];
				rightOperandDigitField = 
					[[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:1];
				targetDigitField = 
					[[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:2];				
				if ([[[targetDigitField getTextField] text] isEqualToString: @""]) {
					_currentAdditionArrayIndex--;
				}
				else {
					break;
				}

			}		
			
			/* invoke undo */
			addOp = [[AdditionOperation alloc] 
					  initWithOperands:leftOperandDigitField : rightOperandDigitField : targetDigitField : 0];
			[addOp undo];
			if ([carriedOverValArray count] > 0) {
				[carriedOverValArray removeLastObject];
			}
			
			/* if the 2nd multiplicand has one digit, undo all additions and last multiplication */
			if (multiplicand2 < 10) {
				while (_currentAdditionArrayIndex >= 0) {
					[self undoLastStep:NULL];
				}
			}
		}
	}
		
	[self disableAllDigitFields];
	if ([self getNextOp] != NULL) {
		[[self getNextOp] enableTargetDigitFields];
	}
}

- (IBAction) getHint:(id)sender {
    Operation *op = [self getNextOp];
    if (op != NULL) {
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Hint"
                                            message:[op getHint]
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        if ([self presentedViewController] == NULL) {
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (Operation *) getNextOp {
	Operation *op = NULL;
	DigitField *leftOperandDigitField;
	DigitField *rightOperandDigitField;
	DigitField *targetDigitField;
	bool doMultiplication = false;
	int carriedOverVal = 0;
	
	if (_currentAdditionArrayIndex == -1) {		/* if multiplication */			
		/* advance to next multiplication */
		while (_currentMultiplicationArrayIndex < [multiplicationArray count]) {
			leftOperandDigitField = 
				[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:0];
			rightOperandDigitField = 
				[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:1];
			targetDigitField = 
				[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:2];
			if ([[[leftOperandDigitField getTextField] text] isEqualToString:@""]
				|| [[[rightOperandDigitField getTextField] text] isEqualToString:@""]) {
				_currentMultiplicationArrayIndex++;
			}
			else {
				doMultiplication = true;
				break;
			}
		}
		if (doMultiplication) {
			carriedOverVal = [[carriedOverValArray lastObject] intValue];
			op = [[MultiplicationOperation alloc] 
				  initWithOperands:leftOperandDigitField : rightOperandDigitField : targetDigitField : carriedOverVal];
		}
	}
	else {										/* if addition */
		if (_currentAdditionArrayIndex < [additionArray count]) {
			NSNull *nullValue = [NSNull null];
			NSString *leftOperandStr = @"";
			NSString *rightOperandStr = @"";
			id leftOperand = [[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:0];
			id rightOperand = [[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:1];
			
			/* if the two fields are not empty, proceed with addition */
			if (leftOperand != nullValue) {
				leftOperandDigitField = [[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:0];
				leftOperandStr = [[leftOperandDigitField getTextField] text];
			}
			else {
				leftOperandDigitField = NULL;
			}

			if (rightOperand != nullValue) {
				rightOperandDigitField = [[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:1];
				rightOperandStr = [[rightOperandDigitField getTextField] text];
			}
			else {
				rightOperandDigitField = NULL;
			}

			if (!([leftOperandStr isEqualToString:@""] && [rightOperandStr isEqualToString:@""])) {
				targetDigitField = [[additionArray objectAtIndex:_currentAdditionArrayIndex] objectAtIndex:2];
				carriedOverVal = [[carriedOverValArray lastObject] intValue];
				op = [[AdditionOperation alloc] 
					initWithOperands: leftOperandDigitField: rightOperandDigitField: targetDigitField: carriedOverVal];
			}
		}
	}	
	
	return op;
}

- (void) checkForCorrectEntry:(UITextField *) textField {
	/* enable only the target text fields for the next operation */
	Operation *nextOp = [self getNextOp];
	int checkForCorrectEntry = [nextOp checkForCorrectEntry:textField];
	if (checkForCorrectEntry == 1) {
		[self doNextStep:NULL];
	}
	else if (checkForCorrectEntry == -1) {
        [textField resignFirstResponder];
        
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Oops! Try again."
                                            message:@"Please try again or click 'Get Hint'"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        if ([self presentedViewController] == NULL) {
            [self presentViewController:alert animated:YES completion:nil];
        }
	}
}
 
- (void) disableAllDigitFields {
	[_multiplicand1OnesDigitField disable];
	[_multiplicand1TensDigitField disable];
	[_multiplicand1HundredsDigitField disable];
	[_multiplicand2OnesDigitField disable];
	[_multiplicand2TensDigitField disable];
	[_product1OnesDigitField disable];
	[_product1TensDigitField disable];
	[_product1HundredsDigitField disable];
	[_product1ThousandsDigitField disable];
	[_product2TensDigitField disable];
	[_product2HundredsDigitField disable];
	[_product2ThousandsDigitField disable];
	[_product2TenThousandsDigitField disable];
	[_resultOnesDigitField disable];
	[_resultTensDigitField disable];
	[_resultHundredsDigitField disable];
	[_resultThousandsDigitField disable];
	[_resultTenThousandsDigitField disable];
	[_carryTensDigitField disable];
	[_carryHundredsDigitField disable];
	[_carryThousandsDigitField disable];	
}

- (void) clearCarryDigitFields {
	[_carryTensDigitField getTextField].text = @"";
	[_carryHundredsDigitField getTextField].text = @"";
	[_carryThousandsDigitField getTextField].text = @"";
}

- (void) populateCarryDigitFields:(int)value {
	int decimalPosition = [self getCurrentCarryDecimalPosition];
	if (value != 0) {
		if (decimalPosition == 10) {
			[_carryTensDigitField getTextField].text = [[NSNumber numberWithInt:value] stringValue];
		}
		else if (decimalPosition == 100) {
			[_carryHundredsDigitField getTextField].text = [[NSNumber numberWithInt:value] stringValue];
		}
		else if (decimalPosition == 1000) {
			[_carryThousandsDigitField getTextField].text = [[NSNumber numberWithInt:value] stringValue];		
		}
	}
}

- (int) getCurrentCarryDecimalPosition {
	int carryDecimalPosition = 0;
	
	DigitField *leftOperandDigitField;
	DigitField *rightOperandDigitField;
	DigitField *targetDigitField;	
	if (_currentAdditionArrayIndex == -1) {		/* if multiplication */			
		/* advance to next multiplication */
		while (_currentMultiplicationArrayIndex < [multiplicationArray count]) {
			leftOperandDigitField = 
				[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:0];
			rightOperandDigitField = 
				[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:1];
			targetDigitField = 
			[[multiplicationArray objectAtIndex:_currentMultiplicationArrayIndex] objectAtIndex:2];
			if ([[[leftOperandDigitField getTextField] text] isEqualToString:@""]
				|| [[[rightOperandDigitField getTextField] text] isEqualToString:@""]) {
				_currentMultiplicationArrayIndex++;
			}
			else {
				carryDecimalPosition = [targetDigitField getDecimalPosition] * 10;
				break;
			}
		}
	}
		
	return carryDecimalPosition;
}

- (NSString *) getFinalResultMessage {
	NSString *msg = @"";
	NSNumber *multiplicand1Num = [NSNumber numberWithInt:multiplicand1];
	NSNumber *multiplicand2Num = [NSNumber numberWithInt:multiplicand2];
	NSString *resultStr = [[NSNumber numberWithInt:multiplicand1 * multiplicand2] stringValue];
	msg = [msg stringByAppendingString:[multiplicand1Num stringValue]];
	msg = [msg stringByAppendingString:@" × "];
	msg = [msg stringByAppendingString:[multiplicand2Num stringValue]];
	msg = [msg stringByAppendingString:@" = "];
	msg = [msg stringByAppendingString:resultStr];
	return (msg);
}

@end

