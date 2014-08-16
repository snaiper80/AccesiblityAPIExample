//
//  AXWindow.h
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXWindow : NSObject

@property (nonatomic, assign) NSPoint origin;
@property (nonatomic, assign) NSSize  size;

- (instancetype)initWithElementRef:(AXUIElementRef)element;

@end
