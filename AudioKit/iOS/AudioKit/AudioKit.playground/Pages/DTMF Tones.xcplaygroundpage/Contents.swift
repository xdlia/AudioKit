//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## DTMF Tones
//: ### An example creating typical telephone sounds with AudioKit
import XCPlayground
import AudioKit

let audiokit = AKManager.sharedInstance

//: Now we can move on to dialing sounds
var keys = [String: [Double]]()
keys["1"] = [697, 1209]
keys["2"] = [697, 1336]
keys["3"] = [697, 1477]
keys["4"] = [770, 1209]
keys["5"] = [770, 1336]
keys["6"] = [770, 1477]
keys["7"] = [852, 1209]
keys["8"] = [852, 1336]
keys["9"] = [852, 1477]
keys["*"] = [941, 1209]
keys["0"] = [941, 1336]
keys["#"] = [941, 1477]

let frequencies = keys["0"]!
let keyPressTone = AKOperation.sineWave(frequency: AKOperation.parameters(0)) + AKOperation.sineWave(frequency: AKOperation.parameters(1))
let momentaryPress = keyPressTone.triggeredWithEnvelope(AKOperation.trigger, attack: 0.01, hold: 0.1, release: 0.01)
let generator = AKOperationGenerator(operation: momentaryPress, triggered: true)

audiokit.audioOutput = generator
audiokit.start()

generator.start()

//: Let's call Jenny and Mary!
let phoneNumber = "8675309  3212333 222 333 3212333322321"
for number in phoneNumber.characters {
    if keys.keys.contains(String(number)) {
        generator.trigger(keys[String(number)]!)
    }
    usleep(250000)
}

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
