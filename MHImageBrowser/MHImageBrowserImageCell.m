//
//  MHImageBrowserImageCell.m
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "MHImageBrowserImageCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MHImageBrowserImageCell ()
@property (nonatomic, strong) NSView* imageView;
@property (nonatomic, strong) NSView* selectionBackgroundView;
@end

@implementation MHImageBrowserImageCell

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        _selectionBackgroundView = [[NSView alloc] initWithFrame:frameRect];
        _selectionBackgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        _selectionBackgroundView.wantsLayer = YES;
        _selectionBackgroundView.layer.cornerRadius = 5.f;
        [self.contentView addSubview:_selectionBackgroundView];
        
        _imageView = [[NSView alloc] initWithFrame:frameRect];
        _imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        _imageView.wantsLayer = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.objectValue = nil;
}

- (void)layout {
    [super layout];
    
    CGRect imageViewRect = NSInsetRect(self.bounds, 5, 5);
    if (!NSEqualRects(imageViewRect, self.imageView.frame)) {
        self.imageView.frame = imageViewRect;
    }
}


- (void) setObjectValue:(id)objectValue
{
    if (_objectValue != objectValue) {
        _objectValue = objectValue;
        
        NSImage* image = (NSImage*)objectValue;
        self.imageView.layer.contents = image;
        self.imageView.layer.backgroundColor = self.layer.backgroundColor;
    }
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.selectionBackgroundView.layer.backgroundColor = (selected) ? [[NSColor colorWithRed:8/255. green:109/255. blue:214/255. alpha:1] CGColor] : [[NSColor clearColor] CGColor];
}


@end
