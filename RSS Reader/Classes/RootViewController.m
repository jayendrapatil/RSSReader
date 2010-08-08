#import "RootViewController.h"

#import "CustomCell.h" 
#import "DetailViewController.h"
#import "Reachability.h"
#import "AsyncImageView.h"


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
		
		NSURL *xmlURL = [NSURL URLWithString:path];
		
		NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"feeds.xml"];
		
		Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
		NetworkStatus internetStatus = [r currentReachabilityStatus];
		
		if (internetStatus != NotReachable) {
			NSLog(@"Downloading from the web");
			// Store XML feed offline
			NSData *data = [NSData dataWithContentsOfURL:xmlURL];
			[data writeToFile:storePath atomically:TRUE];
		}
		
		[self parseXMLFileAtURL:storePath];
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
	
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		for (id oneObject in nib)
			if ([oneObject isKindOfClass:[CustomCell class]])
				cell = (CustomCell *)oneObject;
	} else {
			AsyncImageView* oldImage = (AsyncImageView*)
			[cell.thumbnailImage viewWithTag:999];
			[oldImage removeFromSuperview];
	}
	
	CGRect frame;
	frame.size.width=100; frame.size.height=70; frame.origin.x=3; frame.origin.y=0;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = [stories objectAtIndex:row];
	cell.colorLabel.text = [rowData objectForKey:@"summary"];
	cell.nameLabel.text = [rowData objectForKey:@"title"];
	
	NSURL *url = [NSURL URLWithString:[rowData objectForKey:@"image"]];
	[asyncImage loadImageFromURL:url];
	
	[cell.thumbnailImage addSubview:asyncImage];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"Latest articles from eQ";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @"Send us feedback!";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DetailViewController* retController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
	retController.title = [[stories objectAtIndex:indexPath.row] objectForKey:@"title"];		
	[retController setLink:[[stories objectAtIndex:[indexPath row]] objectForKey:@"link"]];
	[[self navigationController] pushViewController:retController animated:YES];
	[retController release];
	
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

- (void)parseXMLFileAtURL:(NSString	*)storePath {
	
	stories = [[NSMutableArray alloc] init];

	// Retrieve XML data from File Path
	NSData *storedContents = [[[NSData alloc] initWithContentsOfFile:storePath] autorelease];
	
	rssParser = [[NSXMLParser alloc] initWithData:storedContents];
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

