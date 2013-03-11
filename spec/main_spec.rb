describe "Application 'Cidi'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has a root view controller" do
    @app.keyWindow.rootViewController.class.should == CitiesController
  end

end
