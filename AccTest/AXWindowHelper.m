//
//  AXWindowHelper.m
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import "AXWindowHelper.h"

@implementation AXWindowHelper

+ (NSValue *)originOfElement:(AXUIElementRef)element
{
    NSValue   *value = nil;
    CGPoint    rawValue;
    CFTypeRef  originRef;
    AXError    ret = AXUIElementCopyAttributeValue(element, kAXPositionAttribute, &originRef);
    
    if (ret != kAXErrorSuccess)
    {
        NSLog(@"Get position error : %d", ret);
        return nil;
    }
    
    if (AXValueGetType(originRef) == kAXValueCGPointType)
    {
        AXValueGetValue(originRef, kAXValueCGPointType, &rawValue);
        
        value = [NSValue valueWithPoint:rawValue];
    }
    else
    {
        NSLog(@"Type error : %@", (CFTypeRef)AXValueGetType(originRef));
    }
    
    CFRelease(originRef);
    
    return value;
}

+ (NSValue *)sizeOfElement:(AXUIElementRef)element
{
    NSValue   *value = nil;
    CGSize     rawValue;
    CFTypeRef  sizeRef;
    AXError    ret = AXUIElementCopyAttributeValue(element, kAXSizeAttribute, &sizeRef);
    
    if (ret != kAXErrorSuccess)
    {
        NSLog(@"Get Size error : %d", ret);
        return nil;
    }
    
    if (AXValueGetType(sizeRef) == kAXValueCGSizeType)
    {
        AXValueGetValue(sizeRef, kAXValueCGSizeType, &rawValue);
        
        value = [NSValue valueWithSize:rawValue];
    }
    else
    {
        NSLog(@"Type error : %@", (CFTypeRef)AXValueGetType(sizeRef));
    }
    
    CFRelease(sizeRef);
    
    return value;
}

@end
