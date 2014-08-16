//
//  AXWindowManager.m
//  access_win
//
//  Created by snaiper on 2014. 8. 16..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import "AXWindowManager.h"

#import <AppKit/AppKit.h>
#import "AXApplication.h"
#import "AXWindow.h"

@interface AXWindowManager () {
    AXUIElementRef mSystemElementRef;
}

@end

@implementation AXWindowManager

- (instancetype)init {
    self = [super init];
    if (self)
    {
        [self initAX];
    }
    
    return self;
}

- (void)dealloc {
    
}

#pragma mark -

+ (BOOL)checkAccessbility
{
    NSDictionary *options = @{
        (__bridge id)kAXTrustedCheckOptionPrompt : (id)kCFBooleanFalse
    };
    
    if (!AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options))
    {
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert addButtonWithTitle:@"Open Security & Privacy Preferences"];
        [alert setMessageText:@"AccTest needs your permission to run"];
        [alert setInformativeText:
                @"Enable AccTest in Security & Privacy preferences -> Privacy -> Accessibility, in System Preferences."
                @"Then restart AccTest."];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert runModal];
        
        [[NSWorkspace sharedWorkspace] openFile:@"/System/Library/PreferencePanes/Security.prefPane"];
        
        [NSApp terminate:self];
        
        return NO;
    }
    
    return YES;
}

#pragma mark -


- (void)initAX
{
   if (!AXIsProcessTrusted())
    {
        NSLog(@"Not trusted");
    }
    
    mSystemElementRef = AXUIElementCreateSystemWide();
    NSAssert(mSystemElementRef != nil, @"System element must be not null");
}

- (void)uninitAX
{
    if (mSystemElementRef)
    {
        CFRelease(mSystemElementRef);
        mSystemElementRef = NULL;
    }
}

#pragma mark -

- (void)getFocusedWindows
{
    NSArray *allWindowsInfo = nil;
    CGWindowListOption options = kCGWindowListOptionOnScreenOnly & kCGWindowListExcludeDesktopElements;
    
    allWindowsInfo = (__bridge NSArray *)(CGWindowListCopyWindowInfo(options, kCGNullWindowID));
    if (allWindowsInfo == nil)
    {
        return ;
    }
    
    // filter real windows
    NSPredicate *windowPredicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *windowInfo, NSDictionary *bindings) {
        //NSLog(@"window info : %@", windowInfo);
        NSString *layer = (NSString *)windowInfo[(id)kCGWindowLayer];
        return [layer integerValue] == 0;
    }];
    
    allWindowsInfo = [allWindowsInfo filteredArrayUsingPredicate:windowPredicate];
    //NSLog(@"Real Windows : %@", allWindowsInfo);
    if ([allWindowsInfo count] == 0)
    {
        NSLog(@"Can't find front window");
        return ;
    }
    
    for (NSDictionary *aWindowInfo in allWindowsInfo)
    {
        AXApplication *application = [[AXApplication alloc] initWithWindowInfoDictionary:aWindowInfo];
        [application findFocusedWindow];
    }
}


@end
