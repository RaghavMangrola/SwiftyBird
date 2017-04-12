//
//  SwiftyBird.swift
//  SwiftyBird
//
//  Created by Raghav Mangrola on 4/8/17.
//
//

import Foundation
import SlackKit

class SwiftyBird {

  let bot: SlackKit
  let clientOptions = ClientOptions(simpleLatest: nil, noUnreads: nil, mpimAware: nil, pingInterval: 300, timeout: nil, reconnect: true)
  let errorMessage = "I'm just little chick still learning how to fly, please be patient with me! 🐥"

  init(apiToken: String) {
    bot = SlackKit(withAPIToken: apiToken, clientOptions: clientOptions)
    bot.onClientInitalization = { (client: Client) in
      DispatchQueue.main.async {
        client.messageEventsDelegate = self
      }
    }
  }

  enum Command: String {
    case Hello = "hello"
    case Slap = "slap"
    case Birthday = "birthday"
  }

  func handleCommand(_ client: Client, command: Command, message: Message) {
    switch command {
    case .Hello:

      if let id = message.channel, let messageUser = message.user {
        guard let userInfo = client.users[messageUser] else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        guard let userName = userInfo.name else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        client.webAPI.sendMeMessage(channel: id, text: "hello @\(userName)!", success: nil, failure: nil)
        client.webAPI.sendMeMessage(channel: id, text: ":wave: :hatched_chick:", success: nil, failure: nil)
      }
    case .Slap:

      if let id = message.channel, let messageUser = message.user {
        guard let userInfo = client.users[messageUser] else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        guard let userName = userInfo.name else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        let filteredVictimID = message.text?.components(separatedBy: CharacterSet(charactersIn: "<@>")).filter { $0 != "slap " }.filter{ $0 != "" }

        guard let victimId = filteredVictimID?.first else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        guard let victimInfo = client.users[victimId] else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        guard let victimUserName = victimInfo.name else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        client.webAPI.sendMeMessage(channel: id, text: "@\(userName) slaps @\(victimUserName) around with a large trout 🐟", success: nil, failure: nil)
      }

    case .Birthday:
      if let id = message.channel, let messageUser = message.user {

        guard let userInfo = client.users[messageUser] else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        guard let userName = userInfo.name else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        let seperatedMessage = message.text?.components(separatedBy: CharacterSet(charactersIn: " "))
        let filteredVictimID = seperatedMessage?.filter { $0.contains("<@") }.first
        let splitVictimID = filteredVictimID?.components(separatedBy: CharacterSet(charactersIn: "<@>")).sorted()

        guard let victimId = splitVictimID?.last else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        guard let victimInfo = client.users[victimId] else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        guard let victimUserName = victimInfo.name else {
          client.webAPI.sendMeMessage(channel: id, text: errorMessage, success: nil, failure: nil)
          return
        }

        client.webAPI.sendMeMessage(channel: id, text: "@\(userName) wishes @\(victimUserName) a very happy birthday! 🎂", success: nil, failure: nil)
        client.webAPI.sendMeMessage(channel: id, text: "🎂🎉🙌🎈🎁🐣", success: nil, failure: nil)
      }
    }
  }

}

extension SwiftyBird: MessageEventsDelegate {

  func changed(_ message: Message, client: Client) {}

  func deleted(_ message: Message?, client: Client) {}

  func received(_ message: Message, client: Client) {
    if let id = client.authenticatedUser?.id, let text = message.text {
      if text.lowercased().contains(Command.Hello.rawValue) && text.contains(id) == true {
        handleCommand(client, command: .Hello, message: message)
      }

      if text.lowercased().contains(Command.Slap.rawValue) && message.user != id {
        handleCommand(client, command: .Slap, message: message)
      }

      if text.lowercased().contains(Command.Birthday.rawValue) && message.user != id {
        handleCommand(client, command: .Birthday, message: message)
      }
    }
  }
  
  func sent(_ message: Message, client: Client) {}
  
}
