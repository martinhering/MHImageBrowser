//
//  ImageBrowserViewController.h
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MHImageBrowserImageItem;
@protocol MHImageBrowserViewControllerDataSource;


@interface MHImageBrowserViewController : NSViewController
@property (nonatomic) NSSize cellSize;
@property (nonatomic, readonly) NSScrollView* contentScrollView;

@property (nonatomic, strong) NSColor *backgroundColor;

@property (nonatomic, weak) IBOutlet id<MHImageBrowserViewControllerDataSource> dataSource;
@end

typedef NS_ENUM(NSInteger, MHImageBrowserImageItemRepresentationType) {
    MHImageBrowserImageItemRepresentationTypeURL,
    MHImageBrowserImageItemRepresentationTypeNSImage
};

@protocol MHImageBrowserImageItem <NSObject>
@property (nonatomic, strong, readonly) NSString* UID;
@property (nonatomic, assign, readonly) MHImageBrowserImageItemRepresentationType representationType;
@property (nonatomic, strong, readonly) id representation;
@property (nonatomic, assign, readonly) NSUInteger version;
@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* subtitle;
@property (nonatomic, assign, readonly, getter=isSelectable) BOOL selectable;
@end

@protocol MHImageBrowserViewControllerDataSource <NSObject>
@required
- (NSUInteger) numberOfGroupsInImageBrowser:(MHImageBrowserViewController *)imageBrowser;
- (NSUInteger) imageBrowser:(MHImageBrowserViewController *)imageBrowser numberOfItemsInGroup:(NSUInteger)group;
- (id <MHImageBrowserImageItem>) imageBrowser:(MHImageBrowserViewController *)imageBrowser itemAtIndexPath:(NSIndexPath*)indexPath;
@optional
@end
