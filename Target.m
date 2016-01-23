//
//  Target.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Target.h"


@implementation Target

-(Target *) initWithTextFields:
	(UITextField *) iTextField: 
	(UITextField *)iCarryTextField: 
	(UITextField *)iLeftSiblingTextField {
	
	textField = iTextField;
	carryTextField = iCarryTextField;
	leftSiblingTextField = iLeftSiblingTextField;
	
	return self;
}

-(UITextField *) getTextField {
	return textField;
}

@end
