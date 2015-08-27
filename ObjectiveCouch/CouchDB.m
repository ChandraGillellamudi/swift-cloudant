//
//  Cloudant.m
//  ObjectiveCouch
//
//  Created by Michael Rhodes on 15/08/2015.
//  Copyright © 2015 Small Text. All rights reserved.
//

#import "CouchDB.h"
#import "CDTCouchOperation.h"

#import "Database.h"

@interface CouchDB ()

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSURLSession *session;

@end

@implementation CouchDB

+ (CouchDB*)clientForURL:(NSURL*)url 
                 username:(NSString*)username 
                 password:(NSString*)password
{
    return [[CouchDB alloc] initForURL:url
                               username:username
                               password:password];
}

- (instancetype)initForURL:(NSURL*)url 
                  username:(NSString*)username 
                  password:(NSString*)password
{
    self = [super init];
    if (self) {
        _rootURL = url;
        _username = username;
        _password = password;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (Database*)objectForKeyedSubscript:(NSString*)key
{
    return [[Database alloc] initWithClient:self databaseName:key];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[url: %@]", self.rootURL];
}

- (void)prepareOperation:(CDTCouchOperation*)operation
{
    operation.session = self.session;
    operation.rootURL = self.rootURL;
    operation.username = self.username;
    operation.password = self.password;
}

@end
