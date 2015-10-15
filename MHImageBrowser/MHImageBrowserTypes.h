//
//  MHImageBrowserTypes.h
//  MHImageBrowser
//
//  Created by Martin Hering on 10.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//


typedef NS_ENUM(NSInteger, MHImageBrowserCellStyle) {
    MHImageBrowserCellStyleDefault                      = 0,
    MHImageBrowserCellStyleTitled                       = 1,
    MHImageBrowserCellStyleSubtitled                    = 1 << 1,
    MHImageBrowserCellStyleSelectionFollowsImageOutline = 1 << 2,
};

#pragma mark - 

typedef NS_ENUM(NSInteger, MHImageBrowserImageItemRepresentationType) {
    MHImageBrowserImageItemRepresentationTypeURL,
    MHImageBrowserImageItemRepresentationTypeNSImage
};

@protocol MHImageBrowserImageItem <NSObject>
@property (nonatomic, strong, readonly) NSString* UID;
@property (nonatomic, assign, readonly) MHImageBrowserImageItemRepresentationType representationType;
@property (nonatomic, strong, readonly) id representation;
@property (nonatomic, assign, readonly) NSUInteger version;
@property (nonatomic, strong, readwrite) NSString* title;
@property (nonatomic, strong, readonly) NSString* subtitle;
@property (nonatomic, assign, readonly, getter=isSelectable) BOOL selectable;
@property (nonatomic, assign, readonly, getter=isTitleEditable) BOOL titleEditable;
@end

typedef NS_ENUM(NSInteger, MHImageBrowserViewDropOperation) {
    MHImageBrowserViewDropOn,
    MHImageBrowserViewDropAbove
};
