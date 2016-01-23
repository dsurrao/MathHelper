//
//  DivisionRemainderViewController.m
//  MathHelp
//
//  Created by Dominic Surrao on 5/15/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "DivisionRemainderViewController.h"
#import "DivisionStep.h"
#import "MultiplicationStep.h"
#import "SubtractionStep.h"
#import "CarryStep.h"
#import "DigitField.h"
#import "NumberParser.h"

@implementation DivisionRemainderViewController

@synthesize divisorTF;
@synthesize dividendTensTF;
@synthesize dividendOnesTF;
@synthesize dividendTenthsTF;
@synthesize dividendHundredthsTF;
@synthesize resultTensTF;
@synthesize resultOnesTF;
@synthesize resultTenthsTF;
@synthesize resultHundredthsTF;
@synthesize firstProductTensTF;
@synthesize firstProductOnesTF;
@synthesize firstProductTenthsTF;
@synthesize firstProductHundredthsTF;
@synthesize firstDifferenceTensTF;
@synthesize firstDifferenceOnesTF;
@synthesize firstDifferenceTenthsTF;
@synthesize firstDifferenceHundredthsTF;
@synthesize secondProductTensTF;
@synthesize secondProductOnesTF;
@synthesize secondProductTenthsTF;
@synthesize secondProductHundredthsTF;
@synthesize secondDifferenceOnesTF;
@synthesize secondDifferenceTenthsTF;
@synthesize secondDifferenceHundredthsTF;
@synthesize thirdProductOnesTF;
@synthesize thirdProductTenthsTF;
@synthesize thirdProductHundredthsTF;
@synthesize thirdDifferenceTenthsTF;
@synthesize thirdDifferenceHundredthsTF;
@synthesize fourthProductTenthsTF;
@synthesize fourthProductHundredthsTF;
@synthesize fourthDifferenceHundredthsTF;

@synthesize orderedOperationNameArray;
@synthesize stepArray;
@synthesize divisionStepTemplateArray;
@synthesize multiplicationStepTemplateArray;
@synthesize subtractionStepTemplateArray;
@synthesize carryStepTemplateArray;
@synthesize dividendDigitArray;
@synthesize nextDividendDFArray;
@synthesize	nextStepResultDFArray;
@synthesize nextMultiplicandDF;
@synthesize nextSubtractionDFArray;
@synthesize currentSubtractionTargetDF;
@synthesize divisor;
@synthesize dividend;

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

