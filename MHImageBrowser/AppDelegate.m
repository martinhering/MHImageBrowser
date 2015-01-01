//
//  AppDelegate.m
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "AppDelegate.h"
#import "MHImageBrowserViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet MHImageBrowserViewController* imageBrowserViewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.cellSizeValue = self.imageBrowserViewController.cellSize.width;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void) setCellSizeValue:(CGFloat)cellSizeValue
{
    if (_cellSizeValue != cellSizeValue) {
        _cellSizeValue = cellSizeValue;
        
        self.imageBrowserViewController.cellSize = NSMakeSize(cellSizeValue, cellSizeValue);
    }
}
@end
