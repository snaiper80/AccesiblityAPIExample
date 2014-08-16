//
//  AXWindow.m
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import "AXWindow.h"
#import "AXWindowHelper.h"

@interface AXWindow () {
    AXUIElementRef mElement;
}

@end

@implementation AXWindow

- (instancetype)initWithElementRef:(AXUIElementRef)element
{
    self = [super init];
    if (self != nil)
    {
        mElement = element;
        
        [self getWindowAttributes];
    }
    
    return self;
}

- (void)dealloc
{
    CFRelease(mElement);
    mElement = NULL;
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:@"<AXWindow origin : %@, size : %@>",
            NSStringFromPoint(self.origin),
            NSStringFromSize(self.size)];
}

- (void)getWindowAttributes
{
    self.origin = [[AXWindowHelper originOfElement:mElement] pointValue];
    self.size   = [[AXWindowHelper sizeOfElement:mElement] sizeValue];
}

@end
