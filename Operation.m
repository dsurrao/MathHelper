//
//  Operation.m
//  MathHelp
//
//  Created by Dominic Surrao on 7/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Operation.h"


@implementation Operation

- (int) execute {
	return 0;
}

- (void) undo {
}

- (NSString *) getHint {
	return @"";
}

- (int) checkForCorrectEntry:(UITextField *) iTextField {
	return 1;
}

- (void) enableTargetDigitFields {
}

- (void) disableTargetDigitFields {
}

- (void) clearTargetDigitFields {
}

- (int) getLeftOperand {
	return 0;
}

- (int) getRightOperand {
	return 0;
}

@end
