//
//  Step.m
//  MathHelp
//
//  Created by Dominic Surrao on 6/4/11.
//  Copyright 2011 MathHelp. All rights reserved.
//

#import "Step.h"


@implementation Step

- (NSMutableArray *) doStep:(bool)silentFlag {
	return ([[NSMutableArray alloc] init]);
}

- (NSString *) getHint {
	return @"";
}

- (bool) checkForCorrectEntry:(UITextField *)textField {
	return true;
}

- (bool) targetContainsTextField:(UITextField *)textField {
	return false;
}

- (void) undo {
}

@end
