//: Playground - noun: a place where people can play

import UIKit


typealias DoNothing = () -> Void


func doNothing(task:DoNothing) -> Void {
    print("the doNothing function does the following:")
    task()
}

doNothing(task:{ () -> Void in })
//a do nothing closure
let nothingDoing = {
    () ->Void in
}
doNothing(task: nothingDoing)

let originalArray = [1,2,3,4]
let evenNumber = { (input:Int) -> Bool in return input % 2 == 0}
let tripleTheNumber = { (input:Int) -> Int in return input * 3 }
let x = tripleTheNumber(3)
let aSingleValue = originalArray.map({ tripleTheNumber($0) }).filter({ evenNumber($0)}).reduce(0,+)
print("starting with \(originalArray) we got: \(aSingleValue)")


// create Distance data type
typealias Distance = Double

//create Region data type
typealias Region = (Position) -> Bool

// Region utility functions

// is a position within a particular radius from a reference point?
func circle( radius:Distance) -> Region {
    return {
        point in point.length <= radius }
}

// is a shifed position  within a particular region
func shift(region:@escaping Region, offset:Position) -> Region {
    return { point in region(point.minus(position: offset)) }
}

//confirm whether or not the given position is in the indicated region
func invert( region:@escaping Region ) -> Region {
    return { point in !( region( point ) ) }
}

//confirm whether or not the given position is in both of 2 given regions
func intersection( region1:  @escaping Region, region2: @escaping Region) -> Region {
    return { point in region1(point) && region2(point)}
}

//confirm whether or not the given position is in at least 1 of 2 given regions
func union( region1:  @escaping Region, region2: @escaping Region) -> Region {
    return { point in region1(point) || region2(point)}
}

//confirm that a given position is in one region and NOT in another
func difference(  region:@escaping Region, minus:@escaping Region ) -> Region {
    return intersection(region1:region, region2:invert(region:minus))
}




//Identify ship coordinates on cartesian grid
//Double expresses function better as opposed to Distance
//Position state is mutable by design
struct Position {
    var x:Double
    var y:Double
}

extension Position {
    func minus(position:Position) -> Position {
        return Position(x:x - position.x, y: y - position.y)
    }
    
    var length:Double {
        return sqrt( x * x + y * y)
    }
}


//Idenity Ship state
//Ship state is mutable by design
struct Ship {
    var position:Position
    var firingRange:Distance
    var unsafeRange:Distance
}

extension Ship {
    
    func canSafelyEngageShip1(target: Ship, friendly:Ship) -> Bool {
        return true
    }
    
    func canSafelyEngageShip2(target: Ship, friendly:Ship) -> Bool {
        return false
    }
    
    func canSafelyEngageShip3(target: Ship, friendly:Ship) -> Bool {
        
        let targetDx = target.position.x - position.x
        let targetDy = target.position.y - position.y
        let targetDistance = sqrt(targetDx * targetDx + targetDy  * targetDy)
        print("\ntarget distance = \(targetDistance)")
        
        let friendDx = friendly.position.x - position.x
        let friendDy = friendly.position.y - position.y
        let friendDistance = sqrt(friendDx * friendDx + friendDy  * friendDy)
        print("friend distance = \(friendDistance)")
        
        let possibleFiringRange = targetDistance <= firingRange
        print("possible firing range? \(possibleFiringRange)")
        
        let safeFiringRange = targetDistance > unsafeRange
        print("safe firing range? \(safeFiringRange)")
        
        let canAvoidFriendlyFire = friendDistance > unsafeRange
        print("can avoid friendly fire? \(canAvoidFriendlyFire)")
        
        return possibleFiringRange && safeFiringRange && canAvoidFriendlyFire
    }
    
    func canSafelyEngageShip4(target: Ship, friendly:Ship) -> Bool {
        
        let targetDistance = target.position.minus(position: position).length
        print("\ntarget distance = \(targetDistance)")
        
        let friendDistance = friendly.position.minus(position:position).length
        print("friend distance = \(friendDistance)")
        
        let possibleFiringRange = targetDistance <= firingRange
        print("possible firing range? \(possibleFiringRange)")
        
        let safeFiringRange = targetDistance > unsafeRange
        print("safe firing range? \(safeFiringRange)")
        
        let canAvoidFriendlyFire = friendDistance > unsafeRange
        print("can avoid friendly fire? \(canAvoidFriendlyFire)")
        
        return possibleFiringRange && safeFiringRange && canAvoidFriendlyFire
    }
    
    func canSafelyEngageShip5(target: Ship, friendly:Ship) -> Bool {
        
        let rangeRegion = difference( region: circle( radius: firingRange ), minus: circle( radius: unsafeRange ) )

        let firingRegion = shift( region: rangeRegion, offset: position)
        
        let friendlyRegion = shift( region: circle( radius:unsafeRange ), offset: friendly.position )
        
        let resultRegion = difference( region: firingRegion, minus:friendlyRegion)
        
        return resultRegion( target.position )
        
    }
    
