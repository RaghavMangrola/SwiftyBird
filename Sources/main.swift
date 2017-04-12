import Foundation

var apiToken: String?
//apiToken = "API-TOKEN"
if let apiToken = apiToken {
  let swiftyBird = SwiftyBird(apiToken: apiToken)
  RunLoop.main.run()
} else {
  print("Don't forget to set your API Token!")
}
