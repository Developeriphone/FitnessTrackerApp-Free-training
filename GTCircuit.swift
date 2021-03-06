import Foundation
import CoreData
@objc(GTCircuit)
final public class GTCircuit: GTExercize, ExercizeCollection {
	override class var objectType: String {
		return "GTCircuit"
	}
	public let collectionType = GTLocalizedString("CIRCUIT", comment: "Circuit")
	@NSManaged public private(set) var exercizes: Set<GTSetsExercize>
	override class func loadWithID(_ id: String, fromDataManager dataManager: DataManager) -> GTCircuit? {
		let req = NSFetchRequest<GTCircuit>(entityName: self.objectType)
		let pred = NSPredicate(format: "id == %@", id)
		req.predicate = pred
		return dataManager.executeFetchRequest(req)?.first
	}
	public override var title: String {
		return collectionType
	}
	public override var summary: String {
		return exercizeList.lazy.map { $0.title }.joined(separator: ", ")
	}
	override public var isValid: Bool {
		return workout != nil && isSubtreeValid
	}
	override var isSubtreeValid: Bool {
		return exercizes.count > 1 && exercizes.reduce(true) { $0 && $1.isValid } && exercizesError.isEmpty
	}
	public override var isPurgeableToValid: Bool {
		return false
	}
	public override var shouldBePurged: Bool {
		return exercizes.isEmpty
	}
	override public var parentLevel: CompositeWorkoutLevel? {
		return workout
	}
	override public var subtreeNodes: Set<GTDataObject> {
		return Set(exercizes.flatMap { $0.subtreeNodes } + [self])
	}
	public override func purge(onlySettings: Bool) -> [GTDataObject] {
		return exercizes.reduce([]) { $0 + $1.purge(onlySettings: onlySettings) }
	}
	public override func removePurgeable() -> [GTDataObject] {
		var res = [GTDataObject]()
		for e in exercizes {
			if e.shouldBePurged {
				res.append(e)
				self.remove(part: e)
			} else {
				res.append(contentsOf: e.removePurgeable())
			}
		}
		recalculatePartsOrder()
		return res
	}
	public var exercizesError: [Int] {
		return GTCircuit.invalidIndices(for: exercizeList.map { $0.setsCount })
	}
	class func invalidIndices(for setsCount: [Int?], mode m: Int?? = nil) -> [Int] {
		let mode = m ?? setsCount.mode
		return zip(setsCount, 0 ..< setsCount.count).filter { $0.0 == nil || $0.0 != mode }.map { $0.1 }
	}
	public var exercizeList: [GTSetsExercize] {
		return Array(exercizes).sorted { $0.order < $1.order }
	}
	public func add(parts: GTSetsExercize...) {
		for se in parts {
			se.order = Int32(self.exercizes.count)
			se.set(circuit: self)
		}
	}
	public func remove(part se: GTSetsExercize) {
		exercizes.remove(se)
		recalculatePartsOrder()
	}
}
