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
    if (event.type == NSEventTypeLeftMouseDown) {
        NSIndexPath *iPath = [self.collectionView indexPathForItem:self];
        if ([self.collectionView.selectionIndexPaths containsObject:iPath]){
            [self processDeselect];
        }else{
            [self processSelect];
        }
    }
}

#pragma mark - Helpers
- (NSSet<NSIndexPath*>*) indexPathSet{
    NSIndexPath *iPath = [self.collectionView indexPathForItem:self];
    if (iPath == nil) {
        return [NSSet set];
    }
    return [NSSet setWithCollectionViewIndexPath:iPath];
}

- (void)processDeselect {
    [self.collectionView deselectItemsAtIndexPaths:self.indexPathSet];
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:didDeselectItemsAtIndexPaths:)]) {
        [self.collectionView.delegate collectionView:self.collectionView didDeselectItemsAtIndexPaths:self.indexPathSet];
    }
}

- (void)processSelect {
    [self.collectionView selectItemsAtIndexPaths:self.indexPathSet scrollPosition:NSCollectionViewScrollPositionNone];
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemsAtIndexPaths:)]) {
        [self.collectionView.delegate collectionView:self.collectionView didSelectItemsAtIndexPaths:self.indexPathSet];
    }
}
@end
