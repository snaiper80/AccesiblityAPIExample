//
//  ATAppDelegate.h
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AXWindowManager;

@interface ATAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    AXWindowManager *axWinMgr;
}

@property (assign) IBOutlet NSWindow          *window;
@property (weak)   IBOutlet NSTableView       *tableView;

@end
