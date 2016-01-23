//
//  DigitBox.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DigitBox : NSObject {
	UITextField *textField;
	DigitBox *carryNumberBox;
	NumberBox *leftSiblingNumberBox;
	
}

-(NumberBox *) initWithTextField: (UITextField *) iTextField;
-(UITextField *) getTextField;
-(NumberBox *) getCarryNumberBox;
-(NumberBox *) getLeftSiblingNumberBox;
-(void) setCarryNumberBox: (NumberBox *) iCarryNumberBox;
-(void) setLeftSiblingNumberBox: (NumberBox *) iLeftSiblingNumberBox;


@end
