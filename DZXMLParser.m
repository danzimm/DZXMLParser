//
//  OSXMLParser.m
//  Sector
//
//  Created by Dan Zimmerman on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OSXMLParser.h"

@interface OSXMLParser (private)
- (BOOL)_checkElementListAgainstDeniedList;
@end

@implementation OSXMLParser

- (id)initWithData:(NSData *)data delegate:(id<OSXMLParserDelegate>)delegate
{
	if ((self = [super init]) != nil) {
		_data = [[NSData alloc] initWithData:data];
		_delegate = delegate;
		_parser = [[NSXMLParser alloc] initWithData:_data];
		[_parser setDelegate:self];
		[_parser setShouldResolveExternalEntities:YES];
		_currentElements = [[NSMutableArray alloc] init];
		_deniedElements = [[NSMutableArray alloc] init];
		_bufferData = [[NSMutableString alloc] init];
	}
	return self;
}

- (void)doIt
{
	[_parser parse];
}

- (BOOL)_checkElementListAgainstDeniedList
{
	for (NSString *element in _deniedElements) {
		if ([_currentElements containsObject:element])
			return YES;
	}
	
	return NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict
{
	if (![_delegate shouldReportElement:elementName]) {
		[_deniedElements addObject:elementName];
	}
	shouldBeRecieving = ![self _checkElementListAgainstDeniedList];
	
	[_currentElements addObject:elementName];
	
	if (shouldBeRecieving && [[attributeDict allKeys] count] > 0) {
		[_delegate foundElement:elementName withAttributes:attributeDict];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if (shouldBeRecieving && _bufferData.length > 0) {
		[_delegate receievedData:_bufferData inElements:_currentElements];
		[_bufferData deleteCharactersInRange:NSMakeRange(0, [_bufferData length])];
	}
	if ([_currentElements containsObject:elementName]) {
		[_currentElements removeObject:elementName];
		shouldBeRecieving = ![self _checkElementListAgainstDeniedList];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (shouldBeRecieving) {
		[_bufferData appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	[_delegate parser:self errorOccured:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[_delegate finishedParsing:self];
}

@end
