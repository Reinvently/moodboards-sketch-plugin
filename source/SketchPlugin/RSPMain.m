//
//  RSPMain.m
//  SketchPlugin
//
//  Created by aboyko on 3/6/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

@import AppKit;
@import Foundation;
#import "RSPMain.h"
#import "RSPSketchService.h"
#import "RSPBehanceService.h"
#import "RSPMainPanelViewModel.h"
#import "RSPLogger.h"
#import "RSPMainPanel.h"
#import "MPGoogleAnalyticsTracker.h"
#import "MPAnalyticsConfiguration.h"
NS_ASSUME_NONNULL_BEGIN

@interface RSPMain () <CollectionViewDataSourceDelegate, RSPMainPanelDelegate>

@property(strong) RSPMainPanelViewModel *viewModel;
@property(strong) RSPBehanceService *behanceService;
@property(strong) RSPSketchService *sketchService;
@end

@implementation RSPMain
#pragma mark - Public

///
/// Entry point
/// @param context Sketch Context
- (void)run:(NSDictionary *)context {
    //set up logger
    RSPLogger.sharedLogger.textView = self.textView;
    RSPLog(NSLocalizedString(@"Init plugin", @""));

    //load view
    [self loadViews];

    //setup services
    self.document = context[DOCUMENT_KEY];
    self.behanceService = [RSPBehanceService new];
    self.sketchService = [RSPSketchService new];
    //Set state
    self.viewModel = [[RSPMainPanelViewModel alloc] initWithCollectionView:self.mainPanel.collectionView delegate:self];
    [self updateState];
    [self setUpAnalytics];
}

#pragma mark - Logic

///
/// Generate new moodboard
- (void)generateMoodboard {
    NSUInteger selectedItemsCount = self.viewModel.dataSource.selectedItems.count;
    [MPGoogleAnalyticsTracker trackEventOfCategory:@"Plugin" action:@"GenerateMoodboard"
                                             label:self.viewModel.query value:@(selectedItemsCount)];
    
    [self.mainPanel startActivityIndication];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sketchService createMoodboardsWithItems:self.viewModel.dataSource.selectedItems
                                      moodboardConfig:self.viewModel.moodboardConfig
                                             document:self.document];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainPanel stopActivityIndication];
            [self.mainPanel close];
        });
    });
}

///
/// Generate Preview
- (void)generatePreview {
    [MPGoogleAnalyticsTracker trackEventOfCategory:@"Plugin" action:@"GeneratePreview"
                                             label:self.viewModel.query value:@1];
    
    //prepare params
    [self.mainPanel expandPanel:YES];
    [self.viewModel resetPage];
    [self.behanceService getItems:self.viewModel.query page:self.viewModel.page completionHandler:^(NSArray<RSPItem *> *urls, NSError *error) {
        [self handleNewItems:urls reset:YES error:error];
    }];
}

///
/// @param urls  fetched items
/// @param reset Should clear data source
/// @param error error
- (void)handleNewItems:(NSArray<RSPItem *> *)urls reset:(BOOL)reset error:(NSError *)error {
    if (error) {
        [self handleError:error];
        return;
    }

    if (reset) {
        self.viewModel.dataSource.items = urls;
    } else {
        [self.viewModel.dataSource addItems:urls];
    }

}

///
/// Change Artboard Type
/// @param type Grid type
- (void)didChangeArtboardGridType:(RSPArtboardGridType)type {
    self.viewModel.artboardGridType = type;
    [self updateState];
}

///
/// Search query has been changed
- (void)didChangeSearchQuery:(nullable NSString *)newQuery {
    self.viewModel.query = newQuery ?: @"";
    [self updateState];
}

///
/// Update view state
- (void)updateState {
    self.mainPanel.button.enabled = self.viewModel.isSearchImagesEnabled;
    self.mainPanel.generateArtboardButton.enabled = self.viewModel.isGenerateArtboardEnabled;
    self.mainPanel.artboardGridTypeHintLabel.stringValue = self.viewModel.artboardGridHintText;
    for (NSButton *button in self.mainPanel.radioStackView.arrangedSubviews) {
        button.state = [self.viewModel buttonStateForArtboardType:(RSPArtboardGridType) button.tag];
    }
}

///
/// Present error
/// @param error Error
- (void)handleError:(NSError *)error {
    NSAlert *alert = [NSAlert alertWithError:error];
    [alert runModal];
}

#pragma mark - Views

///
/// Load toolbar from Nib and setup outlets
- (void)loadViews {
    NSMutableDictionary *threadDictionary = NSThread.mainThread.threadDictionary;
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [bundle loadNibNamed:MAIN_NIB owner:self topLevelObjects:nil];
    NSPanel *mainToolBar = self.mainPanel;
    self.mainPanel.panelDelegate = self;

#ifdef DEBUG
    [self.debugPanel center];
    [self.debugPanel makeKeyAndOrderFront:nil];
    threadDictionary[DEBUG_PANEL_THREAD_KEY] = self.debugPanel;
#else
    [self.debugPanel close];
#endif
    [mainToolBar becomeKeyWindow];
    mainToolBar.level = NSFloatingWindowLevel;
    [mainToolBar center];
    [mainToolBar makeKeyAndOrderFront:nil];
    threadDictionary[PANEL_THREAD_KEY] = mainToolBar;
    threadDictionary[PROCESS_THREAD_KEY] = self;
    RSPLog(NSLocalizedString(@"Did load views", @""));
}

- (void)setUpAnalytics{
    MPAnalyticsConfiguration *configuration = [[MPAnalyticsConfiguration alloc] initWithAnalyticsIdentifier:@"UA-101345182-1"];
    [MPGoogleAnalyticsTracker activateConfiguration:configuration];
    [MPGoogleAnalyticsTracker trackEventOfCategory:@"Plugin" action:@"Launch"
                                             label:nil value:@1];
}
#pragma mark - User interaction

///
/// User pressed on generate preview
/// @param sender Sender
- (IBAction)generatePreviewPressed:(nullable id)sender {
    [self generatePreview];
}

///
/// User pressed generate moodboard
/// @param sender Sender
- (IBAction)generateMoodboardPressed:(nullable id)sender {
    [self generateMoodboard];
}

///
/// User selected Grid type
/// @param sender Sender
- (IBAction)radioButtonPressed:(NSButton *)sender {
    [self didChangeArtboardGridType:(RSPArtboardGridType) sender.tag];
}

#pragma mark - Main panel delegate

- (void)mainPanel:(RSPMainPanel *)panel didChangeSearchQuery:(NSString *)newSearchQuery {
    [self didChangeSearchQuery:newSearchQuery];
}

#pragma mark - Collection View

- (void)collectionViewDataSource:(CollectionViewDataSource *)dataSource prefetchItemFromIndex:(NSUInteger)index {
    RSPLog(NSLocalizedString(@"Fetch next page", @""));
    [MPGoogleAnalyticsTracker trackEventOfCategory:@"Plugin" action:@"LoadNextPage"
                                             label:self.viewModel.query value:@1];
    
    [self.viewModel nextPage];
    [self.behanceService getItems:self.viewModel.query
                             page:self.viewModel.page
                completionHandler:^(NSArray<RSPItem *> *_Nullable urls, NSError *error) {
                    [self handleNewItems:urls reset:NO error:error];
                }];
}

- (void)collectionViewDataSourceDidChangeSelection:(CollectionViewDataSource *)dataSource {
    [self updateState];
}
@end

NS_ASSUME_NONNULL_END
