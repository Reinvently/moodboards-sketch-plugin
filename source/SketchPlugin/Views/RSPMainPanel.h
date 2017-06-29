//
//  RSPMainPanel.h
//  SketchPlugin
//
//  Created by aboyko on 6/20/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RSPButton.h"

@protocol RSPMainPanelDelegate;

@interface RSPMainPanel : NSPanel
///
/// Delegate
@property(weak) id <RSPMainPanelDelegate> panelDelegate;
///
/// Outlets
@property(strong) IBOutlet NSTextField *searchTextField;
@property(strong) IBOutlet RSPButton *button;
@property(strong) IBOutlet NSCollectionView *collectionView;
@property(strong) IBOutlet NSLayoutConstraint *expandedHeightConstraint;
@property(strong) IBOutlet NSLayoutConstraint *expandedWidthConstraint;
@property(strong) IBOutlet NSStackView *radioStackView;
@property(strong) IBOutlet NSTextField *artboardGridTypeHintLabel;
@property(strong) IBOutlet NSTextField *selectedImageHintLabel;
@property(strong) IBOutlet RSPButton *generateArtboardButton;
@property(strong) IBOutlet NSView *searchForm;
@property(strong) IBOutlet NSProgressIndicator *activityIndicator;

///
/// Start activity indication
- (void)startActivityIndication;

///
/// Stop activity indication
- (void)stopActivityIndication;

///
/// Expand/Collapse Panel
/// @param expand Expand
- (void)expandPanel:(BOOL)expand;
@end

@protocol RSPMainPanelDelegate <NSObject>
///
/// Notify delegate about changing of search query
/// @param panel Sender
/// @param newSearchQuery New search query
- (void)mainPanel:(RSPMainPanel *)panel didChangeSearchQuery:(NSString *)newSearchQuery;
@end
