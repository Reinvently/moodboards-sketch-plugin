//
//  RSPSketchService.m
//  SketchPlugin
//
//  Created by Boyko Andrey on 3/25/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "RSPSketchService.h"
//please find interfaces for Sketch http://developer.sketchapp.com/reference/api/ and  https://github.com/abynim/Sketch-Headers
#import "Macros.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wall"
#pragma clang diagnostic ignored "-Wconditional-type-mismatch"

#import "MSDocument.h"
#import "MSPage.h"
#import "MSArtboardGroup.h"
#import "MSRect.h"
#import "MSBitmapLayer.h"
#import "MSImageData.h"

#pragma clang diagnostic pop

#define RSPClass(className)  (NSClassFromString([NSString stringWithUTF8String:#className]))

NS_ASSUME_NONNULL_BEGIN

@implementation RSPSketchService

#pragma mark - Public

///
/// Create moodboards
/// @param items Images
/// @param moodboardConfig Configuration
/// @param document parent document
- (void)createMoodboardsWithItems:(NSArray<RSPItem *> *)items
                  moodboardConfig:(RSPMoodboardConfig)moodboardConfig
                         document:(MSDocument *)document {

    if (items.count == 0) {
        return;
    }

    //calc sizes for items
    NSUInteger imagesPerArtboard = (NSUInteger) (moodboardConfig.artboardGridSize.width * moodboardConfig.artboardGridSize.height);
    CGSize defaultSizeWithInsets = CGSizeMake(moodboardConfig.imageSize.width + moodboardConfig.imagesInsets.left + moodboardConfig.imagesInsets.right,
            moodboardConfig.imageSize.height + moodboardConfig.imagesInsets.top + moodboardConfig.imagesInsets.bottom);
    CGSize artboardSize = CGSizeMake(defaultSizeWithInsets.width * moodboardConfig.artboardGridSize.width,
            moodboardConfig.artboardGridSize.height * defaultSizeWithInsets.height);

    //create new page
    MSPage *currentPage = [self createPageWithName:RSPLocalizedString(@"Moodboard") document:document];

    __block MSArtboardGroup *newArtboard = nil;
    __block NSUInteger artboardIndex = 0;

    [items enumerateObjectsUsingBlock:^(RSPItem *obj, NSUInteger idx, BOOL *stop) {

        if (idx % imagesPerArtboard == 0) {
            //Create new artboard
            CGRect newArtboardFrame = [self frameForItemWithSize:artboardSize
                                                       itemIndex:artboardIndex
                                                        gridSize:moodboardConfig.moodboardGridSize
                                                      itemInsets:moodboardConfig.artboardInsets];

            newArtboard = [self createArtboardWithName:[NSString stringWithFormat:RSPLocalizedString(@"Moodboard %li"), artboardIndex + 1]
                                                 frame:newArtboardFrame
                                                  page:currentPage];
            artboardIndex++;
        }

        //create items for newArtboard
        idx = idx % imagesPerArtboard;
        CGRect newItemFrame = [self frameForItemWithSize:moodboardConfig.imageSize
                                               itemIndex:idx
                                                gridSize:moodboardConfig.artboardGridSize
                                              itemInsets:moodboardConfig.imagesInsets];

        NSString *fullName = [NSString stringWithFormat:@"%@ %@", obj.name ?: @"", obj.itemURLString ?: @""];
        [self createImageLayerWithName:fullName frame:newItemFrame imageURL:obj.imgURL artboard:newArtboard];
    }];


}

#pragma mark - Helpers

/// Calculate frame for item (Artboard or Image ) in the grid
/// @param itemSize Size of item
/// @param itemIndex Index in grid
/// @param gridSize Grid Size
/// @param insets Insets between items
/// @return Frame
- (CGRect)frameForItemWithSize:(CGSize)itemSize
                     itemIndex:(NSUInteger)itemIndex
                      gridSize:(CGSize)gridSize
                    itemInsets:(NSEdgeInsets)insets {
    CGRect resultFrame = CGRectZero;
    NSUInteger columnNumber = (NSUInteger) gridSize.width;
    NSUInteger line = itemIndex / columnNumber;
    NSUInteger column = itemIndex % columnNumber;

    CGSize sizeWithInsets = CGSizeMake(itemSize.width + insets.left + insets.right, itemSize.height + insets.top + insets.bottom);

    resultFrame.origin.x = insets.left + column * (sizeWithInsets.width);
    resultFrame.origin.y = insets.top + line * (sizeWithInsets.height);
    resultFrame.size = itemSize;

    return resultFrame;
}

///
/// Create a new Artboard
/// @param name Name
/// @param frame Frame
/// @param page Parent page
/// @return new Artboard
- (MSArtboardGroup *)createArtboardWithName:(NSString *)name frame:(CGRect)frame page:(MSPage *)page {
    MSArtboardGroup *newArtboard = [(MSArtboardGroup *) [RSPClass(MSArtboardGroup) alloc] initWithFrame:frame];

    newArtboard.name = name;
    [page addLayer:newArtboard];

    return newArtboard;
}

///
/// Create a new Image
/// @param name Name
/// @param frame Frame
/// @param imageURL Image url
/// @param artboard Parent Artboard
/// @return new Image
- (MSBitmapLayer *)createImageLayerWithName:(NSString *)name frame:(CGRect)frame imageURL:(NSURL *)imageURL artboard:(MSArtboardGroup *)artboard {
    MSBitmapLayer *newImage = [(MSBitmapLayer *) [RSPClass(MSBitmapLayer) alloc] initWithFrame:frame];

    newImage.name = name;
    [artboard addLayer:newImage];

    NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageURL];
    MSImageData *msImage = [(MSImageData *) [RSPClass(MSImageData) alloc] initWithImage:image convertColorSpace:YES];

    newImage.image = msImage;
    return newImage;
}

/// Create a new Page
/// @param name Name
/// @param document Document
/// @return new Page
- (MSPage *)createPageWithName:(NSString *)name document:(MSDocument *)document {
    MSPage *newPage = [document addBlankPage];

    newPage.name = name;
    [document setCurrentPage:newPage];

    return newPage;
}
@end

NS_ASSUME_NONNULL_END
