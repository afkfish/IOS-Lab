import Foundation

class GameCharacter: NSObject {
    var name: String
    var level: Int
    var healthPoint = 100
    var isDead: Bool {
        healthPoint <= 0
    }
    var power: Int {
        level * 10
    }
    
    init?(name: String, level: Int) {
        if level < 0 || level >= 100 {
            return nil
        }

        self.name = name
        self.level = level
        
        super.init()
    }
}

class Hero: GameCharacter {
    enum WeaponType {
        case laserCanon
        case spoon
    }
    var weapon: WeaponType?
    
    override var power: Int {
        var extraPower = 0
        switch weapon {
        case .laserCanon:
            extraPower = 100
        case .spoon:
            extraPower = 1
        default:
            break
        }
        return super.power + extraPower
    }
}

class Team {
    private var members = [GameCharacter]()

    func add(_ member: GameCharacter) {
        members.append(member)
    }

    func printMembers() {
        members.forEach { print($0.name) }
    }
    
    func has(member: GameCharacter) -> Bool {
        return members.contains {$0 == member}
    }
}

protocol Fightable {
    var isDead: Bool {get}
    var power: Int {get}
    var name: String {get}
    
    func takeDamage(from enemy: Fightable)
    func printHealth()
}

extension GameCharacter: Fightable {
    func takeDamage(from enemy: Fightable) {
        let attackRating = Double.random(in: 0...10) / 10
        let trueDamage = Int(Double(enemy.power) * attackRating)
        healthPoint -= trueDamage
        
        print("\(name) took \(trueDamage) damages from \(enemy.name)")
    }
    
    func printHealth() {
        print("\(name): \(healthPoint) ❤️ \n")
    }
}

class Arena {
    var players: [Fightable]
    
    init (with players: [Fightable]) {
        self.players = players
    }
    
    func startBrawl() {
        while players.count > 1 {
            sleep(1)
            // Keverjük össze a tömb elemeit, hogy összecsapásonként más legyen az első és utolsó elem.
            players.shuffle()
            if let firstPlayer = players.first, let secondPlayer = players.last {
                // Az egyik játékos kapjon ütést a másiktól és írjuk ki az életét utána.
                firstPlayer.takeDamage(from: secondPlayer)
                firstPlayer.printHealth()

                // Ha az ütést kapott karakter meghalt, akkor töröljük a listából.
                if firstPlayer.isDead {
                    print("☠️ \(firstPlayer.name) died. ☠️")
                    players.removeFirst()
                }
            }
        }

        // Ha már csak a győztes szerepel a játékosok között, akkor írjuk ki a nevét.
        if players.count == 1, let winner = players.first {
            print("👑 The winner is \(winner.name)! 👑")
        }
    }
}

class Monster {
    var name: String
    var headCount: Int
    var power: Int {
        headCount * 20
    }
    
    init? (name: String, headCount: Int) {
        if (headCount < 0 || headCount >= 11) {
            return nil
        }
        
        self.name = name
        self.headCount = headCount
    }
}

extension Monster: Fightable {
    var isDead: Bool {
        headCount <= 0
    }
    
    func printHealth() {
        print("\(name): \(headCount) 👥 \n")
    }
    
    func takeDamage(from enemy: Fightable) {
        var loosesHead = Int.random(in: 0...1)
        
        print("\(name) lost \(loosesHead) head because of \(enemy.name)")
        headCount -= loosesHead
    }
}

let hero1 = GameCharacter(name: "Force Chainer", level: 1)
let hero2 = GameCharacter(name: "Wrap Binder", level: 3)
// hero2?.level = 30

let heroes = Team()
heroes.add(hero1!)
heroes.add(hero2!)

heroes.printMembers()

if heroes.has(member: hero1!) {
    print("\(hero1!.name) a csapatban van!")
}

let monster1 = Monster(name: "Bowser", headCount: 3)
let monster2 = Monster(name: "Devil", headCount: 8)

let arena = Arena(with: [hero1!, hero2!, monster1!, monster2!])
arena.startBrawl()



