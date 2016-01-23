//
//  Target.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Target : NSObject {
	UITextField *textField;
	UITextField *carryTextField;
	UITextField *leftSiblingTextField;
}

-(Target *) initWithTextFields:
	(UITextField *) iTextField: 
	(UITextField *) iCarryTextField: 
	(UITextField *) iLeftSiblingTextField;

-(UITextField *) getTextField;

@end
