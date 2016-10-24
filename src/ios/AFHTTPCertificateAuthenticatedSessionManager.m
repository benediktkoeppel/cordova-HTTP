#import "AFHTTPCertificateAuthenticatedSessionManager.h"

@interface AFHTTPCertificateAuthenticatedSessionManager ()
@end

@implementation AFHTTPCertificateAuthenticatedSessionManager
@dynamic responseSerializer;

+ (instancetype)manager {
    return [[[self class] alloc] initWithClientCredential:nil];
}

- (instancetype)init {
    return [self initWithClientCredential:nil];
}

- (instancetype)initWithClientCredential:(NSURLCredential *)clientCredential
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.clientCredential = clientCredential;


    return self;
}

- (void)enableCertificateAuthentication {
    AFHTTPCertificateAuthenticatedSessionManager* __weak weakSelf = self;
    [self setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
           if ([weakSelf.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
               if(credential) {
                   *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                   if (credential) {
                       disposition = NSURLSessionAuthChallengeUseCredential;
                   } else {
                       disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                   }
               } else {
                   disposition = NSURLSessionAuthChallengePerformDefaultHandling;
               }
           } else {
               disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
           }
        }  else {
            if ([challenge previousFailureCount] == 0) {
                NSURLCredential *sharedCredential = weakSelf.clientCredential;
                if (sharedCredential) {
                    *credential = sharedCredential;
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
                }
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        }
        return disposition;
    }];
}



@end
