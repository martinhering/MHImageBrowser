//
//  ImageBrowserViewController.h
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MHImageBrowserTypes.h"
#import "NSIndexPath+MHImageBrowser.h"

@protocol MHImageBrowserViewControllerDataSource;
@protocol MHImageBrowserViewControllerDelegate;

#pragma mark -

@interface MHImageBrowserViewController : NSViewController
@property (nonatomic) NSSize cellSize;
@property (nonatomic, readonly) NSScrollView* contentScrollView;
@property (nonatomic, weak) IBOutlet id<MHImageBrowserViewControllerDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<MHImageBrowserViewControllerDelegate> delegate;

@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, assign) MHImageBrowserCellStyle cellStyle;

//@property (nonatomic, strong) NSArray* selectedItems;

- (NSArray *)indexPathsForSelectedItems;
- (void)setSelectionIndexPathes:(NSArray*)indexPathes byExtendingSelection:(BOOL)extendSelection;

- (void) reloadData;
@end


#pragma mark -


@protocol MHImageBrowserViewControllerDataSource <NSObject>
@required
- (NSUInteger) numberOfGroupsInImageBrowser:(MHImageBrowserViewController *)imageBrowser;
- (NSUInteger) imageBrowser:(MHImageBrowserViewController *)imageBrowser numberOfItemsInGroup:(NSUInteger)group;
- (id <MHImageBrowserImageItem>) imageBrowser:(MHImageBrowserViewController *)imageBrowser itemAtIndexPath:(NSIndexPath*)indexPath;
@optional
- (NSDragOperation) imageBrowser:(MHImageBrowserViewController *)imageBrowser validateDrop:(id<NSDraggingInfo>)info proposedItemIndexPath:(NSIndexPath*)itemIndexPath proposedDropOperation:(MHImageBrowserViewDropOperation)operation;
- (BOOL) imageBrowser:(MHImageBrowserViewController *)imageBrowser acceptDrop:(id<NSDraggingInfo>)info itemIndexPath:(NSIndexPath*)indexPath dropOperation:(MHImageBrowserViewDropOperation)operation;
- (id<NSPasteboardWriting>) imageBrowser:(MHImageBrowserViewController *)imageBrowser pasteboardWriterForItemIndexPath:(NSIndexPath*)indexPath;
@end


@protocol MHImageBrowserViewControllerDelegate <NSObject>
@optional
- (void) imageBrowserSelectionDidChange:(MHImageBrowserViewController *)imageBrowser;
@end