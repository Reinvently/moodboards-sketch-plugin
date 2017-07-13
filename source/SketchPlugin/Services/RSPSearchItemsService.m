//
//  RSPSearchItemsService.m
//  SketchPlugin
//
//  Created by aboyko on 7/5/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "RSPSearchItemsService.h"
#import "RSPLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSPSearchItemsService () {
    BOOL _suspended;
}

@property(strong) NSURLSession *session;
@end

@implementation RSPSearchItemsService

@synthesize suspended = _suspended;

#pragma mark - Public

///
/// Initializer
/// @return new instance
- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:NSOperationQueue.mainQueue];
    }
    return self;
}

///
/// Loading bunch of items
/// @param query  search query
/// @param page  page number
/// @param completionHandler  completion handler
- (void) getItems:(NSString *)query
             page:(NSUInteger)page
completionHandler:(void (^)(NSArray<RSPItem *> *__nullable url, NSError *__nullable error))completionHandler {
    NSURL *url = [self urlWithQuery:query page:page];

    if ((!url) || (self.suspended)) {
        completionHandler(@[], nil);
        return;
    }

    [[self.session dataTaskWithURL:url
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                     if (error) {
                         completionHandler(nil, [self processError:error response:response]);
                     } else {
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                             NSArray *result = [self mapDataToModel:data];

                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completionHandler(result, nil);
                             });
                         });
                     }

                 }] resume];
}

///
/// @return Name of Search Service
- (NSString *)serviceName {
    return @"Unknown";
}

#pragma mark - Url

///
/// Create search url
/// @param query search query
/// @param page page number
/// @return url
- (nullable NSURL *)urlWithQuery:(NSString *)query page:(NSUInteger)page {
    return nil;
}

#pragma mark - Model mapping

///
/// Map server answer to model
/// @param data raw response from server
/// @return List of RSPItems
- (NSArray <RSPItem *> *)mapDataToModel:(NSData *)data {
    return @[];
}

#pragma mark - Error Handling

///
/// Handle error from server
/// @param error server error
/// @param response http response
/// @return Modified error(if required)
- (NSError *)processError:(NSError *)error response:(NSURLResponse *)response {
    return error;
}
@end

NS_ASSUME_NONNULL_END
