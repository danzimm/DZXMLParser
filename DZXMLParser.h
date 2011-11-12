//
//  OSXMLParser.h
//  Sector
//
//  Created by Dan Zimmerman on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@protocol OSXMLParserDelegate;


@interface OSXMLParser : NSObject <NSXMLParserDelegate> {
	NSData *_data;
	NSXMLParser *_parser;
	NSMutableArray *_currentElements;
	NSMutableString *_bufferData;
	
		//delegate things
	id <OSXMLParserDelegate>_delegate;
	NSMutableArray *_deniedElements;
	BOOL shouldBeRecieving;
}

	//makes copy of data, dont worry
- (id)initWithData:(NSData *)data delegate:(id<OSXMLParserDelegate>)delegate;
- (void)doIt;

@end

@protocol OSXMLParserDelegate <NSObject>
@required
- (BOOL)shouldReportElement:(NSString *)element;
- (void)receievedData:(NSString *)stuff inElements:(NSArray *)elements;
- (void)parser:(OSXMLParser *)a errorOccured:(NSError *)err;
- (void)finishedParsing:(OSXMLParser*)a;
- (void)foundElement:(NSString *)ele withAttributes:(NSDictionary *)att;
@end