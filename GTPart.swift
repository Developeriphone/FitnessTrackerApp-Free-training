import Foundation
import CoreData
@objc(GTPart)
public class GTPart: GTDataObject, WorkoutLevel {
	final private let workoutKey = "workout"
	final private let orderKey = "order"
	@NSManaged final private(set) var workout: GTWorkout?
    @NSManaged final public var order: Int32
	func set(workout w: GTWorkout?) {
		let old = self.workout
		self.workout = w
		old?.recalculatePartsOrder()
	}
	public var parentLevel: CompositeWorkoutLevel? {
		fatalError("Abstract property not implemented")
	}
	override var wcObject: WCObject? {
		guard let obj = super.wcObject else {
			return nil
		}
		if let w = workout?.recordID.wcRepresentation {
			obj[workoutKey] = w
		}
		obj[orderKey] = order
		return obj
	}
	override func mergeUpdatesFrom(_ src: WCObject, inDataManager dataManager: DataManager) -> Bool {
		guard super.mergeUpdatesFrom(src, inDataManager: dataManager) else {
			return false
		}
		guard let order = src[orderKey] as? Int32 else {
				return false
		}
		self.workout = CDRecordID(wcRepresentation: src[workoutKey] as? [String])?.getObject(fromDataManager: dataManager) as? GTWorkout
		self.order = order
		return true
	}
}
