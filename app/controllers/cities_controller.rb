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
      dist = distcalc(result[:to].latitude, result[:to].longitude, 
        CITIES[indexPath.row][3], CITIES[indexPath.row][4])
      p dist
      @label.text = dist.to_s
      @label.sizeToFit
    end

    controller.view.addSubview(@label)
    self.navigationController.pushViewController(controller, animated:true)
  end

  def distcalc(lat1,lon1,lat2,lon2)
    #p lat1, lon1, lat2, lon2
    lat2 = todeg(lat2)
    lon2 = todeg(lon2)
    r = 6371; # km

    dLat = torad(lat2-lat1)
    dLon = torad(lon2-lon1)

    lat1 = torad(lat1)
    lat2 = torad(lat2)

    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2) 
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)) 
    d = r * c
    return d.round
  end

  def torad(deg)
    deg * Math::PI / 180
  end

  def todeg(rad)
    rad / Math::PI / 180
  end

end

