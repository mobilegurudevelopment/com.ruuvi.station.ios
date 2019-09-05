import LightRoute

class SettingsRouter: SettingsRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    func dismiss() {
        try! transitionHandler.closeCurrentModule().perform()
    }
    
    func openLanguage() {
        let factory = StoryboardFactory(storyboardName: "Language")
        try! transitionHandler
            .forStoryboard(factory: factory, to: LanguageModuleInput.self)
            .to(preferred: .navigation(style: .push))
            .perform()
    }
}