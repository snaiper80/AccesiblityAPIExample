//
//  ATAppDelegate.m
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import "ATAppDelegate.h"
#import <Carbon/Carbon.h>

#import "AXWindowManager.h"
#import "AXApplication.h"

#import "DDHotKeyCenter.h"

@interface ATAppDelegate () {
    NSImageView *mScreenShotView;
    NSWindow    *mScreentShotWindow;
}

@end

@implementation ATAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    if ([AXWindowManager checkAccessbility] == NO)
        return ;
    
    // To bring your app to the front
    [NSApp activateIgnoringOtherApps:YES];
    
    // create a another window
    NSRect windowRect = NSMakeRect(10.0f, 10.0f, 800.0f, 600.0f);
    mScreentShotWindow = [[NSWindow alloc] initWithContentRect:windowRect
                                                     styleMask:( NSResizableWindowMask | NSClosableWindowMask | NSTitledWindowMask)
                                                       backing:NSBackingStoreBuffered
                                                         defer:NO];
    
    NSScrollView *scrollview = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, 800, 600)];
    [scrollview setHasVerticalScroller:YES];
    [scrollview setAcceptsTouchEvents:YES];
    [mScreentShotWindow setContentView:scrollview];
    
    // Initialize Window Manager
    axWinMgr = [[AXWindowManager alloc] init];
    [axWinMgr findApplicationsAndFocusedWindow];
    
    // Register hot key
    [self registerHotKey];
    
    // Load from found applications that has a focused window.
    [self.tableView setTarget:self];
    [self.tableView setDoubleAction:@selector(doubleClicked:)];
    [self.tableView reloadData];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    [self unregisterHotKey];
    
    return NSTerminateNow;
}

#pragma mark - TableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [axWinMgr.applications count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString        *identifer = [tableColumn identifier];
    AXApplication   *app       = [axWinMgr.applications objectAtIndex:row];
    
    NSTableCellView *cellView  = [tableView makeViewWithIdentifier:identifer owner:self];
    cellView.textField.stringValue = [NSString stringWithFormat:@"%@ (%@)", app.name, app.focusedWindow];
    cellView.imageView.image = app.iconImage;
    
    return cellView;
}

#pragma mark - TableView Event

- (void)doubleClicked:(NSTableView *)aSender
{
    NSInteger row = [aSender clickedRow];
    if (row == NSNotFound)
        return ;
    
    if (mScreenShotView != nil)
    {
        [mScreenShotView removeFromSuperview];
        mScreenShotView = nil;
    }
    
    AXApplication *app        = [axWinMgr.applications objectAtIndex:row];
    NSImage       *screenShot = [app createImageSnapshot];
    NSSize         shotSize   = [screenShot size];
    
    if (shotSize.width > 1 && shotSize.height > 1)
    {
        NSLog(@"Screen Shot : %@", screenShot);
        
        NSImageView *shotView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, shotSize.width, shotSize.height)];
        [shotView setImageScaling:NSImageScaleProportionallyUpOrDown];
        [shotView setImage:screenShot];
        
        // size to fit contents (screen shot image)
        [mScreentShotWindow setContentAspectRatio:shotSize];
        [mScreentShotWindow setContentSize:shotSize];
        
        [mScreentShotWindow.contentView addSubview:shotView];
        [mScreentShotWindow makeKeyAndOrderFront:nil];
        
        mScreenShotView = shotView;
    }
}

#pragma mark - Hotkey

- (void)registerHotKey
{
    // ⌘⌥⌃V를 Hot Key로 등록 (Ctrl+Cmd+Space로 입력 가능)
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
	if ([c registerHotKeyWithKeyCode:kVK_ANSI_V
                       modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)
                              target:self
                              action:@selector(hotkeyWithEvent:object:)
                              object:nil] != nil)
    {
        NSLog(@"Registering Hot Key is SUCCESSFUL");
    }
    else
    {
        NSLog(@"Registering Hot Key is FAILED");
    }
}

- (void)unregisterHotKey
{
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
	[c unregisterHotKeyWithKeyCode:kVK_ANSI_V
                     modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)];
	
    NSLog(@"Unregistering Hot Key is SUCESSFUL");
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent object:(id)anObject
{
    NSLog(@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"Hotkey event: %@", hkEvent);
    NSLog(@"Object: %@", anObject);
}

@end