#pragma mark -
#pragma mark UIViewController overrides

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];
	
	/* configure "Done" button */
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									   target:self
									   action:@selector(dismissNumberPad:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
	
	resultMessage = [self getResultMessage];
	
	orderedOperationNameArray = [NSMutableArray arrayWithObjects:
						  @"division", @"multiplication", @"subtraction", @"carry", nil];
	currentOperationNameIndex = 0;
	currentStepArrayIndex = 0;
	currentMultiplicationStepNumber = 1;
	currentCarryStepNumber = 1;
	nextDividendDFArray = NULL;
	nextMultiplicandDF = NULL;
	nextSubtractionDFArray = NULL;
	currentSubtractionTargetDF = NULL;
	
	[self initializeDigitFields];
	[self initializeStepArray];
	
    /* populate stepArray, the sequence of steps to solve the current problem */
	bool silentFlag = true;
	Step *nextStep = NULL;
	NSString *currentOperationName;
	do {
		currentOperationName = [orderedOperationNameArray objectAtIndex:currentOperationNameIndex];
		if ([currentOperationName isEqualToString:@"division"] ) {
			nextStep = [self getNextDivisionStep];
			if (nextStep != NULL) {
				nextStepResultDFArray = [nextStep doStep:silentFlag];
				[stepArray addObject:nextStep];
				nextMultiplicandDF = [nextStepResultDFArray objectAtIndex:0];
			}
		}
		else if ([currentOperationName isEqualToString:@"multiplication"] ) {
			nextStep = [self getNextMultiplicationStep];
			if (nextStep != NULL) {
				nextStepResultDFArray = [nextStep doStep:silentFlag];
				[stepArray addObject:nextStep];
				nextSubtractionDFArray = nextStepResultDFArray;
				if ([nextSubtractionDFArray count] > 1) {
					if (([[[nextSubtractionDFArray objectAtIndex:0] getCharValue] isEqualToString:@""]) 
						|| ([[[nextSubtractionDFArray objectAtIndex:0] getCharValue] isEqualToString:@"0"])) {
						[nextSubtractionDFArray removeObjectAtIndex:0];
					}
				}
				currentMultiplicationStepNumber++;
			}
		}		
		else if ([currentOperationName isEqualToString:@"subtraction"] ) {
			nextStep = [self getNextSubtractionStep];
			if (nextStep != NULL) {
				nextStepResultDFArray = [nextStep doStep:silentFlag];
				[stepArray addObject:nextStep];
				currentSubtractionTargetDF = [nextStepResultDFArray objectAtIndex:0];
				if ([[currentSubtractionTargetDF getCharValue] isEqualToString:@"0"]) {					
					nextStep = [self getNextCarryStep];
					if (nextStep != NULL) {
						if ([[[[(CarryStep *)nextStep getCarryDF] getTextField] text] isEqualToString:@""]) {
							nextStep = NULL;
						}
					}
				}
			}
		}
		else if ([currentOperationName isEqualToString:@"carry"] ) {
			nextStep = [self getNextCarryStep];
			if (nextStep != NULL) {
				nextStepResultDFArray = [nextStep doStep:silentFlag];
				[stepArray addObject:nextStep];
				nextDividendDFArray = [NSMutableArray arrayWithObjects:currentSubtractionTargetDF,
									   [nextStepResultDFArray objectAtIndex:0], nil];				
				currentCarryStepNumber++;
			}
			
			//nextStep = NULL; //REMOVE LATER!
		}
		if (currentOperationNameIndex < 3) {
			currentOperationNameIndex++;
		}
		else {
			currentOperationNameIndex = 0;
		}
		
	} while (nextStep != NULL);		
		
	[self disableNonEditableDigitFields];
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




#pragma mark digit field and steps initialization

- (void) initializeDigitFields {
	divisorTF.text = [[NSNumber numberWithInt:divisor] stringValue];
	NumberParser *numParser = [[NumberParser alloc] init];
	int dividendInt = [[dividend decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] intValue];
	self.dividendDigitArray = [numParser parseInteger:dividendInt];
	for (int i = 0; i < [dividendDigitArray count]; i++) {
		if (i == 0) {
			dividendHundredthsTF.text = [[dividendDigitArray objectAtIndex:i] stringValue];
		}
		else if (i == 1) {
			dividendTenthsTF.text = [[dividendDigitArray objectAtIndex:i] stringValue];
		}
		else if (i == 2) {
			dividendOnesTF.text = [[dividendDigitArray objectAtIndex:i] stringValue];
		}
		else if (i == 3) {
			dividendTensTF.text = [[dividendDigitArray objectAtIndex:i] stringValue];
		}
	}
				
	divisorDF = [[DigitField alloc] initWithTextField:divisorTF:1];	
	dividendTensDF = [[DigitField alloc] initWithTextField:dividendTensTF:10];
	dividendOnesDF = [[DigitField alloc] initWithTextField:dividendOnesTF:1];
	dividendTenthsDF = [[DigitField alloc] initWithTextField:dividendTenthsTF:-10];
	dividendHundredthsDF = [[DigitField alloc] initWithTextField:dividendHundredthsTF:-100];
	
	/* replace leading blanks with zeros */	
	if ([dividendOnesTF.text isEqualToString:@""]) {
		dividendOnesTF.text = @"0";
		[dividendOnesDF setCharValue:@"0"];
		if ([dividendTenthsTF.text isEqualToString:@""]) {
			dividendTenthsTF.text = @"0";
			[dividendTenthsDF setCharValue:@"0"];
		}
	}
	
	/* replace trailing zeros with blanks */
	if ([dividendHundredthsTF.text isEqualToString:@"0"]) {
		dividendHundredthsTF.text = @"";
		[dividendHundredthsDF setCharValue:@"0"];
		if ([dividendTenthsTF.text isEqualToString:@"0"]) {
			dividendTenthsTF.text = @"";
			[dividendTenthsDF setCharValue:@"0"];
		}
	}
	
	resultTensDF = [[DigitField alloc] initWithTextField:resultTensTF:10];
	resultOnesDF = [[DigitField alloc] initWithTextField:resultOnesTF:1];
	resultTenthsDF = [[DigitField alloc] initWithTextField:resultTenthsTF:-10];
	resultHundredthsDF = [[DigitField alloc] initWithTextField:resultHundredthsTF:-100];
	firstProductTensDF = [[DigitField alloc] initWithTextField:firstProductTensTF:10];
	firstProductOnesDF = [[DigitField alloc] initWithTextField:firstProductOnesTF:1];
	firstProductTenthsDF = [[DigitField alloc] initWithTextField:firstProductTenthsTF:-10];
	firstProductHundredthsDF = [[DigitField alloc] initWithTextField:firstProductHundredthsTF:-100];
	firstDifferenceTensDF = [[DigitField alloc] initWithTextField:firstDifferenceTensTF:10];
	firstDifferenceOnesDF = [[DigitField alloc] initWithTextField:firstDifferenceOnesTF:1];
	firstDifferenceTenthsDF = [[DigitField alloc] initWithTextField:firstDifferenceTenthsTF:-10];
	firstDifferenceHundredthsDF = [[DigitField alloc] initWithTextField:firstDifferenceHundredthsTF:-100];
	secondProductTensDF = [[DigitField alloc] initWithTextField:secondProductTensTF:10];
	secondProductOnesDF = [[DigitField alloc] initWithTextField:secondProductOnesTF:1];
	secondProductTenthsDF = [[DigitField alloc] initWithTextField:secondProductTenthsTF:-10];
	secondProductHundredthsDF = [[DigitField alloc] initWithTextField:secondProductHundredthsTF:-100];
	secondDifferenceOnesDF = [[DigitField alloc] initWithTextField:secondDifferenceOnesTF:1];
	secondDifferenceTenthsDF = [[DigitField alloc] initWithTextField:secondDifferenceTenthsTF:-10];
	secondDifferenceHundredthsDF = [[DigitField alloc] initWithTextField:secondDifferenceHundredthsTF:-100];
	thirdProductOnesDF = [[DigitField alloc] initWithTextField:thirdProductOnesTF:1];
	thirdProductTenthsDF = [[DigitField alloc] initWithTextField:thirdProductTenthsTF:-10];
	thirdProductHundredthsDF = [[DigitField alloc] initWithTextField:thirdProductHundredthsTF:-100];
	thirdDifferenceTenthsDF = [[DigitField alloc] initWithTextField:thirdDifferenceTenthsTF:-10];
	thirdDifferenceHundredthsDF = [[DigitField alloc] initWithTextField:thirdDifferenceHundredthsTF:-100];
	fourthProductTenthsDF = [[DigitField alloc] initWithTextField:fourthProductTenthsTF:-10];
	fourthProductHundredthsDF = [[DigitField alloc] initWithTextField:fourthProductHundredthsTF:-100];
	fourthDifferenceHundredthsDF = [[DigitField alloc] initWithTextField:fourthDifferenceHundredthsTF:-100];
	
}

- (void) updateResultDigitFields: (DigitField *) iTargetDF {
	if (iTargetDF == resultTenthsDF) {
		if ([[resultOnesDF getCharValue] isEqualToString:@""]) {
			[resultOnesDF getTextField].text = @"0";
		}
	}
	if (iTargetDF == resultHundredthsDF) {
		if ([[resultTenthsDF getCharValue] isEqualToString:@""]) {
			[resultTenthsDF getTextField].text = @"0";
		}
		if ([[resultOnesDF getCharValue] isEqualToString:@""]) {
			[resultOnesDF getTextField].text = @"0";
		}
	}
}

/* disable digit fields that are not required for this problem */
- (void) disableNonEditableDigitFields {
	[divisorDF disable];
	[dividendTensDF disable];
	[dividendOnesDF disable];
	[dividendTenthsDF disable];
	[dividendHundredthsDF disable];
	if ([[resultTensDF getCharValue] isEqualToString:@""]) [resultTensDF disable];
	if ([[resultHundredthsDF getCharValue] isEqualToString:@""]) {
		[resultHundredthsDF disable];
		if ([[resultTenthsDF getCharValue] isEqualToString:@""]) {
			[resultTenthsDF disable];
		}
	}
	if ([[firstProductTensDF getCharValue] isEqualToString:@""]) [firstProductTensDF disable];
	if ([[firstProductOnesDF getCharValue] isEqualToString:@""]) [firstProductOnesDF disable];
	if ([[firstProductTenthsDF getCharValue] isEqualToString:@""]) [firstProductTenthsDF disable];
	if ([[firstProductHundredthsDF getCharValue] isEqualToString:@""]) [firstProductHundredthsDF disable];
	if ([[firstDifferenceTensDF getCharValue] isEqualToString:@""]) [firstDifferenceTensDF disable];
	if ([[firstDifferenceOnesDF getCharValue] isEqualToString:@""]) [firstDifferenceOnesDF disable];
	if ([[firstDifferenceTenthsDF getCharValue] isEqualToString:@""]) [firstDifferenceTenthsDF disable];
	if ([[firstDifferenceHundredthsDF getCharValue] isEqualToString:@""]) [firstDifferenceHundredthsDF disable];
	if ([[secondProductTensDF getCharValue] isEqualToString:@""]) [secondProductTensDF disable];
	if ([[secondProductOnesDF getCharValue] isEqualToString:@""]) [secondProductOnesDF disable];
	if ([[secondProductTenthsDF getCharValue] isEqualToString:@""]) [secondProductTenthsDF disable];
	if ([[secondProductHundredthsDF getCharValue] isEqualToString:@""]) [secondProductHundredthsDF disable];
	if ([[secondDifferenceOnesDF getCharValue] isEqualToString:@""]) [secondDifferenceOnesDF disable];
	if ([[secondDifferenceTenthsDF getCharValue] isEqualToString:@""]) [secondDifferenceTenthsDF disable];
	if ([[secondDifferenceHundredthsDF getCharValue] isEqualToString:@""]) [secondDifferenceHundredthsDF disable];
	if ([[thirdProductOnesDF getCharValue] isEqualToString:@""]) [thirdProductOnesDF disable];
	if ([[thirdProductTenthsDF getCharValue] isEqualToString:@""]) [thirdProductTenthsDF disable];
	if ([[thirdProductHundredthsDF getCharValue] isEqualToString:@""]) [thirdProductHundredthsDF disable];
	if ([[thirdDifferenceTenthsDF getCharValue] isEqualToString:@""]) [thirdDifferenceTenthsDF disable];
	if ([[thirdDifferenceHundredthsDF getCharValue] isEqualToString:@""]) [thirdDifferenceHundredthsDF disable];
	if ([[fourthProductTenthsDF getCharValue] isEqualToString:@""]) [fourthProductTenthsDF disable];
	if ([[fourthProductHundredthsDF getCharValue] isEqualToString:@""]) [fourthProductHundredthsDF disable];
	if ([[fourthDifferenceHundredthsDF getCharValue] isEqualToString:@""]) [fourthDifferenceHundredthsDF disable];	
}

- (void) initializeStepArray {
	DivisionStep *ds;
	MultiplicationStep *ms;
	SubtractionStep *ss;
	CarryStep *cs;
	
	divisionStepTemplateArray = [[NSMutableArray alloc] init];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObject:dividendTensDF] 
				:resultTensDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:dividendTensDF, dividendOnesDF, nil] 
				:resultOnesDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:dividendOnesDF, dividendTenthsDF, nil] 
				:resultTenthsDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:dividendTenthsDF, dividendHundredthsDF, nil] 
				:resultHundredthsDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:firstDifferenceTensDF, firstDifferenceOnesDF, nil] 
				:resultOnesDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:firstDifferenceOnesDF, firstDifferenceTenthsDF, nil] 
				:resultTenthsDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:firstDifferenceTenthsDF, firstDifferenceHundredthsDF, nil] 
				:resultHundredthsDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:secondDifferenceOnesDF, secondDifferenceTenthsDF, nil] 
				:resultTenthsDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:secondDifferenceTenthsDF, secondDifferenceHundredthsDF, nil] 
				:resultHundredthsDF];
	[divisionStepTemplateArray addObject:ds];
	ds = [[DivisionStep alloc] initWithOperands:divisorDF 
				:[NSMutableArray arrayWithObjects:thirdDifferenceTenthsDF, thirdDifferenceHundredthsDF, nil] 
				:resultHundredthsDF];
	[divisionStepTemplateArray addObject:ds];
	
	multiplicationStepTemplateArray = [[NSMutableArray alloc] init];
	ms = [[MultiplicationStep alloc] initWithOperands:resultTensDF 
				:divisorDF
				:[NSMutableArray arrayWithObject:firstProductTensDF]
				:1];	
	[multiplicationStepTemplateArray addObject:ms];
	ms = [[MultiplicationStep alloc] initWithOperands:resultOnesDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:firstProductTensDF, firstProductOnesDF, nil]
				:1];
	[multiplicationStepTemplateArray addObject:ms];	
	ms = [[MultiplicationStep alloc] initWithOperands:resultOnesDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:secondProductTensDF, secondProductOnesDF, nil]
				:2];
	[multiplicationStepTemplateArray addObject:ms];	
	ms = [[MultiplicationStep alloc] initWithOperands:resultTenthsDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:firstProductOnesDF, firstProductTenthsDF, nil]
				:1];
	[multiplicationStepTemplateArray addObject:ms];
	ms = [[MultiplicationStep alloc] initWithOperands:resultTenthsDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:secondProductOnesDF, secondProductTenthsDF, nil]
				:2];
	[multiplicationStepTemplateArray addObject:ms];
	ms = [[MultiplicationStep alloc] initWithOperands:resultTenthsDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:thirdProductOnesDF, thirdProductTenthsDF, nil]
				:3];
	[multiplicationStepTemplateArray addObject:ms];
	ms = [[MultiplicationStep alloc] initWithOperands:resultHundredthsDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:firstProductTenthsDF, firstProductHundredthsDF, nil]
				:1];
	[multiplicationStepTemplateArray addObject:ms];	
	ms = [[MultiplicationStep alloc] initWithOperands:resultHundredthsDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:secondProductTenthsDF, secondProductHundredthsDF, nil]
				:2];
	[multiplicationStepTemplateArray addObject:ms];	
	ms = [[MultiplicationStep alloc] initWithOperands:resultHundredthsDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:thirdProductTenthsDF, thirdProductHundredthsDF, nil]
				:3];
	[multiplicationStepTemplateArray addObject:ms];	
	ms = [[MultiplicationStep alloc] initWithOperands:resultHundredthsDF 
				:divisorDF
				:[NSMutableArray arrayWithObjects:fourthProductTenthsDF, fourthProductHundredthsDF, nil]
				:4];
	[multiplicationStepTemplateArray addObject:ms];
	
	subtractionStepTemplateArray = [[NSMutableArray alloc] init];
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObject: dividendTensDF]
		  :[NSMutableArray arrayWithObject: firstProductTensDF]
		  :firstDifferenceTensDF];
	[subtractionStepTemplateArray addObject:ss];
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: dividendTensDF, dividendOnesDF, nil]
		  :[NSMutableArray arrayWithObjects: firstProductTensDF, firstProductOnesDF, nil]
		  :firstDifferenceOnesDF];
	[subtractionStepTemplateArray addObject:ss];
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: dividendOnesDF, dividendTenthsDF, nil]
		  :[NSMutableArray arrayWithObjects: firstProductOnesDF, firstProductTenthsDF, nil]
		  :firstDifferenceTenthsDF];
	[subtractionStepTemplateArray addObject:ss];	
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: dividendTenthsDF, dividendHundredthsDF, nil]
		  :[NSMutableArray arrayWithObjects: firstProductTenthsDF, firstProductHundredthsDF, nil]
		  :firstDifferenceHundredthsDF];
	[subtractionStepTemplateArray addObject:ss];	
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: firstDifferenceTensDF, firstDifferenceOnesDF, nil]
		  :[NSMutableArray arrayWithObjects: secondProductTensDF, secondProductOnesDF, nil]
		  :secondDifferenceOnesDF];
	[subtractionStepTemplateArray addObject:ss];
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: firstDifferenceOnesDF, firstDifferenceTenthsDF, nil]
		  :[NSMutableArray arrayWithObjects: secondProductOnesDF, secondProductTenthsDF, nil]
		  :secondDifferenceTenthsDF];
	[subtractionStepTemplateArray addObject:ss];
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: firstDifferenceTenthsDF, firstDifferenceHundredthsDF, nil]
		  :[NSMutableArray arrayWithObjects: secondProductTenthsDF, secondProductHundredthsDF, nil]
		  :secondDifferenceHundredthsDF];
	[subtractionStepTemplateArray addObject:ss];	
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: secondDifferenceOnesDF, secondDifferenceTenthsDF, nil]
		  :[NSMutableArray arrayWithObjects: thirdProductOnesDF, thirdProductTenthsDF, nil]
		  :thirdDifferenceTenthsDF];
	[subtractionStepTemplateArray addObject:ss];
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: secondDifferenceTenthsDF, secondDifferenceHundredthsDF, nil]
		  :[NSMutableArray arrayWithObjects: thirdProductTenthsDF, thirdProductHundredthsDF, nil]
		  :thirdDifferenceHundredthsDF];
	[subtractionStepTemplateArray addObject:ss];
	ss = [[SubtractionStep alloc] initWithOperands
		  :[NSMutableArray arrayWithObjects: thirdDifferenceTenthsDF, thirdDifferenceHundredthsDF, nil]
		  :[NSMutableArray arrayWithObjects: fourthProductTenthsDF, fourthProductHundredthsDF, nil]
		  :fourthDifferenceHundredthsDF];
	[subtractionStepTemplateArray addObject:ss];
	
	carryStepTemplateArray = [[NSMutableArray alloc] init];
	cs = [[CarryStep alloc] initWithOperands:dividendOnesDF : firstDifferenceOnesDF : 1];
	[carryStepTemplateArray addObject:cs];
	cs = [[CarryStep alloc] initWithOperands:dividendTenthsDF : firstDifferenceTenthsDF : 1];
	[carryStepTemplateArray addObject:cs];
	cs = [[CarryStep alloc] initWithOperands:dividendTenthsDF : secondDifferenceTenthsDF : 2];
	[carryStepTemplateArray addObject:cs];
	cs = [[CarryStep alloc] initWithOperands:dividendTenthsDF : thirdDifferenceTenthsDF : 3];
	[carryStepTemplateArray addObject:cs];
	cs = [[CarryStep alloc] initWithOperands:dividendHundredthsDF : firstDifferenceHundredthsDF : 1];
	[carryStepTemplateArray addObject:cs];
	cs = [[CarryStep alloc] initWithOperands:dividendHundredthsDF : secondDifferenceHundredthsDF : 2];
	[carryStepTemplateArray addObject:cs];
	cs = [[CarryStep alloc] initWithOperands:dividendHundredthsDF : thirdDifferenceHundredthsDF : 3];
	[carryStepTemplateArray addObject:cs];
	
	stepArray = [[NSMutableArray alloc] init];
}

