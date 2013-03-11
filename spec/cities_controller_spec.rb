describe "CitiesController" do
  tests CitiesController

  it "loads a list of cities" do
    CitiesController::CITIES.length.should > 0
  end

  it "shows first city in first cell" do
    views(UITableViewCell)[0].text.should == CitiesController::CITIES[0][:name]
  end
end