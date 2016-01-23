//
//  NumberBox.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NumberBox.h"


@implementation NumberBox

-(NumberBox *) initWithTextFields:
	(UITextField *) iTextField: 
	(NumberBox *)iCarryNumberBox: 
	(NumberBox *)iLeftSiblingNumberBox {
	
	textField = iTextField;
	carryNumberBox = iCarryNumberBox;
	leftSiblingNumberBox = iLeftSiblingNumberBox;
	
	return self;
}

-(UITextField *) getTextField {
	return textField;
}

-(NumberBox *) getCarryNumberBox {
	return carryNumberBox;
}

-(NumberBox *) getLeftSiblingNumberBox {
	return leftSiblingNumberBox;
}

@end
