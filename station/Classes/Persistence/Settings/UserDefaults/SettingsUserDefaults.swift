import Foundation

class SettingsUserDegaults: Settings {
    
    var temperatureUnit: TemperatureUnit {
        get {
            return useFahrenheit ? .fahrenheit : .celsius
        }
        set {
            useFahrenheit = newValue == .fahrenheit
        }
    }
    
    private var useFahrenheit: Bool {
        get {
            return UserDefaults.standard.bool(forKey: useFahrenheitUDKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: useFahrenheitUDKey)
        }
    }
    private let useFahrenheitUDKey = "SettingsUserDegaults.useFahrenheit"
}