- (Step *) getNextDivisionStep {
	DivisionStep *dStep = NULL;
	NSMutableArray *leftOperandDFArray = NULL;
	NSString *dividendStr;
	
	if (nextDividendDFArray == NULL) { /* this is the first division */
		if ([[[dividendTensDF getTextField] text] isEqualToString:@""]) {
			if ([[[divisorDF getTextField] text] intValue] > [[[dividendOnesDF getTextField] text] intValue]) {
                dividendStr = [[[dividendOnesDF getTextField] text] stringByAppendingString: [dividendTenthsDF getCharValue]];                
				if ([[[divisorDF getTextField] text] intValue] > [dividendStr intValue]) {
					nextDividendDFArray = [NSMutableArray arrayWithObjects:dividendTenthsDF, dividendHundredthsDF, nil];
					dStep = [[DivisionStep alloc] initWithOperands:divisorDF:nextDividendDFArray:resultHundredthsDF];
				}
				else {
					nextDividendDFArray = [NSMutableArray arrayWithObjects:dividendOnesDF, dividendTenthsDF, nil];
					dStep = [[DivisionStep alloc] initWithOperands:divisorDF:nextDividendDFArray:resultTenthsDF];
				}				
			}
			else {
				nextDividendDFArray = [NSMutableArray arrayWithObject:dividendOnesDF];
				dStep = [[DivisionStep alloc] initWithOperands:divisorDF:nextDividendDFArray:resultOnesDF];
			}
		}
		else if ([[[dividendTensDF getTextField] text] intValue] < [[[divisorDF getTextField] text] intValue]) {
			nextDividendDFArray = [NSMutableArray arrayWithObjects:dividendTensDF, dividendOnesDF, nil];
			dStep = [[DivisionStep alloc] initWithOperands:divisorDF:nextDividendDFArray:resultOnesDF];
		}
		else {
			nextDividendDFArray = [NSMutableArray arrayWithObject:dividendTensDF];
			dStep = [[DivisionStep alloc] initWithOperands:divisorDF:nextDividendDFArray:resultTensDF];
		}		
		
		if ([nextDividendDFArray count] > 1) {
			if (([[[nextDividendDFArray objectAtIndex:0] getCharValue] isEqualToString:@""]) 
				|| ([[[nextDividendDFArray objectAtIndex:0] getCharValue] isEqualToString:@"0"])) {
				[nextDividendDFArray removeObjectAtIndex:0];
			}
		}
	}
	else {
		for (int i = 0; i < [divisionStepTemplateArray count]; i++) {
			dStep = [divisionStepTemplateArray objectAtIndex:i];
			leftOperandDFArray = [dStep getLeftOperandDFArray];
			
			if ((nextDividendDFArray.count == 2) && (leftOperandDFArray.count == 2)) {
				if (([nextDividendDFArray objectAtIndex:0] == [leftOperandDFArray objectAtIndex:0])
					&& ([nextDividendDFArray objectAtIndex:1] == [leftOperandDFArray objectAtIndex:1])) {
					break;
				}
				else {
					dStep = NULL;
				}
			}
			else {
				dStep = NULL;
			}

		}
	}

	return (dStep);
}

