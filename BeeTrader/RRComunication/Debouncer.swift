import Foundation

class Debouncer {
    private let delay: TimeInterval
    private var timer: Timer?

    var handler: EmptyClosure

    init(_ delay: TimeInterval = 0.4, handler: @escaping () -> Void) {
        self.delay = delay
        self.handler = handler
    }

    func call() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in
            self?.handler()
        })
    }

    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
