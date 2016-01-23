//
//  DivisionViewController.m
//  MathHelp
//
//  Created by Dominic Surrao on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DivisionViewController.h"
#import "NumberParser.h"
#import "Operation.h"
#import "IntegerDivision.h"
#import "IntegerMultiplication.h"
#import "IntegerAddition.h"
#import "IntegerSubtraction.h"
#import "CarryOperation.h"
#import "Utilities.h"

@implementation DivisionViewController

@synthesize divisorOnes;
@synthesize dividendOnes;
@synthesize dividendTens;
@synthesize dividendHundreds;
@synthesize resultOnes;
@synthesize resultTens;
@synthesize resultHundreds;
@synthesize firstSubtrahendTens;
@synthesize firstSubtrahendHundreds;	
@synthesize firstDifferenceOnes;
@synthesize firstDifferenceTens;
@synthesize firstDifferenceHundreds;
@synthesize secondSubtrahendOnes;
@synthesize secondSubtrahendTens;
@synthesize secondSubtrahendHundreds;
@synthesize secondDifferenceOnes;
@synthesize secondDifferenceTens;
@synthesize thirdSubtrahendOnes;
@synthesize thirdSubtrahendTens;
@synthesize thirdDifferenceOnes;

@synthesize divisor;
@synthesize dividend;
@synthesize orderedOperationArray;
@synthesize dividendDigitArray;
@synthesize multiplicationTargetArray;
@synthesize divisionTargetArray;
@synthesize subtractionTargetArray;
@synthesize currentMultiplicationTarget;
@synthesize currentDivisionTarget;
@synthesize currentSubtractionTarget;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.orderedOperationArray = [NSMutableArray arrayWithObjects:
								 @"division", @"multiplication", @"subtraction", @"carry", nil];
		currentOperationIndex = 0;
		_executedOps = [[NSMutableArray alloc] init];
		_utils = [[Utilities alloc] init];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureDigitFields];
	isComplete = false;
		
	/* load divisor and dividend text fields */
	if ((divisor < 10) && (dividend < 999)) {
		NumberParser *numParser = [[NumberParser alloc] init];
		self.dividendDigitArray = [numParser parseInteger:dividend];
	
		if ([dividendDigitArray count] > 0) {
			dividendOnes.text = [[dividendDigitArray objectAtIndex:0] stringValue];
		}
		if ([dividendDigitArray count] > 1) {
			dividendTens.text = [[dividendDigitArray objectAtIndex:1] stringValue];
		}
		if ([dividendDigitArray count] > 2) {
			dividendHundreds.text = [[dividendDigitArray objectAtIndex:2] stringValue];
		}
		self.divisorOnes.text = [[NSNumber numberWithInt:divisor] stringValue];

	}
	
	currentRightOperand = divisor;
	currentLeftOperand = [[dividendDigitArray objectAtIndex:2] intValue];

	/* if divisor is greater than the first digit, use first two digits as the dividend */
	if (currentLeftOperand < currentRightOperand) {
		currentLeftOperand = ([[dividendDigitArray objectAtIndex:2] intValue] * 10)
			+ [[dividendDigitArray objectAtIndex:1] intValue];
		currentDivisionTargetIndex++;
	}
	
	/* enable only the target text fields for the next operation */
	[[self getNextOp] enableTargetDigitFields];
}

