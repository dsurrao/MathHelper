//
//  IntegerAddition.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"

@interface IntegerAddition : Operation {
	int leftOperand;
	int rightOperand;
	UITextField *targetTextField;
	
}

- (IntegerAddition *) initWithOperands : (int)iLeftOperand : (int)iRightOperand : (UITextField *)iTargetTextField;

@end
