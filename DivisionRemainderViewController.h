//
//  DivisionRemainderViewController.h
//  MathHelp
//
//  Created by Dominic Surrao on 5/15/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitField.h"
#import "Step.h"

@interface DivisionRemainderViewController : UIViewController {

@public
	UITextField *__weak divisorTF;
	UITextField *__weak dividendTensTF;
	UITextField *__weak dividendOnesTF;
	UITextField *__weak dividendTenthsTF;
	UITextField *__weak dividendHundredthsTF;
	UITextField *__weak resultTensTF;
	UITextField *__weak resultOnesTF;
	UITextField *__weak resultTenthsTF;
	UITextField *__weak resultHundredthsTF;
	UITextField *__weak firstProductTensTF;
	UITextField *__weak firstProductOnesTF;
	UITextField *__weak firstProductTenthsTF;
	UITextField *__weak firstProductHundredthsTF;
	UITextField *__weak firstDifferenceTensTF;
	UITextField *__weak firstDifferenceOnesTF;
	UITextField *__weak firstDifferenceTenthsTF;
	UITextField *__weak firstDifferenceHundredthsTF;
	UITextField *__weak secondProductTensTF;
	UITextField *__weak secondProductOnesTF;
	UITextField *__weak secondProductTenthsTF;
	UITextField *__weak secondProductHundredthsTF;
	UITextField *__weak secondDifferenceOnesTF;
	UITextField *__weak secondDifferenceTenthsTF;
	UITextField *__weak secondDifferenceHundredthsTF;
	UITextField *__weak thirdProductOnesTF;
	UITextField *__weak thirdProductTenthsTF;
	UITextField *__weak thirdProductHundredthsTF;
	UITextField *__weak thirdDifferenceTenthsTF;
	UITextField *__weak thirdDifferenceHundredthsTF;
	UITextField *__weak fourthProductTenthsTF;
	UITextField *__weak fourthProductHundredthsTF;
	UITextField *__weak fourthDifferenceHundredthsTF;
	
@private
	DigitField *divisorDF;
	DigitField *dividendTensDF;
	DigitField *dividendOnesDF;
	DigitField *dividendTenthsDF;
	DigitField *dividendHundredthsDF;
	DigitField *resultTensDF;
	DigitField *resultOnesDF;
	DigitField *resultTenthsDF;
	DigitField *resultHundredthsDF;
	DigitField *firstProductTensDF;
	DigitField *firstProductOnesDF;
	DigitField *firstProductTenthsDF;
	DigitField *firstProductHundredthsDF;
	DigitField *firstDifferenceTensDF;
	DigitField *firstDifferenceOnesDF;
	DigitField *firstDifferenceTenthsDF;
	DigitField *firstDifferenceHundredthsDF;
	DigitField *secondProductTensDF;
	DigitField *secondProductOnesDF;
	DigitField *secondProductTenthsDF;
	DigitField *secondProductHundredthsDF;
	DigitField *secondDifferenceOnesDF;
	DigitField *secondDifferenceTenthsDF;
	DigitField *secondDifferenceHundredthsDF;
	DigitField *thirdProductOnesDF;
	DigitField *thirdProductTenthsDF;
	DigitField *thirdProductHundredthsDF;
	DigitField *thirdDifferenceTenthsDF;
	DigitField *thirdDifferenceHundredthsDF;
	DigitField *fourthProductTenthsDF;
	DigitField *fourthProductHundredthsDF;
	DigitField *fourthDifferenceHundredthsDF;
	DigitField *nextMultiplicandDF;
	DigitField *currentSubtractionTargetDF;
	
	int divisor;
	NSDecimalNumber *dividend;
	int currentOperationNameIndex;
	int currentStepArrayIndex;
	int currentMultiplicationStepNumber;
	int currentCarryStepNumber;
	NSString *resultMessage;
	NSMutableArray *orderedOperationNameArray;
	NSMutableArray *stepArray;
	NSMutableArray *divisionStepTemplateArray;
	NSMutableArray *multiplicationStepTemplateArray;
	NSMutableArray *subtractionStepTemplateArray;
	NSMutableArray *carryStepTemplateArray;
	NSMutableArray *dividendDigitArray;
	NSMutableArray *nextDividendDFArray;
	NSMutableArray *nextStepResultDFArray;
	NSMutableArray *nextSubtractionDFArray;
	
}

