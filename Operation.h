//
//  Operation.h
//  MathHelp
//
//  Created by Dominic Surrao on 7/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Operation : NSObject {

}

- (int) execute;
- (void) undo;
- (NSString *) getHint;
- (int) checkForCorrectEntry:(UITextField *) iTextField;
- (void) enableTargetDigitFields;
- (void) disableTargetDigitFields;
- (void) clearTargetDigitFields;
- (int) getLeftOperand;
- (int) getRightOperand;

@end

