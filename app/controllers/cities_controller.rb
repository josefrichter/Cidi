class CitiesController < UIViewController

  path = NSBundle.mainBundle.pathForResource("cidi_cities100", ofType:"json")
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

    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = city
    label.sizeToFit
    label.center = [controller.view.frame.size.width/2,
      controller.view.frame.size.height/2]
    controller.view.addSubview(label)
    self.navigationController.pushViewController(controller, animated:true)
  end


end

