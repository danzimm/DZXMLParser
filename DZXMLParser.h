//
//  DZXMLParser.h
//
//  Created by Dan Zimmerman on 11/9/11.
//  Copyright (c) 2011 Dan Zimmerman. All rights reserved.
//

@protocol DZXMLParserDelegate;


@interface DZXMLParser : NSObject <NSXMLParserDelegate> {
	NSData *_data;
	NSXMLParser *_parser;
	NSMutableArray *_currentElements;
	NSMutableString *_bufferData;
	bool _isParsing;
	
		//delegate things
	id <DZXMLParserDelegate>_delegate;
	NSMutableArray *_deniedElements;
	BOOL shouldBeRecieving;
}

	//makes copy of data, dont worry
- (id)initWithData:(NSData *)data delegate:(id<DZXMLParserDelegate>)delegate;
- (void)doIt;

@end

@protocol DZXMLParserDelegate <NSObject>
@required
- (BOOL)shouldReportElement:(NSString *)element;
- (void)receievedData:(NSString *)stuff inElements:(NSArray *)elements;
- (void)parser:(DZXMLParser *)a errorOccured:(NSError *)err;
- (void)finishedParsing:(DZXMLParser*)a;
- (void)foundElement:(NSString *)ele withAttributes:(NSDictionary *)att;
@end