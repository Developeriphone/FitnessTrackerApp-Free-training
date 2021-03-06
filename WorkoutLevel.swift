import Foundation
public protocol WorkoutLevel {
	var parentLevel: CompositeWorkoutLevel? { get }
}
extension WorkoutLevel {
	var parentHierarchy: [CompositeWorkoutLevel] {
		var res: [CompositeWorkoutLevel] = []
		var top = self.parentLevel
		while let t = top {
			res.append(t)
			top = t.parentLevel
		}
		return res
	}
}
public protocol CompositeWorkoutLevel: WorkoutLevel {
	var childrenList: [GTPart] { get }
}
public protocol ExercizeCollection: CompositeWorkoutLevel {
	associatedtype Exercize: GTPart
	var collectionType: String { get }
	var exercizes: Set<Exercize> { get }
	var exercizeList: [Exercize] { get }
	func add(parts: Exercize...)
	func remove(part: Exercize)
}
extension ExercizeCollection {
	public var childrenList: [GTPart] {
		return exercizeList
	}
	public subscript (n: Int32) -> Exercize? {
		return exercizes.first { $0.order == n }
	}
	public func movePart(at from: Int32, to dest: Int32) {
		guard let e = self[from], dest < exercizes.count else {
			return
		}
		let newIndex = dest > from ? dest + 1 : dest
		_ = exercizes.map {
			if Int($0.order) >= newIndex {
				$0.order += 1
			}
		}
		e.order = newIndex
		recalculatePartsOrder()
	}
	func recalculatePartsOrder() {
		var i: Int32 = 0
		for s in exercizeList {
			s.order = i
			i += 1
		}
	}
}
public protocol NamedExercizeCollection: ExercizeCollection {
	var name: String { get }
	func set(name: String)
}
