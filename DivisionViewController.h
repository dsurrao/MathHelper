//
//  DivisionViewController.h
//  MathHelp
//
//  Created by Dominic Surrao on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitField.h"
#import "Utilities.h"
#import "Operation.h"

@interface DivisionViewController : UIViewController {
	
@public
	UITextField *__weak divisorOnes;
	UITextField *__weak dividendOnes;
	UITextField *__weak dividendTens;
	UITextField	*__weak dividendHundreds;
	UITextField	*__weak resultOnes;
	UITextField *__weak resultTens;
	UITextField *__weak resultHundreds;
	UITextField	*__weak firstSubtrahendTens;
	UITextField	*__weak firstSubtrahendHundreds;	
	UITextField	*__weak firstDifferenceOnes;
	UITextField	*__weak firstDifferenceTens;
	UITextField	*__weak firstDifferenceHundreds;
	UITextField	*__weak secondSubtrahendOnes;
	UITextField	*__weak secondSubtrahendTens;
	UITextField	*__weak secondSubtrahendHundreds;
	UITextField	*__weak secondDifferenceOnes;
	UITextField	*__weak secondDifferenceTens;
	UITextField	*__weak thirdSubtrahendOnes;
	UITextField	*__weak thirdSubtrahendTens;	
	UITextField	*__weak thirdDifferenceOnes;
	
@private
	bool isComplete;
	int dividend;
	int divisor;
	int currentLeftOperand;
	int currentRightOperand;
	int currentSubtractionLeftOperand;
	int currentOperationIndex;
	int currentMultiplicationTargetIndex;
	int currentDivisionTargetIndex;
	int currentSubtractionTargetIndex;
	int currentCarryTargetIndex;
	NSMutableArray *orderedOperationArray;
	NSMutableArray *dividendDigitArray;
	NSMutableArray *multiplicationTargetArray;
	NSMutableArray *divisionTargetArray;
	NSMutableArray *subtractionTargetArray;
	NSMutableArray *currentMultiplicationTarget;
	NSMutableArray *currentSubtractionTarget;
	
	DigitField *currentDivisionTarget;
	DigitField *divisorOnesDigitField;
	DigitField *resultOnesDigitField;
	DigitField *resultTensDigitField;
	DigitField *resultHundredsDigitField;
	DigitField *dividendHundredsDigitField;
	DigitField *dividendTensDigitField;
	DigitField *dividendOnesDigitField;
	DigitField *firstSubtrahendHundredsDigitField;
	DigitField *firstSubtrahendTensDigitField;
	DigitField *firstDifferenceHundredsDigitField;
	DigitField *firstDifferenceTensDigitField;
	DigitField *firstDifferenceOnesDigitField;
	DigitField *secondSubtrahendHundredsDigitField;
	DigitField *secondSubtrahendTensDigitField;
	DigitField *secondSubtrahendOnesDigitField;
	DigitField *secondDifferenceTensDigitField;
	DigitField *secondDifferenceOnesDigitField;
	DigitField *thirdSubtrahendTensDigitField;
	DigitField *thirdSubtrahendOnesDigitField;
	DigitField *thirdDifferenceOnesDigitField;
	
	NSMutableArray *_executedOps;
	Utilities *_utils;
}

@property (nonatomic, weak) IBOutlet UITextField *divisorOnes;
@property (nonatomic, weak) IBOutlet UITextField *dividendOnes;
@property (nonatomic, weak) IBOutlet UITextField *dividendTens;
@property (nonatomic, weak) IBOutlet UITextField *dividendHundreds;
@property (nonatomic, weak) IBOutlet UITextField *resultOnes;
@property (nonatomic, weak) IBOutlet UITextField *resultTens;
@property (nonatomic, weak) IBOutlet UITextField *resultHundreds;
@property (nonatomic, weak) IBOutlet UITextField *firstSubtrahendTens;
@property (nonatomic, weak) IBOutlet UITextField *firstSubtrahendHundreds;	
@property (nonatomic, weak) IBOutlet UITextField *firstDifferenceOnes;
@property (nonatomic, weak) IBOutlet UITextField *firstDifferenceTens;
@property (nonatomic, weak) IBOutlet UITextField *firstDifferenceHundreds;
@property (nonatomic, weak) IBOutlet UITextField *secondSubtrahendOnes;
@property (nonatomic, weak) IBOutlet UITextField *secondSubtrahendTens;
@property (nonatomic, weak) IBOutlet UITextField *secondSubtrahendHundreds;
@property (nonatomic, weak) IBOutlet UITextField *secondDifferenceOnes;
@property (nonatomic, weak) IBOutlet UITextField *secondDifferenceTens;
@property (nonatomic, weak) IBOutlet UITextField *thirdSubtrahendOnes;
@property (nonatomic, weak) IBOutlet UITextField *thirdSubtrahendTens;
@property (nonatomic, weak) IBOutlet UITextField *thirdDifferenceOnes;
@property (nonatomic, assign) int divisor;
@property (nonatomic, assign) int dividend;
@property (nonatomic, strong) NSMutableArray *orderedOperationArray;
@property (nonatomic, strong) NSMutableArray *dividendDigitArray;
@property (nonatomic, strong) NSMutableArray *multiplicationTargetArray;
@property (nonatomic, strong) NSMutableArray *divisionTargetArray;
@property (nonatomic, strong) NSMutableArray *subtractionTargetArray;
@property (nonatomic, strong) NSMutableArray *currentMultiplicationTarget;
@property (nonatomic, strong) NSMutableArray *currentSubtractionTarget;
@property (nonatomic, strong) DigitField *currentDivisionTarget;

- (IBAction)doNextStep:(id)sender;
- (IBAction)undoLastStep:(id)sender;
- (IBAction)getHint:(id)sender;

- (void) configureDigitFields;
- (void) disableAllDigitFields;
- (Operation *) getNextOp;
- (Operation *) getLastOp;
- (NSString *) getFinalResultMessage;

@end
