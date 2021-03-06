//
//  SCSDKLoginClient.h
//  SCSDKLoginKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Callback to trigger when fetch resource success.
 *
 * @param resources that contain user data.
 */
typedef void(^SCOAuth2GetResourcesSuccessCompletionBlock)(NSDictionary * _Nullable resources);

/**
 * Callback to trigger when fetch resource failed.
 *
 * @param error that happened when fetch data from resource server.
 * @param isUserLoggedOut set to YES if the connection between 3PA and Snapchat is broken or user is not logged in to 3PA using Snapchat. Set to NO if other errors occur while fetching data from Snapchat
 */
typedef void(^SCOAuth2GetResourcesFailureCompletionBlock)(NSError * _Nullable error, BOOL isUserLoggedOut);

/**
 * Protocol for observing all changes that occur for a user's login status. Notifications will always occur
 * on the main queue.
 */
@protocol SCSDKLoginStatusObserver <NSObject>

@optional
/**
 * Called whenever a user successfully authorizes with their Snapchat account.
 */
- (void)scsdkLoginLinkDidSucceed;

/**
 * Called whenever a user's authorization process fails.
 */
- (void)scsdkLoginLinkDidFail;

/**
 * Called whenever a user either explicitly unlinks their Snapchat account, or access to the user's account
 * is revoked.
 */
- (void)scsdkLoginDidUnlink;

@end

@interface SCSDKLoginClient : NSObject

@property (class, assign, readonly) BOOL isUserLoggedIn;

/**
 * Start Auth with Snapchat.
 *
 * @param viewController that shows the in-app auth page.
 */
+ (void)loginFromViewController:(UIViewController *)viewController
                     completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 * Finish auth with Snapchat.
 *
 * @param application for singleton app object of calling app
 * @param url created by Snapchat.
 * @param options for the url to handle
 * @return YES if Snapchat can open the the url, NO if it cannot
 */
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *_Nullable)options;

/**
 * Revoke current session.
 *
 * @param completion block be trigged when finish revoking session.
 */
+ (void)unlinkCurrentSessionWithCompletion:(nullable void (^)(BOOL success))completion;

/**
 * Revoke all sessions.
 *
 * @param completion block be trigged when finish revoking session.
 */
+ (void)unlinkAllSessionsWithCompletion:(void (^)(BOOL success))completion;

/**
 * Interface to fetch user data from resource server.
 *
 * @param query GraphQL query to fetch user data.
 * @param success Success block when fetch data succeed.
 * @param failure Failure block when fetch data failed.
 */
+ (void)fetchUserDataWithQuery:(NSString *)query
                     variables:(nullable NSDictionary<NSString *, id> *)variables
                       success:(SCOAuth2GetResourcesSuccessCompletionBlock)success
                       failure:(SCOAuth2GetResourcesFailureCompletionBlock)failure;

/**
 * Determines whether the user has authorized the current session to have access to resources
 * with the requested scope
 *
 * @param scope The scope
 * @return YES if the current session has access to resources with the scope, NO otherwise
 */
+ (BOOL)hasAccessToScope:(NSString *)scope;

/**
 * Add an observer to receive updates to the user's login status
 *
 * @param observer The object that will receive updates
 */
+ (void)addLoginStatusObserver:(id<SCSDKLoginStatusObserver>)observer NS_SWIFT_NAME(addLoginStatusObserver(_:));

/**
 * Remove an observer to stop receiving updates to the user's login status
 *
 * @param observer The object currently receiving updates
 */
+ (void)removeLoginStatusObserver:(id<SCSDKLoginStatusObserver>)observer NS_SWIFT_NAME(removeLoginStatusObserver(_:));

@end

NS_ASSUME_NONNULL_END
