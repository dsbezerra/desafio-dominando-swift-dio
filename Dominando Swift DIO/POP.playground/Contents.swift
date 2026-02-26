import Foundation

enum LampState {
    case on
    case off
}

protocol Switchable {
    var state: LampState { get set }
    func turnOn()
    func turnOff()
}

protocol Dimmable {
    var brightness: Int { get set }
    mutating func setBrightness(_ level: Int)
}

extension Switchable {
    mutating func toggle() {
        switch state {
        case .on:
            turnOff()
        case .off:
            turnOn()
        }
    }
}

struct BasicLamp: Switchable {
    var state: LampState = .off
    
    func turnOn() {
        print("BasicLamp ligada")
    }
    
    func turnOff() {
        print("BasicLamp desligada")
    }
}

struct SmartLamp: Switchable, Dimmable {
    var state: LampState = .off
    var brightness: Int = 50
    
    func turnOn() {
        print("SmartLamp ligada")
    }
    
    func turnOff() {
        print("SmartLamp desligada")
    }
    
    mutating func setBrightness(_ level: Int) {
        brightness = max(0, min(level, 100))
        print("Brilho ajustado para \(brightness)%")
    }
}

struct LampManager {
    
    static func applyToAll(
        lamps: inout [any Switchable],
        action: (inout any Switchable) -> Void
    ) {
        for index in lamps.indices {
            action(&lamps[index])
        }
    }
    
    static func turnOnAllAsync(lamps: [any Switchable]) async {
        await withTaskGroup(of: Void.self) { group in
            for lamp in lamps {
                group.addTask {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    print("Ligando lâmpada...")
                }
            }
        }
    }
}

var basic = BasicLamp()
var smart = SmartLamp()

var lamps: [any Switchable] = [basic, smart]

LampManager.applyToAll(lamps: &lamps) { lamp in
    lamp.turnOn()
}

Task {
    await LampManager.turnOnAllAsync(lamps: lamps)
}
