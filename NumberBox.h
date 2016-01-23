//
//  NumberBox.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NumberBox : NSObject {
	UITextField *textField;
	NumberBox *carryNumberBox;
	NumberBox *leftSiblingNumberBox;
}

-(NumberBox *) initWithTextField: (UITextField *) iTextField;
-(UITextField *) getTextField;
-(NumberBox *) getCarryNumberBox;
-(NumberBox *) getLeftSiblingNumberBox;
-(void) setCarryNumberBox: (NumberBox *) iCarryNumberBox;
-(void) setLeftSiblingNumberBox: (NumberBox *) iLeftSiblingNumberBox;

@end

