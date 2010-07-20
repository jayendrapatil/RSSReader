//
//  RootViewController.m
//  RSS Reader
//
//  Created by Rishabh Dayal on 7/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Best of McKinsey Quarterly";
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	if ([stories count] == 0) {
		//NSString * path = @"http://feeds.feedburner.com/TheAppleBlog";
		NSString * path = @"http://rss.mckinseyquarterly.com/f/100003s2f3fmpgm5lb0.rss";
		[self parseXMLFileAtURL:path];
	}
	cellSize = CGSizeMake([newsTable bounds].size.width, 100);
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		
    }
    
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	[[cell textLabel] setText:[[stories objectAtIndex:storyIndex] objectForKey: @"title"]];
	
	NSString* imageURL = [[stories objectAtIndex:storyIndex] objectForKey: @"image"];
	NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	[[cell imageView] setImage:image];
	[imageData release];
	[image release];
	
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"Latest articles from eQ";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @"Send us feedback!";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	UIWebView *rssWebView = [[UIWebView alloc] init];
	NSString *urlString = [NSString stringWithFormat:[[stories objectAtIndex:indexPath.row] objectForKey:@"link"]];
	NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	[rssWebView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:encodedUrl]]];
	rssWebView.scalesPageToFit = YES;
	
	
	UIViewController *thisVC = [[UIViewController alloc] init];
	thisVC.view = rssWebView;
	thisVC.title = [[stories objectAtIndex:indexPath.row]
					objectForKey:@"title"];
	
	[self.navigationController pushViewController:thisVC animated:YES];
	
	[rssWebView release];
	[thisVC release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)parseXMLFileAtURL:(NSString	*)URL {
	stories = [[NSMutableArray alloc] init];
	NSURL *xmlURL = [NSURL URLWithString:URL];
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	[rssParser setDelegate:self];
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	[rssParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from website (Error code %i )", [parseError code]];
	NSLog(@"error parsing XL: %@", errorString);
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString	*)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"]) {
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		images  = [[NSMutableString alloc] init];
	} else if ([elementName isEqualToString:@"media:content"]) {
		[images appendString:[attributeDict objectForKey:@"url"]];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName { 
	NSLog(@"ended element: %@", elementName); 
	if ([elementName isEqualToString:@"item"]) { 
		// save values to an item, then store that item into the array... 
		[item setObject:currentTitle forKey:@"title"]; 
		[item setObject:currentLink forKey:@"link"]; 
		[item setObject:currentSummary forKey:@"summary"]; 
		[item setObject:currentDate forKey:@"date"];
		[item setObject:images forKey:@"image"];
		[stories addObject:[item copy]]; 
	} 
} 

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	//NSLog(@"found characters: %@", string); 
	// save the characters for the current item... 
	if ([currentElement isEqualToString:@"title"]) { 
		[currentTitle appendString:string]; 
	} else if ([currentElement isEqualToString:@"link"]) { 
		[currentLink appendString:string]; 
	} else if ([currentElement isEqualToString:@"description"]) { 
		[currentSummary appendString:string]; 
	} else if ([currentElement isEqualToString:@"pubDate"]) { 
		[currentDate appendString:string]; 
	}
		 
} 

- (void)parserDidEndDocument:(NSXMLParser *)parser { 
	[activityIndicator stopAnimating]; 
	[activityIndicator removeFromSuperview]; 
	[newsTable reloadData]; 
}


- (void)dealloc {
	[currentElement release]; 
	[rssParser release]; 
	[stories release]; 
	[item release]; 
	[currentTitle release]; 
	[currentDate release]; 
	[currentSummary release]; 
	[currentLink release];
	[images release];
    [super dealloc];
}

@end

