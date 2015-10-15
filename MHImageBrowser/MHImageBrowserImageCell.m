//
//  MHImageBrowserImageCell.m
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "_MHImageBrowserImageCell.h"
#import "MHImageBrowserPlaceHolderView.h"
#import "_MHImageBrowserCacheManager.h"

#import <QuartzCore/QuartzCore.h>

static void* const kObserverContextItemTitle = @"itemTitle";
static void* const kObserverContextItemTitleEditable = @"itemTitleEditable";

@interface MHImageBrowserImageCell () <NSTextFieldDelegate>
@property (nonatomic, strong) NSView* imageView;
@property (nonatomic, strong) NSView* selectionBackgroundView;
@property (nonatomic, strong) MHImageBrowserPlaceHolderView* placeholderView;
@property (nonatomic, strong, readwrite) NSTextField* titleTextField;

@property (nonatomic, strong) NSImage* imageValue;
@property (nonatomic, strong) NSString* titleValue;
@property (nonatomic, assign) NSUInteger thumbnailSize;
@property (nonatomic, strong) _MHImageBrowserCacheManager* cacheManager;
@end

@implementation MHImageBrowserImageCell

+ (Class) placeholderViewClass {
    return [MHImageBrowserPlaceHolderView class];
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        _selectionBackgroundView = [[NSView alloc] initWithFrame:frameRect];
        _selectionBackgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        _selectionBackgroundView.wantsLayer = YES;
        _selectionBackgroundView.layer.cornerRadius = 5.f;
        _selectionBackgroundView.layer.backgroundColor = [[NSColor colorWithRed:8/255. green:109/255. blue:214/255. alpha:1] CGColor];
        [self.contentView addSubview:_selectionBackgroundView];
        
        _placeholderView = [[[[self class] placeholderViewClass] alloc] initWithFrame:frameRect];
        _placeholderView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        _placeholderView.wantsLayer = YES;
        _placeholderView.hidden = YES;
        _placeholderView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
        [self.contentView addSubview:_placeholderView];
        
        _imageView = [[NSView alloc] initWithFrame:NSZeroRect];
        _imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        _imageView.wantsLayer = YES;
        [self.contentView addSubview:_imageView];
        
        _titleTextField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _titleTextField.autoresizingMask = NSViewWidthSizable | NSViewMaxYMargin;
        _titleTextField.wantsLayer = YES;
        _titleTextField.font = [NSFont systemFontOfSize:12];
        _titleTextField.hidden = YES;
        _titleTextField.backgroundColor = [NSColor redColor];
        _titleTextField.bezeled = NO;
        _titleTextField.alignment = NSCenterTextAlignment;
        _titleTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleTextField.editable = NO;
        _titleTextField.allowsExpansionToolTips = YES;
        _titleTextField.delegate = self;
        [self.contentView addSubview:_titleTextField];
    }
    return self;
}

- (void) dealloc
{
    self.itemValue = nil;
}

- (void) asyncRedraw
{
    [self.placeholderView setNeedsDisplay:YES];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
//    id<MHImageBrowserImageItem> item = self.itemValue;
//    if (item.representationType == MHImageBrowserImageItemRepresentationTypeURL)
//    {
//        NSURL* url = (NSURL*)item.representation;
//        if ([url isKindOfClass:[NSURL class]]) {
//            [[_MHImageBrowserCacheManager sharedManager] cancelGeneratingThumbnailForURL:url];
//        }
//    }
    
    self.placeholderView.hidden = NO;
    self.itemValue = nil;
}

- (void)layout {
    [super layout];
    
    NSRect bounds = self.bounds;
    NSRect rectangularBounds = NSMakeRect(0, NSHeight(bounds)-NSWidth(bounds), NSWidth(bounds), NSWidth(bounds));
    self.placeholderView.frame = rectangularBounds;
    
    NSRect imageViewRect = NSInsetRect(rectangularBounds, 5, 5);
    
    NSImage* image = (NSImage*)self.imageValue;
    if (image)
    {
        NSSize imageSize = [image size];
        CGFloat aspectRatio = imageSize.width / imageSize.height;

        if (imageSize.width >= imageSize.height) {
            NSRect scaledRect = imageViewRect;
            scaledRect.size.height = imageViewRect.size.width / aspectRatio;
            scaledRect.origin.y = NSMinY(rectangularBounds)+(imageViewRect.size.height - scaledRect.size.height) / 2 + 5;
            imageViewRect = scaledRect;
        }
        else
        {
            NSRect scaledRect = imageViewRect;
            scaledRect.size.width = imageViewRect.size.height * aspectRatio;
            scaledRect.origin.x = (imageViewRect.size.width - scaledRect.size.width) / 2 + 5;
            imageViewRect = scaledRect;
        }
    }
    
    if (self.style && MHImageBrowserCellStyleTitled) {
        self.titleTextField.hidden = NO;
        self.titleTextField.frame = NSMakeRect(5, NSMinY(rectangularBounds)-20, NSWidth(bounds)-10, 20);
    }
    else {
        self.titleTextField.hidden = YES;
    }
    
    [self _setBackgroundColors];
    
    
    if (!NSEqualRects(imageViewRect, self.imageView.frame)) {
        self.imageView.frame = imageViewRect;
        if (self.style & MHImageBrowserCellStyleSelectionFollowsImageOutline) {
            self.selectionBackgroundView.frame = NSInsetRect(imageViewRect, -5, -5);
        } else {
            self.selectionBackgroundView.frame = self.bounds;
        }
    }
}

