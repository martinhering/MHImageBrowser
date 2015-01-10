//
//  ImageBrowserViewController.h
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MHImageBrowserTypes.h"

@protocol MHImageBrowserViewControllerDataSource;

@interface MHImageBrowserViewController : NSViewController
@property (nonatomic) NSSize cellSize;
@property (nonatomic, readonly) NSScrollView* contentScrollView;
@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, assign) MHImageBrowserCellStyle cellStyle;
@property (nonatomic, weak) IBOutlet id<MHImageBrowserViewControllerDataSource> dataSource;

- (void) reloadData;
@end


#pragma mark -


@protocol MHImageBrowserViewControllerDataSource <NSObject>
@required
- (NSUInteger) numberOfGroupsInImageBrowser:(MHImageBrowserViewController *)imageBrowser;
- (NSUInteger) imageBrowser:(MHImageBrowserViewController *)imageBrowser numberOfItemsInGroup:(NSUInteger)group;
- (id <MHImageBrowserImageItem>) imageBrowser:(MHImageBrowserViewController *)imageBrowser itemAtIndexPath:(NSIndexPath*)indexPath;
@optional
@end