@property (nonatomic, weak) IBOutlet UITextField *divisorTF;
@property (nonatomic, weak) IBOutlet UITextField *dividendTensTF;
@property (nonatomic, weak) IBOutlet UITextField *dividendOnesTF;
@property (nonatomic, weak) IBOutlet UITextField *dividendTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *dividendHundredthsTF;
@property (nonatomic, weak) IBOutlet UITextField *resultTensTF;
@property (nonatomic, weak) IBOutlet UITextField *resultOnesTF;
@property (nonatomic, weak) IBOutlet UITextField *resultTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *resultHundredthsTF;
@property (nonatomic, weak) IBOutlet UITextField *firstProductTensTF;
@property (nonatomic, weak) IBOutlet UITextField *firstProductOnesTF;
@property (nonatomic, weak) IBOutlet UITextField *firstProductTenthsTF;		//
@property (nonatomic, weak) IBOutlet UITextField *firstProductHundredthsTF;	//
@property (nonatomic, weak) IBOutlet UITextField *firstDifferenceTensTF;
@property (nonatomic, weak) IBOutlet UITextField *firstDifferenceOnesTF;
@property (nonatomic, weak) IBOutlet UITextField *firstDifferenceTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *firstDifferenceHundredthsTF; //
@property (nonatomic, weak) IBOutlet UITextField *secondProductTensTF;
@property (nonatomic, weak) IBOutlet UITextField *secondProductOnesTF;
@property (nonatomic, weak) IBOutlet UITextField *secondProductTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *secondProductHundredthsTF;	//
@property (nonatomic, weak) IBOutlet UITextField *secondDifferenceOnesTF;
@property (nonatomic, weak) IBOutlet UITextField *secondDifferenceTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *secondDifferenceHundredthsTF;
@property (nonatomic, weak) IBOutlet UITextField *thirdProductOnesTF;
@property (nonatomic, weak) IBOutlet UITextField *thirdProductTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *thirdProductHundredthsTF;
@property (nonatomic, weak) IBOutlet UITextField *thirdDifferenceTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *thirdDifferenceHundredthsTF;
@property (nonatomic, weak) IBOutlet UITextField *fourthProductTenthsTF;
@property (nonatomic, weak) IBOutlet UITextField *fourthProductHundredthsTF;
@property (nonatomic, weak) IBOutlet UITextField *fourthDifferenceHundredthsTF;

@property (nonatomic, strong) NSMutableArray *orderedOperationNameArray;
@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) NSMutableArray *divisionStepTemplateArray;
@property (nonatomic, strong) NSMutableArray *multiplicationStepTemplateArray;
@property (nonatomic, strong) NSMutableArray *subtractionStepTemplateArray;
@property (nonatomic, strong) NSMutableArray *carryStepTemplateArray;
@property (nonatomic, strong) NSMutableArray *dividendDigitArray;
@property (nonatomic, strong) NSMutableArray *nextDividendDFArray;
@property (nonatomic, strong) NSMutableArray *nextStepResultDFArray;
@property (nonatomic, strong) DigitField *nextMultiplicandDF;
@property (nonatomic, strong) NSMutableArray *nextSubtractionDFArray;
@property (nonatomic, strong) DigitField *currentSubtractionTargetDF;
@property (strong) NSDecimalNumber *dividend;
@property (nonatomic, assign) int divisor;

- (IBAction)doNextStepIBAction:(id)sender;
- (IBAction)getHint:(id)sender;
- (bool) checkForCorrectEntryOnEdit:(UITextField *) iTextField;
- (void) undoFollowingSteps:(UITextField *) iTextField;
- (Step *) getNextStep;
- (void) initializeDigitFields;
- (void) initializeStepArray;
- (void) disableNonEditableDigitFields;
- (Step *) getNextDivisionStep;
- (Step *) getNextMultiplicationStep;
- (Step *) getNextSubtractionStep;
- (Step *) getNextCarryStep;
- (NSString *) getResultMessage;

@end