- (void) _setBackgroundColors {
    if (!(self.style & MHImageBrowserCellStyleSelectionFollowsImageOutline)) {
        self.titleTextField.backgroundColor = (self.selected) ? [NSColor colorWithRed:8/255. green:109/255. blue:214/255. alpha:1] : self.collectionView.backgroundColor;
    } else {
        self.titleTextField.backgroundColor = self.collectionView.backgroundColor;
    }
}

- (void) _setImageValue
{
    id<MHImageBrowserImageItem> itemValue = self.itemValue;
    if (itemValue.representationType == MHImageBrowserImageItemRepresentationTypeNSImage) {
        self.imageValue = itemValue.representation;
    }
    else if (itemValue.representationType == MHImageBrowserImageItemRepresentationTypeURL)
    {
        NSURL* url = (NSURL*)itemValue.representation;
        if ([url isKindOfClass:[NSURL class]])
        {
            self.imageValue = [self.cacheManager cachedThumbnailForURL:url sizeClosestToSize:NSWidth(self.bounds)];
            __weak MHImageBrowserImageCell* weakSelf = self;
            [self.cacheManager generateThumbnailForURL:url size:NSWidth(self.bounds) completion:^(NSImage* thumbnail, BOOL async) {
                NSURL* myURL = (NSURL*)self.itemValue.representation;
                if (thumbnail && [myURL isEqual:url]) {
                    weakSelf.imageValue = thumbnail;
                    [weakSelf layout];
                }
            }];
        }
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kObserverContextItemTitle) {
        id<MHImageBrowserImageItem> itemValue = object;
        self.titleValue = itemValue.title;
    }
    else if (context == kObserverContextItemTitleEditable) {
        id<MHImageBrowserImageItem> itemValue = object;
        self.titleTextField.editable = (self.selected) ? itemValue.titleEditable : NO;
        
        // resign first responder in case it's currently editing
        if (!self.titleTextField.editable) {
            NSText* editor = [self.titleTextField.window fieldEditor:NO forObject:self.titleTextField];
            if (editor.superview.superview == self.titleTextField) {
                [self.titleTextField.window makeFirstResponder:self.collectionView];
            }
        }
    }
}

#pragma mark -


- (void) setItemValue:(id<MHImageBrowserImageItem>)itemValue
{
    if (_itemValue != itemValue) {
        
        if (_itemValue) {
            [(NSObject*)_itemValue removeObserver:self forKeyPath:@"title" context:kObserverContextItemTitle];
            [(NSObject*)_itemValue removeObserver:self forKeyPath:@"titleEditable" context:kObserverContextItemTitleEditable];
        }
        
        _itemValue = itemValue;
        
        if (!itemValue) {
            self.imageValue = nil;
            self.titleValue = nil;
        }
        else
        {
            self.titleValue = itemValue.title;
            
            [(NSObject*)itemValue addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:kObserverContextItemTitle];
            [(NSObject*)itemValue addObserver:self forKeyPath:@"titleEditable" options:NSKeyValueObservingOptionNew context:kObserverContextItemTitleEditable];
        }
    }
    if (itemValue) {
        [self _setImageValue];
        [self layout];
    }
}

- (void) setImageValue:(NSImage *)imageValue {
    if (_imageValue != imageValue) {
        _imageValue = imageValue;
        
        self.imageView.layer.contents = imageValue;
        self.imageView.layer.backgroundColor = self.layer.backgroundColor;
        self.placeholderView.hidden = (imageValue != nil);
    }
}

- (void) setTitleValue:(NSString *)titleValue
{
    if (_titleValue != titleValue) {
        _titleValue = titleValue;
        self.titleTextField.stringValue = (titleValue) ? titleValue : @"";
    }
}

- (void) setThumbnailSize:(NSUInteger)thumbnailSize
{
    if (_thumbnailSize != thumbnailSize) {
        _thumbnailSize = thumbnailSize;
        [self _setImageValue];
    }
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self _setBackgroundColors];
    self.selectionBackgroundView.hidden = !selected;
    
    self.titleTextField.editable = (selected) ? self.itemValue.titleEditable : NO;
    if (!self.titleTextField.editable) {
        NSText* editor = [self.titleTextField.window fieldEditor:NO forObject:self.titleTextField];
        if (editor.superview.superview == self.titleTextField) {
            [self.titleTextField.window makeFirstResponder:self.collectionView];
        }
    }
}

#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
    if (command == @selector(insertNewline:)) {
        self.itemValue.title = [[[textView textStorage] string] copy];
        [textView.window makeFirstResponder:self.collectionView];
        return YES;
    }
    return NO;
}
@end
