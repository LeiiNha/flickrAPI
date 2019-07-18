
public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Encoding parameters went wrong"
    case missingUrl = "Url is missing"
    case failedBuildRequest = "There was an issue building request"
}