- (Step *) getNextMultiplicationStep {
	MultiplicationStep *mStep = NULL;

	for (int i = 0; i < [multiplicationStepTemplateArray count]; i++) {
		mStep = [multiplicationStepTemplateArray objectAtIndex:i];
		if ((nextMultiplicandDF == [mStep getLeftOperandDF]) && ([mStep getStepNumber] == currentMultiplicationStepNumber)) {
			break;
		}
	}
	
	return (mStep);
}

- (Step *) getNextSubtractionStep {
	SubtractionStep *sStep = NULL;
	int i, j;
	bool foundStep = true;
	
	if ([nextDividendDFArray count] > 1) {
		if (([[[nextDividendDFArray objectAtIndex:0] getCharValue] isEqualToString:@""]) 
				|| ([[[nextDividendDFArray objectAtIndex:0] getCharValue] isEqualToString:@"0"])) {
			[nextDividendDFArray removeObjectAtIndex:0];
		}
	}	
	
	for (i = 0; i < [subtractionStepTemplateArray count]; i++) {
		foundStep = true;
		
		sStep = [subtractionStepTemplateArray objectAtIndex:i];
						
		for (j = 0; j < [nextDividendDFArray count]; j++) {
			if (![[sStep getLeftOperandDFArray] containsObject:[nextDividendDFArray objectAtIndex:j]]) {
				foundStep = false;
			}
		}
		for (j = 0; j < [nextSubtractionDFArray count]; j++) {
			if (![[sStep getRightOperandDFArray] containsObject:[nextSubtractionDFArray objectAtIndex:j]]) {
				foundStep = false;
			}
		}
		
		if (foundStep) {
			break;
		}
	}
	
	if (!foundStep) {
		sStep = NULL;
	}
	
	return (sStep);
}

