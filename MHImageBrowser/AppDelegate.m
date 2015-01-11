//
//  AppDelegate.m
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "AppDelegate.h"
#import "MHImageBrowserViewController.h"
#import "DemoImageItem.h"

@interface AppDelegate () <MHImageBrowserViewControllerDataSource>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet MHImageBrowserViewController* imageBrowserViewController;

@property (nonatomic, strong) NSArray* imageItems;
@end

@implementation AppDelegate

- (id) init
{
    if ((self = [super init])) {

    }
    return self;
}

- (void) awakeFromNib
{
    self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    self.window.backgroundColor = [NSColor blackColor];
    
    // Insert code here to initialize your application
    self.imageBrowserViewController.backgroundColor = [NSColor colorWithCalibratedWhite:0.15 alpha:1.];
    self.imageBrowserViewController.cellStyle = MHImageBrowserCellStyleTitled | MHImageBrowserCellStyleSelectionFollowsImageOutline;
    
    self.cellSizeValue = self.imageBrowserViewController.cellSize.width;
    
    [self generateImages];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (IBAction) reload:(id)sender
{
    [self.imageBrowserViewController reloadData];
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

- (void)generateImages
{
    NSMutableArray *imageItems = [NSMutableArray array];
    
    
    NSFileManager* fman = [NSFileManager defaultManager];
    NSString* dirPath = [@"~/Desktop/Photos" stringByExpandingTildeInPath];
    NSArray* content = [fman contentsOfDirectoryAtPath:dirPath error:nil];
    for(NSString* path in content) {
        NSString* fullpath = [dirPath stringByAppendingPathComponent:path];
        NSImage* image = [[NSImage alloc] initWithContentsOfFile:fullpath];
        if (image)
        {
            DemoImageItem* item = [[DemoImageItem alloc] init];
            item.UID = fullpath;
            item.representationType = MHImageBrowserImageItemRepresentationTypeURL;
            item.representation = [NSURL fileURLWithPath:fullpath];
            item.title = path;
            item.selectable = YES;
            
            [imageItems addObject:item];
        }
    }
    
    self.imageItems = imageItems;
}


#pragma mark - MHImageBrowserViewControllerDataSource

- (NSUInteger) numberOfGroupsInImageBrowser:(MHImageBrowserViewController *)imageBrowser
{
    return 1;
}

- (NSUInteger) imageBrowser:(MHImageBrowserViewController *)imageBrowser numberOfItemsInGroup:(NSUInteger)group
{
    return [self.imageItems count];
}

- (id <MHImageBrowserImageItem>) imageBrowser:(MHImageBrowserViewController *)imageBrowser itemAtIndexPath:(NSIndexPath*)indexPath
{
    return self.imageItems[[indexPath indexAtPosition:1]];
}
@end
