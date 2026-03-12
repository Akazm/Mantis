import Foundation

public class TransformStack: NSObject {
    
    public static var shared: TransformStack = TransformStack()
    
    public weak var transformDelegate: TransformDelegate?
    
    private var transformAdjustmentsStack: [TransformRecord] = []
    
    public var top: Int = 0
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.undoStatusChanged(notification:)),
            name: .NSUndoManagerCheckpoint,
            object: nil)
    }
    
    public func pushTransformRecord(_ record: TransformRecord) {
        if transformAdjustmentsStack.count > top {
            transformAdjustmentsStack.remove(at: top)
        }
        transformAdjustmentsStack.insert(record, at: top)
        top += 1
    }

    public func popTransformStack() {
        if top > 0 {
            top -= 1
        }
    }
    
    public func reset() {
        transformAdjustmentsStack.removeAll()
        top = 0
    }
    
    @objc public func undoStatusChanged(notification: NSNotification?) {
        guard let transformDelegate = transformDelegate else { return }
        transformDelegate.updateEnableStateForUndo(transformDelegate.isUndoEnabled())
        transformDelegate.updateEnableStateForRedo(transformDelegate.isRedoEnabled())
    }
    
    public func pushTransformRecordOntoStack(transformType: TransformType, previous: CropState, current: CropState, userGenerated: Bool) {
        if userGenerated {
            
            let actionString: String
            
            switch transformType {
            case .transform:
                actionString = LocalizedHelper.getString("Mantis.ChangeCrop", value: "Change Crop")
            case .resetTransforms:
                actionString = LocalizedHelper.getString("Mantis.ResetChanges", value: "Reset Changes")
            }
            
            let previousValue: [String: CropState] = [.kCurrentTransformState: previous]
            let currentValue: [String: CropState] = [.kCurrentTransformState: current]
            
            let transformRecord = TransformRecord(transformType: transformType, 
                                                  actionName: actionString,
                                                  previousValues: previousValue,
                                                  currentValues: currentValue)
            
            transformRecord.addAdjustmentToStack()
        }
    }
}
