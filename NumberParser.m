//
//  NumberParser.m
//  MathHelp
//
//  Created by Dominic Surrao on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NumberParser.h"

@implementation NumberParser

/**
 Convert input integer into an number array of its digits;
 first element is ones, second element is tens, etc.
 */
- (NSMutableArray *) parseInteger : (int) iNumber {
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
	
	/* convert input integer to string so it can be parsed */
	NSString *stringValue = [[NSNumber numberWithInt:iNumber] stringValue];
    if ([stringValue length] > 0) {
        NSNumberFormatter *nFormat = NULL;
        NSRange strRange;
        NSString *stringRangeValue;
        for (int i = (int)[stringValue length] - 1; i >=0 ; i--) {
            if (nFormat == NULL) {
                nFormat = [[NSNumberFormatter alloc] init];
            }
            strRange = NSMakeRange(i, 1);
            stringRangeValue = [stringValue substringWithRange:strRange];
            [retArray addObject:[nFormat numberFromString:stringRangeValue]];
        }
    }
	
	return (retArray);
}

@end
