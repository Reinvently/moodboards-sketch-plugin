//
//  RSPBehanceService.m
//  SketchPlugin
//
//  Created by Boyko Andrey on 4/9/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "RSPBehanceService.h"
#import "RSPLogger.h"

#define BEHANCE_API_URL  @"https://api.behance.net/v2/projects?q=%@&page=%lu&client_id=OPuJSfVVGSacAPbxKBYGE6xeW4qKAA7u&sort=appreciations"
#define API_PROJECTS_KEY @"projects"
#define API_COVERS_KEY @"covers"
#define API_ITEM_KEY @"404"
#define API_PROJECT_NAME_KEY @"name"
#define API_PROJECT_URL_KEY @"url"

#define LOLDynamicCast(object, classType) ([(object) isKindOfClass:[classType class]]?((classType*)object):nil)
NS_ASSUME_NONNULL_BEGIN
@interface RSPBehanceService ()
@property(strong) NSURLSession *session;
@end

@implementation RSPBehanceService
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

    [[self.session dataTaskWithURL:[self urlWithQuery:query page:page]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     if (error) {
                         completionHandler(nil, [self processError:error response:response]);
                     } else {
                         completionHandler([self mapDataToModel:data], nil);
                     }
                 }] resume];
}

#pragma mark - Url

///
/// Create search url
/// @param query search query
/// @param page page number
/// @return url
- (NSURL *)urlWithQuery:(NSString *)query page:(NSUInteger)page {
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *urlStr = [NSString stringWithFormat:BEHANCE_API_URL, query, page];
    RSPLog(urlStr);
    return [NSURL URLWithString:urlStr];
}

#pragma mark - Model mapping

///
/// Map server answer to model
/// @param data raw response from server
/// @return List of RSPItems
- (NSArray <RSPItem *> *)mapDataToModel:(NSData *)data {
    //parse json
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    jsonResponse = LOLDynamicCast(jsonResponse, NSDictionary);

    NSMutableArray <RSPItem *> *result = [NSMutableArray array];
    NSArray<NSDictionary *> *projects = LOLDynamicCast(jsonResponse[API_PROJECTS_KEY], NSArray);

    for (NSDictionary *project in projects) {
        NSDictionary *cover = LOLDynamicCast(project[API_COVERS_KEY], NSDictionary);
        NSString *urlStr = LOLDynamicCast(cover[API_ITEM_KEY], NSString);
        NSString *urlProject = LOLDynamicCast(project[API_PROJECT_URL_KEY], NSString);
        NSString *nameProject = LOLDynamicCast(project[API_PROJECT_NAME_KEY], NSString);
        if (urlStr == nil) {
            continue;
        }
        NSURL *tmpURL = [NSURL URLWithString:urlStr];
        if (tmpURL==nil) {
            continue;
        }
        RSPItem* item = [RSPItem new];
        item.imgURL = tmpURL;
        item.name = nameProject;
        item.itemURLString = urlProject;
        [result addObject:item];
    }
    
    return result;
}

#pragma mark - Error Handling

///
/// Handle error from server
/// @param error server error
/// @param response http response
/// @return Modified error(if required)
- (NSError *)processError:(NSError *)error response:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if (httpResponse.statusCode == 429) {
        error = [self errorToManyRequests];
    }
    return error;
}

///
/// A special error for situation where user rich max limit
/// @return error
- (NSError *)errorToManyRequests {
    NSString *errorMessage = NSLocalizedString(@"You have sent too many search requests in a given amount of time. Please try again later", @"");
    return [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
}
@end

NS_ASSUME_NONNULL_END
