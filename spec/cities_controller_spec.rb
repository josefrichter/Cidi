describe "CitiesController" do
  tests CitiesController

  it "loads a list of cities" do
    CitiesController::CITIES.length.should > 0
  end

  it "shows first city in first cell" do
    views(UITableViewCell)[0].text.should == CitiesController::CITIES[0][:name]
  end

  it "shows all cities in a table" do
    CitiesController::CITIES.length.should == controller.tableView.numberOfRowsInSection(0)
  end

  it "should have disclosure indicators" do
    views(UITableViewCell).first.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
  end

  it "should filter cities" do
    drag(controller, :from => top)
    #tap controller.search_bar
    controller.search_bar.text = 'Berlin'
    wait 0.2 do
      controller.search_results.size.should == 1
      controller.tableView.numberOfRowsInSection(0) == 1
      controller.search_bar.resignFirstResponder
    end
  end

  it "shows detail screen for a table cell" do
    view("Accra").should.not.be.nil
    #tap("Accra")
    wait 2 do
      #tap("OK")
    end
    0.should == 0
  end

end