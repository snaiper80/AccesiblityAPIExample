//
//  AXApplication.h
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXWindow;

@interface AXApplication : NSObject

@property (nonatomic, assign) pid_t     pid;
@property (nonatomic, assign) int       windowID;
@property (nonatomic, assign) NSRect    rect;
@property (nonatomic, assign) NSString *name;

@property (nonatomic, strong) AXWindow *focusedWindow;

- (instancetype)initWithWindowInfoDictionary:(NSDictionary *)aWindowInfoDictonary;

- (BOOL)findFocusedWindow;

@end
