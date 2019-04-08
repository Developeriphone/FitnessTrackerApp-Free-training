import Foundation
import MBLibrary
extension GTDataObject {
	@objc func export() -> String {
		fatalError("Abstract method not implemented")
	}
	@objc class func `import`(fromXML xml: XMLNode, withDataManager dataManager: DataManager) throws -> GTDataObject {
		let type: GTDataObject.Type
		switch xml.name {
		case GTRepsSet.setTag:
			type = GTRepsSet.self
		case GTSimpleSetsExercize.exercizeTag:
			type = GTSimpleSetsExercize.self
		case GTChoice.choiceTag:
			type = GTChoice.self
		case GTCircuit.circuitTag:
			type = GTCircuit.self
		case GTRest.restTag:
			type = GTRest.self
		case GTWorkout.workoutTag:
			type = GTWorkout.self
		default:
			throw GTError.importFailure([])
		}
		return try type.import(fromXML: xml, withDataManager: dataManager)
	}
}