    func testShip(target: Ship, friendly:Ship) -> Void {
        
        let rangeRegion = difference( region: circle( radius: firingRange ), minus: circle( radius: unsafeRange ) )
        
        print("firing range:\(firingRange) -- target distance:\( target.position.length)")
        print("is target in firing range (circle)? \(circle(radius:firingRange)(target.position))" )
        print("is target outside of safe range (invert)? \(invert(region: circle(radius:unsafeRange))(target.position))")
        print( "is target inside firing range and outside of safe range (difference (intersection(circle,invert))? \( rangeRegion( target.position ) )")
        
        let firingRegion = shift( region: rangeRegion, offset: position)
        print( "\nis target in firing range when shifted for firing ship's position? \(firingRegion( target.position ))" )
        
        let friendlyRegion = shift( region: circle( radius:unsafeRange ), offset: friendly.position )
        print( "is friendly ship in firing range when shifted for firing shift's position? \(friendlyRegion( target.position ))" )
        
        let resultRegion = difference( region: firingRegion, minus:friendlyRegion)
        print( "\nis target ship in firing ship's shifted range and friendly ship not in firing range when shifted for firing shift's position? \(resultRegion( target.position ))" )
        
    }
}

print( "\n** test doNothing closure **")
nothingDoing()

print("\n** testing new data types **")
let horizontalDistance:Distance = 5.0
let validDistance = horizontalDistance == 5.0
print("Distance type works? \(validDistance)")


print("\n ** test minus function on (4,5) with (1,1) **")
let testPosition = Position(x:4.0,y:5.0)
print("test position = \(testPosition)")
let minusPosition = testPosition.minus(position:Position(x:1,y:1))
print("minus position = \(minusPosition)")
print("length of minus position \(minusPosition.length)")

//set up the Ships
print("\n ** setting up ships **")
let firingShip = Ship(position: Position(x:65.0,y:15.0), firingRange: 50.0, unsafeRange: 10.0)
let targetShip = Ship(position: Position(x:70.0,y:25.0), firingRange: 50.0, unsafeRange: 10.0)
let friendlyShip = Ship(position: Position(x:85.0,y:30.0), firingRange: 50.0, unsafeRange: 10.0)
print("firing ship:\(firingShip)")
print("target ship:\(targetShip)")
print("friendly ship:\(friendlyShip)")



print("\nfiring status  (all true):\(firingShip.canSafelyEngageShip1(target: targetShip, friendly: friendlyShip))")
print("firing status (all false):\(firingShip.canSafelyEngageShip2(target: targetShip, friendly: friendlyShip))")
print("\n ** start firing status (kinda realistic 1) **")
print("firing status (kinda realistic):\(firingShip.canSafelyEngageShip3(target: targetShip, friendly: friendlyShip))")
print("\n ** start firing status (kinda realistic 2) **")
print("firing status (kinda realistic first optimization):\(firingShip.canSafelyEngageShip4(target: targetShip, friendly: friendlyShip))")

print("\n** Test primitive region functions **")

print("\n** test Circle **")
let firingCircle = circle(radius:5)
let positionToValidate = Position(x:-3,y:-4)
print ("length of position to validate \( positionToValidate.length)")
print ("validate circle \(firingCircle(positionToValidate))")

print("\n ** test Shift **")
let positionToOffset = Position(x:-1,y:-1)
let shiftedPosition = shift(region: firingCircle, offset: Position(x:0, y:0))
print("shifted position of (2,3) still in cirlcle? \(shiftedPosition( Position(x:3,y:4) ))")

print("\n ** test Invert **")
let invertFunction = invert(region: shift(region: firingCircle, offset: Position(x:0,y:0)))
let invertTestPosition = Position(x:4,y:4)
print("is position \(invertTestPosition) NOT in a firing range with radius 5? \(invertFunction(invertTestPosition))")

print("\n ** test Intersection **")
let region1 = circle(radius:5)
let region2 = circle(radius:10)
let theIntersection = intersection(region1: region1, region2: region2)
let interSectionTestPosition = Position(x:10,y:1)
print("is position \(interSectionTestPosition) in two distinct regions \(theIntersection(interSectionTestPosition))")

print("\n ** test Union **")
let theUnion = union(region1: region1, region2: region2)
let unionTestPosition = Position(x:8,y:7)
print("is position \(unionTestPosition) in either of two distinct regions \(theUnion(unionTestPosition))")


print("\n** test Difference **")
let firingRange = 10.0
let unsafeRange = 5.0
let targetShipPosition = Position(x:5,y:0)
let rangeRegion = difference( region: circle( radius: firingRange ), minus: circle( radius: unsafeRange ) )
print("firing range: \(firingRange) unsafeRange:\(unsafeRange) target ship position \(targetShipPosition) result: \(rangeRegion(targetShipPosition))")



print("\n ** test final optimization **")
print("test results:\(firingShip.testShip(target: targetShip, friendly: friendlyShip))")
print("\n ** final optimization **")
print("firing status (kinda realistic final optimization):\(firingShip.canSafelyEngageShip5(target: targetShip, friendly: friendlyShip))")