- (IBAction)doNextStep:(id)sender {
	Operation *op = [self getNextOp];
	
	if (op != NULL) {		
		/* do current operation */
		NSString *currentOperation = [orderedOperationArray objectAtIndex:currentOperationIndex];
	
		if ([currentOperation isEqualToString:@"division"]) {
			currentLeftOperand = [op execute];
			currentDivisionTargetIndex ++;
		}
		else if ([currentOperation isEqualToString:@"multiplication"]) {
			currentRightOperand	= [op execute];
			currentMultiplicationTargetIndex ++;
		}
		else if ([currentOperation isEqualToString:@"subtraction"]) {
			currentLeftOperand = [op execute];
			currentSubtractionTargetIndex++;
						
			/* if the result ones field is populated, the problem is complete */
			if ([[resultOnes text] length] != 0) {
				isComplete = true;
                UIAlertController* alert =
                [UIAlertController alertControllerWithTitle:@"Problem solved!"
                                                    message:[self getFinalResultMessage]
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction =
                [UIAlertAction actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
			}
		}
		else if ([currentOperation isEqualToString:@"carry"]) {
			currentLeftOperand = [op execute];
			currentCarryTargetIndex++;
		}
	
		/* advance to next operation */
		if (currentOperationIndex == 3) {
			currentOperationIndex = 0;
		}
		else {
			currentOperationIndex ++;
		}
		
		/* enable text fields for next operation */
		[[self getNextOp] enableTargetDigitFields];
				
		[_executedOps addObject:op];
	}
}


- (IBAction)undoLastStep:(id)sender {
	isComplete = false;
	
	Operation *nextOp = [self getNextOp];
	if (nextOp != NULL) {
		[nextOp clearTargetDigitFields];
	}
	
	Operation *lastOp = [self getLastOp];
	if (lastOp != NULL) {
		[self disableAllDigitFields];
		[lastOp undo];
		if ([lastOp isKindOfClass:[IntegerDivision class]]) {
			currentDivisionTargetIndex --;
			currentLeftOperand = [lastOp getLeftOperand];
			currentRightOperand = [lastOp getRightOperand];
		}
		else if ([lastOp isKindOfClass:[IntegerMultiplication class]]) {
			currentMultiplicationTargetIndex --;
			currentLeftOperand = [lastOp getLeftOperand];
			currentRightOperand = [lastOp getRightOperand];
		}
		else if ([lastOp isKindOfClass:[IntegerSubtraction class]]) {
			currentSubtractionTargetIndex --;
			currentLeftOperand = [lastOp getLeftOperand];
			currentSubtractionLeftOperand = currentLeftOperand;
			currentRightOperand = [lastOp getRightOperand];
		}	
		else if ([lastOp isKindOfClass:[CarryOperation class]]) {
			currentCarryTargetIndex --;
		}	
		if (currentOperationIndex == 0) {
			currentOperationIndex = 3;
		}
		else {
			currentOperationIndex --;
		}
		[_executedOps removeLastObject];
	}
}

- (IBAction) getHint:(id)sender {
    Operation *op = [self getNextOp];
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:@"Hint"
                                        message:[op getHint]
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (Operation *) getNextOp {
	Operation *op = NULL;
	
	/* if problem is not complete, get next step */
	if (!isComplete) {
		int currentLeftOperandDecimalPosition = 1;
		
		if ((currentDivisionTargetIndex - 1) == 0)  {
			currentLeftOperandDecimalPosition = 100;
		}
		else if ((currentDivisionTargetIndex - 1) == 1) {
			currentLeftOperandDecimalPosition = 10;
		}
		else if ((currentDivisionTargetIndex - 1) == 2) {
			currentLeftOperandDecimalPosition = 1;
		}	
		
		/* do current operation */
		NSString *currentOperation = [orderedOperationArray objectAtIndex:currentOperationIndex];
		
		if ([currentOperation isEqualToString:@"division"]) {
			currentRightOperand = divisor;
			currentSubtractionLeftOperand = currentLeftOperand;
			self.currentDivisionTarget = [divisionTargetArray objectAtIndex:currentDivisionTargetIndex];
			op = [[IntegerDivision alloc] initWithOperands: 
										currentLeftOperand :
										currentRightOperand : 
										currentDivisionTarget];
		}	
		else if ([currentOperation isEqualToString:@"multiplication"]) {
			currentRightOperand = divisor;
			self.currentMultiplicationTarget = [multiplicationTargetArray objectAtIndex:currentMultiplicationTargetIndex];
			op = [[IntegerMultiplication alloc] initWithOperands:
											currentLeftOperand : 
											currentLeftOperandDecimalPosition :
											currentRightOperand :
											currentMultiplicationTarget];
		}
		else if ([currentOperation isEqualToString:@"subtraction"]) {
			self.currentSubtractionTarget = [subtractionTargetArray objectAtIndex:currentSubtractionTargetIndex];
			op = [[IntegerSubtraction alloc] initWithOperands:
										currentSubtractionLeftOperand : 
										currentLeftOperandDecimalPosition :
										currentRightOperand :
										currentSubtractionTarget];		
		}
		else if ([currentOperation isEqualToString:@"carry"]) {
			/* get least populated field of current carry target array */
			DigitField *leastPopulatedDigitField = 
				[_utils getLeastPopulatedDigitField:[subtractionTargetArray objectAtIndex:currentCarryTargetIndex]];
			op = [[CarryOperation alloc] initWithOperands: leastPopulatedDigitField];
		}
	}
	
	return op;
}

- (Operation *) getLastOp {
	Operation *op = NULL;
	if ([_executedOps count] > 0) {
		 op = [_executedOps objectAtIndex:[_executedOps count] - 1];
	}
	return (op);
}
					 
- (void) checkForCorrectEntry:(UITextField *) textField {
	/* enable only the target text fields for the next operation */
	Operation *nextOp = [self getNextOp];
	if ([nextOp checkForCorrectEntry:textField] == 1) {
		[self doNextStep:NULL];
		Operation *nextNextOp = [self getNextOp];
		[nextNextOp enableTargetDigitFields];
	}
	else if ([nextOp checkForCorrectEntry:textField] == -1) {
        UIAlertController* alert =
            [UIAlertController alertControllerWithTitle:@"Oops! Try again."
                                                message:@"Please try again or click 'Get Hint'"
                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
	}
}

- (NSString *) getFinalResultMessage {
	NSString *msg = @"";
	NSNumber *divisorNum = [NSNumber numberWithInt:divisor];
	NSNumber *dividendNum = [NSNumber numberWithInt:dividend];
	NSString *resultStr = 
		[[[resultHundredsDigitField getTextField] text] stringByAppendingString:
			[[[resultTensDigitField getTextField] text] stringByAppendingString:
			[[resultOnesDigitField getTextField] text]]];
	msg = [msg stringByAppendingString:[dividendNum stringValue]];
	msg = [msg stringByAppendingString:@" ÷ "];
	msg = [msg stringByAppendingString:[divisorNum stringValue]];
	msg = [msg stringByAppendingString:@" = "];
	msg = [msg stringByAppendingString:resultStr];
	return (msg);
}

- (void)configureDigitFields {
	/* initialize digit fields */
	divisorOnesDigitField = [[DigitField alloc] initWithTextField:divisorOnes:1];
	resultOnesDigitField = [[DigitField alloc] initWithTextField:resultOnes:1];
	resultTensDigitField = [[DigitField alloc] initWithTextField:resultTens:10];
	resultHundredsDigitField = [[DigitField alloc] initWithTextField:resultHundreds:100];
	dividendHundredsDigitField = [[DigitField alloc] initWithTextField:dividendHundreds:100];
	dividendTensDigitField = [[DigitField alloc] initWithTextField:dividendTens:10];
	dividendOnesDigitField = [[DigitField alloc] initWithTextField:dividendOnes:1];
	firstSubtrahendHundredsDigitField = [[DigitField alloc] initWithTextField:firstSubtrahendHundreds:100];
	firstSubtrahendTensDigitField = [[DigitField alloc] initWithTextField:firstSubtrahendTens:10];
	firstDifferenceHundredsDigitField = [[DigitField alloc] initWithTextField:firstDifferenceHundreds:100];
	firstDifferenceTensDigitField = [[DigitField alloc] initWithTextField:firstDifferenceTens:10];
	firstDifferenceOnesDigitField = [[DigitField alloc] initWithTextField:firstDifferenceOnes:1];
	secondSubtrahendHundredsDigitField = [[DigitField alloc] initWithTextField:secondSubtrahendHundreds:100];
	secondSubtrahendTensDigitField = [[DigitField alloc] initWithTextField:secondSubtrahendTens:10];
	secondSubtrahendOnesDigitField = [[DigitField alloc] initWithTextField:secondSubtrahendOnes:1];
	secondDifferenceTensDigitField = [[DigitField alloc] initWithTextField:secondDifferenceTens:10];
	secondDifferenceOnesDigitField = [[DigitField alloc] initWithTextField:secondDifferenceOnes:1];
	thirdSubtrahendTensDigitField = [[DigitField alloc] initWithTextField:thirdSubtrahendTens:10];
	thirdSubtrahendOnesDigitField = [[DigitField alloc] initWithTextField:thirdSubtrahendOnes:1];
	thirdDifferenceOnesDigitField = [[DigitField alloc] initWithTextField:thirdDifferenceOnes:1];
	
	/* and the relationships b/w them */
	[dividendHundredsDigitField setCarryDigitField:dividendTensDigitField];
	[dividendTensDigitField setCarryDigitField:dividendOnesDigitField];
	
	[firstSubtrahendHundredsDigitField setCarryDigitField:firstSubtrahendTensDigitField];

	[firstDifferenceHundredsDigitField setCarryDigitField:dividendTensDigitField];
	[firstDifferenceHundredsDigitField setCarryTargetDigitField:firstDifferenceTensDigitField];
	[firstDifferenceTensDigitField setCarryDigitField:dividendOnesDigitField];
	[firstDifferenceTensDigitField setCarryTargetDigitField:firstDifferenceOnesDigitField];
		
	[secondDifferenceTensDigitField setCarryDigitField:dividendOnesDigitField];
	[secondDifferenceTensDigitField setCarryTargetDigitField:secondDifferenceOnesDigitField];
		
	/* array of fields that are targets for arithmetic operations */
	NSMutableArray *firstSubtrahendArray = [NSMutableArray arrayWithObjects:
											firstSubtrahendTensDigitField,
											firstSubtrahendHundredsDigitField,
											nil];
	NSMutableArray *secondSubtrahendArray = [NSMutableArray arrayWithObjects:
											 secondSubtrahendOnesDigitField,
											 secondSubtrahendTensDigitField,
											 secondSubtrahendHundredsDigitField,
											 nil];
	NSMutableArray *thirdSubtrahendArray = [NSMutableArray arrayWithObjects:
											thirdSubtrahendOnesDigitField,
											thirdSubtrahendTensDigitField,
											nil];
	self.multiplicationTargetArray = [NSMutableArray arrayWithObjects:
									  firstSubtrahendArray, 
									  secondSubtrahendArray, 
									  thirdSubtrahendArray,
									  nil];	
	currentMultiplicationTargetIndex = 0;
	self.divisionTargetArray = [NSMutableArray arrayWithObjects:
								resultHundredsDigitField, 
								resultTensDigitField, 
								resultOnesDigitField, 
								nil];
	currentDivisionTargetIndex = 0;
	NSMutableArray *firstDifferenceArray = [NSMutableArray arrayWithObjects:
											firstDifferenceTensDigitField,
											firstDifferenceHundredsDigitField,
											nil];
	NSMutableArray *secondDifferenceArray = [NSMutableArray arrayWithObjects:
											 secondDifferenceOnesDigitField, 
											 secondDifferenceTensDigitField,
											nil];
	NSMutableArray *thirdDifferenceArray = [NSMutableArray arrayWithObjects:
											thirdDifferenceOnesDigitField,
											nil];
	self.subtractionTargetArray = [NSMutableArray arrayWithObjects:
								   firstDifferenceArray, 
								   secondDifferenceArray,
								   thirdDifferenceArray, 
								   nil];
	currentSubtractionTargetIndex = 0;
	currentCarryTargetIndex = 0;
	
	/* disable all text fields initially */
	[self disableAllDigitFields];	
}

- (void) disableAllDigitFields {
	[divisorOnesDigitField disable];
	[dividendOnesDigitField disable];
	[dividendTensDigitField disable];
	[dividendHundredsDigitField disable];
	[resultOnesDigitField disable];
	[resultTensDigitField disable];
	[resultHundredsDigitField disable];
	[firstSubtrahendTensDigitField disable];
	[firstSubtrahendHundredsDigitField disable];
	[firstDifferenceOnesDigitField disable];
	[firstDifferenceTensDigitField disable];
	[firstDifferenceHundredsDigitField disable];
	[secondSubtrahendOnesDigitField disable];
	[secondSubtrahendTensDigitField disable];
	[secondSubtrahendHundredsDigitField disable];
	[secondDifferenceOnesDigitField disable];
	[secondDifferenceTensDigitField disable];
	[thirdSubtrahendOnesDigitField disable];
	[thirdSubtrahendTensDigitField disable];
	[thirdDifferenceOnesDigitField disable];	
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

- (bool)textFieldDidEndEditing:(UITextField *)textField {
	if ([[textField text] length] == 1) {
		[self checkForCorrectEntry:textField];
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. myOutlet = nil;
}




@end
