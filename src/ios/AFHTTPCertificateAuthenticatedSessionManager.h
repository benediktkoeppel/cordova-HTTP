// AFHTTPCertificateAuthenticatedSessionManager.h

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPCertificateAuthenticatedSessionManager : AFHTTPSessionManager <NSSecureCoding, NSCopying>

@property (readwrite, nonatomic, strong, nullable) NSURLCredential *clientCredential;


///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns an `AFHTTPCertificateAuthenticatedSessionManager` object.
 */
+ (instancetype)manager;

/**
 Initializes an `AFHTTPSessionManager` object with the specified credential.

 @param credential .

 @return The newly-initialized HTTP client with certificate based authentication
 */
- (instancetype)initWithClientCredential:(nullable NSURLCredential *)clientCredential;


- (void)enableCertificateAuthentication;

@end

NS_ASSUME_NONNULL_END
