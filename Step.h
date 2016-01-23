//
//  Step.h
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Step : NSObject {

}

- (NSMutableArray *) doStep:(bool)silentFlag;
- (NSString *) getHint;
- (bool) checkForCorrectEntry:(UITextField *) textField;
- (bool) targetContainsTextField:(UITextField *) textField;
- (void) undo;

@end
