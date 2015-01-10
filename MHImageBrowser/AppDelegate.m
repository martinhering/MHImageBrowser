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
    NSString* dirPath = [@"~/Desktop/Neue Bilder" stringByExpandingTildeInPath];
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
    
//    NSInteger numberOfImages = 30;
//    NSMutableArray *imageItems = [NSMutableArray array];
//    
//    for (int i = 0; i < numberOfImages; i++) {
//        
//        // Just get a randomly-tinted template image.
//        NSImage *image = [NSImage imageWithSize:CGSizeMake(150.f, 150.f) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
//            [[NSImage imageNamed:NSImageNameUser] drawInRect:dstRect fromRect:CGRectZero operation:NSCompositeSourceOver fraction:1];
//            
//            CGFloat hue = arc4random() % 256 / 256.0;
//            CGFloat saturation = arc4random() % 128 / 256.0 + 0.5;
//            CGFloat brightness = arc4random() % 128 / 256.0 + 0.5;
//            NSColor *color = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:1];
//            
//            [color set];
//            NSRectFillUsingOperation(dstRect, NSCompositeDestinationAtop);
//            
//            return YES;
//        }];
//        
//        DemoImageItem* item = [[DemoImageItem alloc] init];
//        item.UID = [@(i) stringValue];
//        item.representationType = MHImageBrowserImageItemRepresentationTypeNSImage;
//        item.representation = image;
//        item.title = @"test";
//        item.selectable = YES;
//        
//        [imageItems addObject:item];
//    }
    
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
