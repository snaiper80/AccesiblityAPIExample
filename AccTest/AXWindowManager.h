//
//  AXWindowManager.h
//  access_win
//
//  Created by snaiper on 2014. 8. 16..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXWindowManager : NSObject {
    
}

@property (strong) NSArray *applications;

+ (BOOL)checkAccessbility;

- (void)findApplicationsAndFocusedWindow;

@end
