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

@implementation ATAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    if ([AXWindowManager checkAccessbility] == NO)
        return ;
    
    // Initialize Window Manager
    axWinMgr = [[AXWindowManager alloc] init];
    [axWinMgr findApplicationsAndFocusedWindow];
    
    // Register hot key
    [self registerHotKey];
    
    // Load from found applications that has a focused window.
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