- (Step *) getNextCarryStep {
	CarryStep *cStep = NULL;
	DigitField *nextCarryDF = NULL;
	int currentSubtractionTargetDecimalPosition = [currentSubtractionTargetDF getDecimalPosition];
	
	if (currentSubtractionTargetDecimalPosition == 10) {
		nextCarryDF = dividendOnesDF;
	}
	else if (currentSubtractionTargetDecimalPosition == 1) {
		nextCarryDF = dividendTenthsDF;
	}	
	else if (currentSubtractionTargetDecimalPosition == -10) {
		nextCarryDF = dividendHundredthsDF;
	}
	
	for (int i = 0; i < [carryStepTemplateArray count]; i++) {
		cStep = [carryStepTemplateArray objectAtIndex:i];
		if (([cStep getCarryDF] == nextCarryDF) && ([cStep getStepNumber] == currentCarryStepNumber)) {
			break;
		}
		else {
			cStep = NULL;
		}

	}	
	return (cStep);
}

- (Step *) getNextStep {
	Step *retStep = NULL;
	if ([stepArray count] > 0) {
		retStep = (Step *) [stepArray objectAtIndex:currentStepArrayIndex];
	}
	return (retStep);
}


#pragma mark text field delegate callbacks

/* Ensures that a maximum of 1 digit is entered in a text field */
- (bool)textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
        bool correctEntryFlag = [self checkForCorrectEntryOnEdit:textField];
        if (!correctEntryFlag) {
            [self undoFollowingSteps:textField];
        }
    }
    else if ([[textField text] length] == 0) {
        [self undoFollowingSteps:textField];
    }
	return YES;
}

