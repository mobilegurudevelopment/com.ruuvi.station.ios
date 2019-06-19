import UIKit

class MenuTableTransitionManager: NSObject {
    
    var menuWidth: CGFloat = min(round(min((appScreenRect.width), (appScreenRect.height)) * 0.75), 240)
    var container: UIViewController
    var menu: UIViewController
    var isInteractive: Bool = false
    
    private static var appScreenRect: CGRect {
        let appWindowRect = UIApplication.shared.keyWindow?.bounds ?? UIWindow().bounds
        return appWindowRect
    }
    
    init(container: UIViewController, menu: UIViewController) {
        self.container = container
        self.menu = menu
    }
    
}
