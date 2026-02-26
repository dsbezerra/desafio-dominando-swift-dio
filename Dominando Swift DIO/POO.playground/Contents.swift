import Foundation

enum PetMood {
    case happy
    case tired
}

struct Toy {
    let name: String
    let energyCost: Int
}

class Pet {
    var name: String
    var energy: Int
    var mood: PetMood = .happy
    
    init(name: String, energy: Int) {
        self.name = name
        self.energy = energy
    }
    
    func makeSound() -> String {
        return "TODO"
    }
    
    func play(_ toy: Toy) async {
        if (energy > 0) {
            print("Play!")
            energy -= toy.energyCost
            
            if energy == 0 {
                mood = .tired
            }
        } else {
            print("Can't play... too tired!")
        }
    }
}

class Dog : Pet {
    override func makeSound() -> String {
        return "Aw"
    }
}

class Cat : Pet {
    override func makeSound() -> String {
        return "Miaw"
    }
}

let toy = Toy(name: "Osso", energyCost: 40)
let pets: [Pet] = [Dog(name: "Caramelo", energy: 100), Cat(name: "Melô", energy: 60)]

Task {
    let dog = pets.first
    for index in 1...5 {
        await dog?.play(toy)
    }
}

