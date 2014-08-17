//
//  AXApplication.m
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import "AXApplication.h"
#import "AXWindow.h"

@interface AXApplication () {
    NSRunningApplication *mRunningApplication;
}

@end

@implementation AXApplication

- (instancetype)initWithWindowInfoDictionary:(NSDictionary *)aWindowInfoDictonary
{
    self = [super init];
    if (self != nil)
    {
        [self initializeWithWindowInfoDictionary:aWindowInfoDictonary];
        [self initializeOtherApplicationInfos];
    }
    
    return self;
}

#pragma mark - Private

- (void)initializeWithWindowInfoDictionary:(NSDictionary *)aWindowInfoDictonary
{
    NSRect rect;
    CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)[aWindowInfoDictonary objectForKey:(id)kCGWindowBounds],
                                           (struct CGRect *)&rect);
    self.rect = rect;
    
    self.pid      = [aWindowInfoDictonary[(id)kCGWindowOwnerPID] intValue];
    self.windowID = [aWindowInfoDictonary[(id)kCGWindowNumber] intValue];
    self.name     = aWindowInfoDictonary[(id)kCGWindowOwnerName];
}

- (void)initializeOtherApplicationInfos
{
    mRunningApplication = [NSRunningApplication runningApplicationWithProcessIdentifier:self.pid];
    self.iconImage      = mRunningApplication.icon;
}

#pragma mark - Public

- (BOOL)findFocusedWindow
{
    AXUIElementRef applicationRef = AXUIElementCreateApplication(self.pid);
    if (applicationRef == nil)
    {
        NSLog(@"Can't make a application ref");
        return NO;
    }
    
    AXUIElementRef  windowRef = nil;
    AXError         ret = kAXErrorFailure;
    
    ret = AXUIElementCopyAttributeValue(applicationRef,
                                        kAXFocusedWindowAttribute,
                                        (CFTypeRef *)&windowRef);
    if (ret != kAXErrorSuccess)
    {
        //NSLog(@"Fail : %d", ret);
        return NO;
    }
    
    self.focusedWindow = [[AXWindow alloc] initWithElementRef:windowRef];
    NSLog(@"[%@] Focused window : %@", self.name, self.focusedWindow);
    
    CFRelease(applicationRef);
    return YES;
}

@end
