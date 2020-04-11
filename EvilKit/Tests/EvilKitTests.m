#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <EvilKit/EvilKit.h>

@interface EvilKitTests : XCTestCase

@end

@implementation EvilKitTests {
    NSArray<NSString *> *urlStrings;
    NSMutableArray<NSURL *> *urls;
}

- (void)setUp {
    urlStrings = @[
        @"",
        @"mB*RTDCwT7kVYmyM4(dr5c6jxTr%83ICoHEXdKn7Z$~ABHq#B=3n82WuUResWcGK",
        @"example.com",
        @"www.example.com",
        @"http://example.com",
        @"https://www.example.com",
        @"https://www.example.com/path/to/neat/file.txt",
        @"https://www.example.com/?arg1=420&arg2=69",
        @"https://johnny:p4ssw0rd@www.example.com:443/script.ext;param=value?query=value#ref",
        @"firefox-focus://open-url?url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"https://maps.apple.com/?address=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States&abPersonID=3",
        @"maps:?saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"maps://?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"x-web-search://?this%20is%20a%20test",
        @"x-web-search://?this%20is%20a%20test-/:;()$$&%E2%80%9D@,?%E2%80%99%20n%5D+%E2%82%AC%23!%7C",
        @"mailto:test@example.com",
        @"mailto:test@example.com?cc=othertest@example.com",
        @"https://youtu.be/dQw4w9WgXc",
        @"https://example.com/?n1=one&n2=two",
        @"https://example.com/?nOne=1&nTwo=2",
    ];

    urls = [NSMutableArray new];
    for(NSString *url in urlStrings)
        [urls addObject:[NSURL URLWithString:url]];
}

// Trivial portion tests {{{
- (void)testQuery {
    NSArray<NSString *> *schemes = @[
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"arg1=420&arg2=69",
        @"query=value",
        @"url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"address=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States&abPersonID=3",
        @"saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"this%20is%20a%20test",
        @"this%20is%20a%20test-/:;()$$&%E2%80%9D@,?%E2%80%99%20n%5D+%E2%82%AC%23!%7C",
        @"",
        @"cc=othertest@example.com",
        @"",
        @"n1=one&n2=two",
        @"nOne=1&nTwo=2",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKQueryPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testResource {
    NSArray<NSString *> *schemes = @[
        @"",
        @"mB*RTDCwT7kVYmyM4(dr5c6jxTr%83ICoHEXdKn7Z$~ABHq#B=3n82WuUResWcGK",
        @"example.com",
        @"www.example.com",
        @"example.com",
        @"www.example.com",
        @"www.example.com/path/to/neat/file.txt",
        @"www.example.com/?arg1=420&arg2=69",
        @"johnny:p4ssw0rd@www.example.com:443/script.ext;param=value?query=value#ref",
        @"open-url?url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"maps.apple.com/?address=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States&abPersonID=3",
        @"?saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"?this%20is%20a%20test",
        @"?this%20is%20a%20test-/:;()$$&%E2%80%9D@,?%E2%80%99%20n%5D+%E2%82%AC%23!%7C",
        @"test@example.com",
        @"test@example.com?cc=othertest@example.com",
        @"youtu.be/dQw4w9WgXc",
        @"example.com/?n1=one&n2=two",
        @"example.com/?nOne=1&nTwo=2",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKTrimmedResourceSpecifierPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testHost {
    NSArray<NSString *> *schemes = @[
        @"",
        @"",
        @"",
        @"",
        @"example.com",
        @"www.example.com",
        @"www.example.com",
        @"www.example.com",
        @"www.example.com",
        @"open-url",
        @"maps.apple.com",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"youtu.be",
        @"example.com",
        @"example.com",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKHostPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testPath {
    NSArray<NSString *> *schemes = @[
        @"",
        @"",
        @"example.com",
        @"www.example.com",
        @"",
        @"",
        @"path/to/neat/file.txt",
        @"",
        @"script.ext;param=value",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"test@example.com",
        @"test@example.com",
        @"dQw4w9WgXc",
        @"",
        @"",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKTrimmedPathPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testScheme {
    NSArray<NSString *> *schemes = @[
        @"",
        @"",
        @"",
        @"",
        @"http",
        @"https",
        @"https",
        @"https",
        @"https",
        @"firefox-focus",
        @"https",
        @"maps",
        @"maps",
        @"x-web-search",
        @"x-web-search",
        @"mailto",
        @"mailto",
        @"https",
        @"https",
        @"https",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKSchemePortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testFullURL {
    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = urlStrings[i];
        result = [[EVKFullURLPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testStaticString {/* good luck breaking that */}
// }}}

// Complex portion tests {{{
- (void)testQueryTranslations {
    EVKTranslatedQueryPortion *example = [EVKTranslatedQueryPortion portionWithDictionary:@{
        @"n1" : [[EVKQueryItemLexicon alloc] initWithKeyName:@"nOne"
                                                  dictionary:@{@"one" : @"1"}
                                                defaultState:URLQueryStateNull],
        @"n2" : [[EVKQueryItemLexicon alloc] initWithKeyName:@"nTwo"
                                                  dictionary:@{@"two" : @"2"}
                                                defaultState:URLQueryStateNull],
    }];
    EVKTranslatedQueryPortion *maps = [EVKTranslatedQueryPortion portionWithDictionary:@{
        @"t" : [[EVKQueryItemLexicon alloc] initWithKeyName:@"directionsmode"
                                                 dictionary:@{
                                                     @"d": @"driving",
                                                     @"w": @"walking",
                                                     @"r": @"transit",
                                                 }
                                               defaultState:URLQueryStateNull],
        @"dirflg":  [[EVKQueryItemLexicon alloc] initWithKeyName:@"views"
                                                      dictionary:@{
                                                          @"k": @"satelite",
                                                          @"r": @"transit",
                                                      }
                                                    defaultState:URLQueryStateNull],
        @"address" : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
        @"daddr" : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
        @"saddr" : [EVKQueryItemLexicon identityLexiconWithName:@"saddr"],
        @"q" : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
        @"ll" : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
        @"z" : [EVKQueryItemLexicon identityLexiconWithName:@"zoom"],
    }];

    XCTAssertTrue([[example evaluateWithURL:urls[18]] isEqualToString:@"nOne=1&nTwo=2"]);
    XCTAssertTrue([[maps evaluateWithURL:urls[10]] isEqualToString:@"daddr=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States"]);
    XCTAssertTrue([[maps evaluateWithURL:urls[11]] isEqualToString:@"saddr=San+Jose&daddr=San+Francisco&views=transit"]);
    XCTAssertTrue([[maps evaluateWithURL:urls[12]] isEqualToString:@"q=Mexican+Restaurant&zoom=10&directionsmode=transit"]);
}

- (void)testRegexSubstitution {/* apple's behaviour */}
// }}}
@end
