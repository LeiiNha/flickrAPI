
extension Optional {
    func orDefault(_ defaultExpression: @autoclosure () -> Wrapped) -> Wrapped {
        guard let value = self else {
            return defaultExpression()
        }
        return value
    }
}
