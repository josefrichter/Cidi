class CitiesController < UIViewController

  path = NSBundle.mainBundle.pathForResource("cidi_cities1000", ofType:"json")
  CITIES = BW::JSON.parse NSData.dataWithContentsOfFile(path)

  def viewDidLoad
    super
    self.title = "Cities"

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    self.view.addSubview(@table)

    @table.dataSource = self
    @table.delegate = self

    search_bar = UISearchBar.alloc.initWithFrame([[0,0],[320,44]])
    search_bar.delegate = self
    @table.addSubview(search_bar)
    #self.view.tableHeaderView = search_bar

    @search_results = CITIES

  end

  def tableView(tableView, numberOfRowsInSection:section)
    @search_results.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell = UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleDefault,
      reuseIdentifier:@reuseIdentifier)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    # put your data in the cell
    cell.textLabel.text = @search_results[indexPath.row][:name]
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    city = @search_results[indexPath.row][:name]

    controller = UIViewController.alloc.initWithNibName(nil, bundle:nil)
    controller.view.backgroundColor = UIColor.whiteColor
    controller.title = city

    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = "0"
    @label.sizeToFit
    @label.center = [controller.view.frame.size.width/2,
      controller.view.frame.size.height/2]

    # docs: https://github.com/rubymotion/BubbleWrap/blob/master/motion/location/location.rb
    BW::Location.get do |result|
      lat = @search_results[indexPath.row][:lat]
      lon = @search_results[indexPath.row][:lon]
      cityloc = CLLocation.alloc.initWithLatitude(lat, longitude:lon)
      dist = result[:to].distanceFromLocation(cityloc) / 1000 #km
      @label.text = dist.round.to_s
      @label.sizeToFit
    end

    controller.view.addSubview(@label)
    self.navigationController.pushViewController(controller, animated:true)
  end

  def searchBarSearchButtonClicked(search_bar)
  #def searchBar(search_bar, textDidChange: searchText)
    #@search_results.clear
    searchText = search_bar.text
    search_bar.resignFirstResponder
    navigationItem.title = "search results for '#{searchText}'"
    search_for(searchText)
    search_bar.text = ""
  end

  def search_for(text)
    @search_results = CITIES
    @search_results = @search_results.select {|c| c[:name].to_s.downcase.include? text.downcase }
    p @search_results.count
    @table.reloadData
  end

end

