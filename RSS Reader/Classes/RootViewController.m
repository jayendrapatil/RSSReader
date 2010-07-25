//
//  RootViewController.m
//  RSS Reader
//
//  Created by Rishabh Dayal on 7/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "ProceduralExampleViewController.h"
#import "CustomCell.h" 

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Best of McKinsey Quarterly";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	if ([stories count] == 0) {
		NSString * path = @"http://rss.mckinseyquarterly.com/f/100003s2f3fmpgm5lb0.rss";
		[self parseXMLFileAtURL:path];
	}
	cellSize = CGSizeMake([newsTable bounds].size.width, 100);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   CGFloat rowHeight = 80;
    return rowHeight;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier ";
	
	CustomCell *cell = (CustomCell *)[tableView
									  dequeueReusableCellWithIdentifier: CustomCellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
													 owner:self options:nil];
		for (id oneObject in nib)
			if ([oneObject isKindOfClass:[CustomCell class]])
				cell = (CustomCell *)oneObject;
	}
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = [stories objectAtIndex:row];
	cell.colorLabel.text = [rowData objectForKey:@"summary"];
	cell.nameLabel.text = [rowData objectForKey:@"title"];
	
	NSString* imageURL = [rowData objectForKey: @"image"];
	NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	
	cell.thumbnailImage.image = image ;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
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
	/*
	// code starts for curling
	viewController = [[[ProceduralExampleViewController alloc] init] autorelease];
	[self.navigationController pushViewController:viewController animated:YES];
	// code ends for curling
	*/ 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES; 	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
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
	if ([elementName isEqualToString:@"item"]) { 
		[item setObject:currentTitle forKey:@"title"]; 
		[item setObject:currentLink forKey:@"link"]; 
		[item setObject:currentSummary forKey:@"summary"]; 
		[item setObject:currentDate forKey:@"date"];
		[item setObject:images forKey:@"image"];
		[stories addObject:[item copy]]; 
	} 
} 

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	if ([currentElement isEqualToString:@"title"]) { 
		[currentTitle appendString:string]; 
	} else if ([currentElement isEqualToString:@"link"]) { 
		[currentLink appendString:string]; 
	} else if ([currentElement isEqualToString:@"media:description"]) { 
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

