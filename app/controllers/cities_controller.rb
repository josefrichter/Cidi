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

  end

  def tableView(tableView, numberOfRowsInSection:section)
    CITIES.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell = UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleDefault,
      reuseIdentifier:@reuseIdentifier)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    # put your data in the cell
    cell.textLabel.text = CITIES[indexPath.row][1]
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    city = CITIES[indexPath.row][1]

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
      lat = CITIES[indexPath.row][3]
      lon = CITIES[indexPath.row][4]
      cityloc = CLLocation.alloc.initWithLatitude(lat, longitude:lon)
      dist = result[:to].distanceFromLocation(cityloc) / 1000 #km
      @label.text = dist.round.to_s
      @label.sizeToFit
    end

    controller.view.addSubview(@label)
    self.navigationController.pushViewController(controller, animated:true)
  end

end

