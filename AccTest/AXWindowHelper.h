//
//  AXWindowHelper.h
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXWindowHelper : NSObject

+ (NSValue *)originOfElement:(AXUIElementRef)element;
+ (NSValue *)sizeOfElement:(AXUIElementRef)element;

@end