#pragma mark UI callbacks

- (IBAction)doNextStepIBAction:(id)sender {
	if (currentStepArrayIndex < [stepArray count]) {
		bool silentFlag = false;
		[[stepArray objectAtIndex:currentStepArrayIndex] doStep:silentFlag];
		
		/* update result fields if this is a division */
		if ([[stepArray objectAtIndex:currentStepArrayIndex] isMemberOfClass:[DivisionStep class]]) {
			DivisionStep *divisionStep = [stepArray objectAtIndex:currentStepArrayIndex];
			[self updateResultDigitFields : [divisionStep getTargetDF]];
		}
		
		/* increment step */
		currentStepArrayIndex++;
		
		/* if this is the last step display result message */
		if (currentStepArrayIndex == [stepArray count]) {
            UIAlertController* alert =
            [UIAlertController alertControllerWithTitle:@"Problem solved!"
                                                message:resultMessage
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
		}
	}
}

- (IBAction)getHint:(id)sender {
	if (currentStepArrayIndex < [stepArray count]) {
		NSString *hintStr = [[self getNextStep] getHint];
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Hint"
                                            message:hintStr
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
	}
}

- (void) undoFollowingSteps:(UITextField *) iTextField {
	int i, j;
	for (i = 0; i < [stepArray count]; i++) {
		if ([[stepArray objectAtIndex:i] targetContainsTextField:iTextField]) {
			break;
		}
	}
	if (i < ([stepArray count] - 1)) {
		for (j = i + 1; j < [stepArray count]; j++) {
			[[stepArray objectAtIndex:j] undo];
		}
	}
	currentStepArrayIndex = i;
}

- (bool) checkForCorrectEntryOnEdit:(UITextField *) iTextField {
	int i, j;
	bool correctEntryFlag = false;
	bool silentFlag = false;
	bool currentStepCompleteFlag = false;
	DivisionStep *divisionStep;
	MultiplicationStep *multiplicationStep;
	
	for (i = 0; i < [stepArray count]; i++) {
		if ([[stepArray objectAtIndex:i] targetContainsTextField:iTextField]) {
			if (![[stepArray objectAtIndex:i] checkForCorrectEntry:iTextField]) {
				correctEntryFlag = false;
			}
			else {
				correctEntryFlag = true;
				
				if ([[stepArray objectAtIndex:i] isMemberOfClass:[DivisionStep class]]) {
					divisionStep = [stepArray objectAtIndex:i];
					[self updateResultDigitFields : [divisionStep getTargetDF]];
					[[stepArray objectAtIndex:i] doStep:silentFlag];
					currentStepCompleteFlag = true;
				}
				else if ([[stepArray objectAtIndex:i] isMemberOfClass:[MultiplicationStep class]]) {
					multiplicationStep = [stepArray objectAtIndex:i];
					if ([multiplicationStep isComplete]) {
						[[stepArray objectAtIndex:i] doStep:silentFlag];
						currentStepCompleteFlag = true;
					}
				}
				else {
					[[stepArray objectAtIndex:i] doStep:silentFlag];
					currentStepCompleteFlag = true;
				}
			}
			break;
		}
	}
	
	/* if entry is correct, make sure all steps upto the one prior to the current one are performed */
	if ([iTextField isEqual:resultHundredthsTF]) {	/* if this is the last entry textbox, do all steps */
		i = (int)[stepArray count];
	}
	if (correctEntryFlag) {
		for (j = 0; j < i; j++) {
			[[stepArray objectAtIndex:j] doStep:silentFlag];
			if ([[stepArray objectAtIndex:j] isMemberOfClass:[DivisionStep class]]) {
				divisionStep = [stepArray objectAtIndex:j];
				[self updateResultDigitFields : [divisionStep getTargetDF]];
			}
		}
		if ((i < [stepArray count] - 1) && currentStepCompleteFlag) {
			currentStepArrayIndex = i + 1;
		}
		
		/* if this is the last step display result message */
		if (i >= ([stepArray count] - 1)) {
            UIAlertController* alert =
            [UIAlertController alertControllerWithTitle:@"Problem solved!"
                                                message:resultMessage
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
		}
	}
	else {
		if (!(([iTextField isEqual:resultTensTF] && [[resultTensDF getCharValue] isEqualToString:@""] && [[iTextField text] isEqualToString:@"0"]) 
			  ||
			  ([iTextField isEqual:resultOnesTF] && [[resultOnesDF getCharValue] isEqualToString:@""] && [[iTextField text] isEqualToString:@"0"]))) {
            UIAlertController* alert =
            [UIAlertController alertControllerWithTitle:@"Try one more time."
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
	
	return (correctEntryFlag);
}


- (NSString *) getResultMessage {
	NSString *resultMessageLocal = @"";
	NSString *divisorStr = [[NSNumber numberWithInt:divisor] stringValue];
	NSString *dividendStr = [self.dividend stringValue];
	NSString *resultStr = @"";
	NSString *roundedResultStr = @"";
	
	NSDecimalNumber *resultDecimal = [[NSDecimalNumber decimalNumberWithString:dividendStr] 
									  decimalNumberByDividingBy: [NSDecimalNumber decimalNumberWithString:divisorStr]];
	
	NSDecimalNumberHandler* roundingBehavior2DP = 
	[[NSDecimalNumberHandler alloc] 
		initWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO 
		raiseOnDivideByZero:NO];
	NSDecimalNumberHandler* roundingBehavior3DP = 
	[[NSDecimalNumberHandler alloc] 
		initWithRoundingMode:NSRoundPlain scale:3 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO 
		raiseOnDivideByZero:NO];
	NSDecimalNumber *roundedResultDecimal2DP = [resultDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior2DP];
	
	NSDecimalNumber *roundedResultDecimal3DP = [resultDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior3DP];
	
	if (![[roundedResultDecimal2DP stringValue] isEqualToString: [roundedResultDecimal3DP stringValue]]) {
		resultStr = [roundedResultDecimal3DP stringValue];
		roundedResultStr = [roundedResultDecimal2DP stringValue];
	}
	else {
		resultStr = [roundedResultDecimal2DP stringValue];
	}

	
	resultMessageLocal = [resultMessageLocal stringByAppendingString:dividendStr];
	resultMessageLocal = [resultMessageLocal stringByAppendingString:@" ÷ "];
	resultMessageLocal = [resultMessageLocal stringByAppendingString:divisorStr];
	resultMessageLocal = [resultMessageLocal stringByAppendingString:@" = "];
	resultMessageLocal = [resultMessageLocal stringByAppendingString:resultStr];
	if (![roundedResultStr isEqualToString:@""]) {
		resultMessageLocal = [resultMessageLocal stringByAppendingString:@"\n ≈ "];
		resultMessageLocal = [resultMessageLocal stringByAppendingString:roundedResultStr];
	}
	return (resultMessageLocal);
}

- (void) dismissNumberPad:(id)sender {
	[resultTensTF resignFirstResponder];
	[resultOnesTF resignFirstResponder];
	[resultTenthsTF resignFirstResponder];
	[resultHundredthsTF resignFirstResponder];
	[firstProductTensTF resignFirstResponder];
	[firstProductOnesTF resignFirstResponder];
	[firstProductTenthsTF resignFirstResponder];
	[firstProductHundredthsTF resignFirstResponder];
	[firstDifferenceTensTF resignFirstResponder];
	[firstDifferenceOnesTF resignFirstResponder];
	[firstDifferenceTenthsTF resignFirstResponder];
	[firstDifferenceHundredthsTF resignFirstResponder];
	[secondProductTensTF resignFirstResponder];
	[secondProductOnesTF resignFirstResponder];
	[secondProductTenthsTF resignFirstResponder];
	[secondProductHundredthsTF resignFirstResponder];
	[secondDifferenceOnesTF resignFirstResponder];
	[secondDifferenceTenthsTF resignFirstResponder];
	[secondDifferenceHundredthsTF resignFirstResponder];
	[thirdProductOnesTF resignFirstResponder];
	[thirdProductTenthsTF resignFirstResponder];
	[thirdProductHundredthsTF resignFirstResponder];
	[thirdDifferenceTenthsTF resignFirstResponder];
	[thirdDifferenceHundredthsTF resignFirstResponder];
	[fourthProductTenthsTF resignFirstResponder];
	[fourthProductHundredthsTF resignFirstResponder];
	[fourthDifferenceHundredthsTF resignFirstResponder];	
}

@end




