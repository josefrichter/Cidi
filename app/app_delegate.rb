class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @cities_controller = CitiesController.alloc.initWithNibName(nil, bundle:nil)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(@cities_controller)
    @window.makeKeyAndVisible
    true
  end
end
