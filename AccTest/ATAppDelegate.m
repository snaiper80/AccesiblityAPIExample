//
//  ATAppDelegate.m
//  AccTest
//
//  Created by snaiper on 2014. 8. 17..
//  Copyright (c) 2014년 snaiper. All rights reserved.
//

#import "ATAppDelegate.h"
#import "AXWindowManager.h"
#import "AXApplication.h"

@implementation ATAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    if ([AXWindowManager checkAccessbility] == NO)
        return ;
    
    axWinMgr = [[AXWindowManager alloc] init];
    [axWinMgr findApplicationsAndFocusedWindow];
    
    [self.tableView reloadData];
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


@end
