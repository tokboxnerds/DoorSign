//
//  DoorSignTests.m
//  DoorSignTests
//
//  Created by Patrick Quinn-Graham on 26/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DoorSignTests : XCTestCase

@end

@implementation DoorSignTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRunner
{
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (true) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
}

@end
