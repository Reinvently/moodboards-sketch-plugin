//
//  PhotoCollectionViewItem.m
//  SketchPlugin
//
//  Created by Boyko Andrey on 4/10/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "PhotoCollectionViewItem.h"

@interface PhotoCollectionViewItem ()
@property(strong) IBOutlet NSImageView *checkBox;
@end

@implementation PhotoCollectionViewItem
#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setSelected:NO];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageView.layer.borderWidth = selected ? 2 : 0;
    self.imageView.layer.borderColor = [NSColor redColor].CGColor;
    self.checkBox.hidden = !selected;
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];

    if ((self.isSelected) && (event.type == NSEventTypeLeftMouseDown)) {
        [self processDeselect];
    }
}

#pragma mark - Helpers

- (void)processDeselect {
    NSIndexPath *iPath = [self.collectionView indexPathForItem:self];
    if (iPath == nil) {
        return;
    }
    NSSet *indexPathSet = [NSSet setWithCollectionViewIndexPath:iPath];
    [self.collectionView deselectItemsAtIndexPaths:indexPathSet];
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:didDeselectItemsAtIndexPaths:)]) {
        [self.collectionView.delegate collectionView:self.collectionView didDeselectItemsAtIndexPaths:indexPathSet];
    }
}
@end
