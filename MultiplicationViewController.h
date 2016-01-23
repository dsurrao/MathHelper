//
//  MultiplicationViewController.h
//  MathHelp
//
//  Created by Dominic Surrao on 1/29/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitField.h"
#import "Operation.h"

@interface MultiplicationViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *multiplicand1Ones;
@property (nonatomic, weak) IBOutlet UITextField *multiplicand1Tens;
@property (nonatomic, weak) IBOutlet UITextField *multiplicand1Hundreds;
@property (nonatomic, weak) IBOutlet UITextField *multiplicand2Ones;
@property (nonatomic, weak) IBOutlet UITextField *multiplicand2Tens;
@property (nonatomic, weak) IBOutlet UITextField *product1Ones;
@property (nonatomic, weak) IBOutlet UITextField *product1Tens;
@property (nonatomic, weak) IBOutlet UITextField *product1Hundreds;
@property (nonatomic, weak) IBOutlet UITextField *product1Thousands;
@property (nonatomic, weak) IBOutlet UITextField *product2Tens;
@property (nonatomic, weak) IBOutlet UITextField *product2Hundreds;
@property (nonatomic, weak) IBOutlet UITextField *product2Thousands;
@property (nonatomic, weak) IBOutlet UITextField *product2TenThousands;
@property (nonatomic, weak) IBOutlet UITextField *resultOnes;
@property (nonatomic, weak) IBOutlet UITextField *resultTens;
@property (nonatomic, weak) IBOutlet UITextField *resultHundreds;
@property (nonatomic, weak) IBOutlet UITextField *resultThousands;
@property (nonatomic, weak) IBOutlet UITextField *resultTenThousands;
@property (nonatomic, weak) IBOutlet UITextField *carryTens;
@property (nonatomic, weak) IBOutlet UITextField *carryHundreds;
@property (nonatomic, weak) IBOutlet UITextField *carryThousands;
@property (nonatomic, strong) DigitField *multiplicand1OnesDigitField;
@property (nonatomic, strong) DigitField *multiplicand1TensDigitField;
@property (nonatomic, strong) DigitField *multiplicand1HundredsDigitField;
@property (nonatomic, strong) DigitField *multiplicand2OnesDigitField;
@property (nonatomic, strong) DigitField *multiplicand2TensDigitField;
@property (nonatomic, strong) DigitField *product1OnesDigitField;
@property (nonatomic, strong) DigitField *product1TensDigitField;
@property (nonatomic, strong) DigitField *product1HundredsDigitField;
@property (nonatomic, strong) DigitField *product1ThousandsDigitField;
@property (nonatomic, strong) DigitField *product2TensDigitField;
@property (nonatomic, strong) DigitField *product2HundredsDigitField;
@property (nonatomic, strong) DigitField *product2ThousandsDigitField;
@property (nonatomic, strong) DigitField *product2TenThousandsDigitField;
@property (nonatomic, strong) DigitField *resultOnesDigitField;
@property (nonatomic, strong) DigitField *resultTensDigitField;
@property (nonatomic, strong) DigitField *resultHundredsDigitField;
@property (nonatomic, strong) DigitField *resultThousandsDigitField;
@property (nonatomic, strong) DigitField *resultTenThousandsDigitField;
@property (nonatomic, strong) DigitField *carryTensDigitField;
@property (nonatomic, strong) DigitField *carryHundredsDigitField;
@property (nonatomic, strong) DigitField *carryThousandsDigitField;
@property (nonatomic, strong) DigitField *zeroDigitField;
@property (nonatomic, assign) int multiplicand1;
@property (nonatomic, assign) int multiplicand2;
@property (nonatomic, assign) int currentMultiplicationArrayIndex;
@property (nonatomic, assign) int currentAdditionArrayIndex;
@property (nonatomic, strong) NSMutableArray *multiplicationArray; // the array of digit field pairs to be multiplied
@property (nonatomic, strong) NSMutableArray *additionArray;        // the array of digit field pairs to be added
@property (nonatomic, strong) NSMutableArray *hintArray;
@property (nonatomic, strong) NSMutableArray *carriedOverValArray;
@property (nonatomic, strong) NSMutableArray *multiplicand1DigitArray;
@property (nonatomic, strong) NSMutableArray *multiplicand2DigitArray;
@property (nonatomic, strong) NSString *hintsHeaderHtml;

- (IBAction)doNextStep:(id)sender;
- (IBAction)undoLastStep:(id)sender;
- (IBAction)getHint:(id)sender;
- (Operation *) getNextOp;
- (void) configureDigitFields;
- (void) disableAllDigitFields;
- (void) checkForCorrectEntry:(UITextField *)textField; 
- (void) clearCarryDigitFields;
- (void) populateCarryDigitFields:(int) value;
- (int) getCurrentCarryDecimalPosition;
- (NSString *) getFinalResultMessage;

@end
