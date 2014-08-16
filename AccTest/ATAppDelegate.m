//
//  ATAppDelegate.m
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import "ATAppDelegate.h"
#import "AXWindowManager.h"

@implementation ATAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    if ([AXWindowManager checkAccessbility] == NO)
        return ;
    
    axWinMgr = [[AXWindowManager alloc] init];
    [axWinMgr getFocusedWindows];
}

@end
