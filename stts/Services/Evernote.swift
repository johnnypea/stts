//
//  Evernote.swift
//  stts
//

import Kanna

class Evernote: Service {
    let url = URL(string: "http://status.evernote.com")!

    override func updateStatus(callback: @escaping (BaseService) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let selfie = self else { return }
            defer { callback(selfie) }

            guard let data = data else { return selfie._fail(error) }
            guard let body = String(data: data, encoding: .utf8) else { return selfie._fail("Unreadable response") }
            guard let doc = try? HTML(html: body, encoding: .utf8) else { return selfie._fail("Couldn't parse response") }

            let (status, message) = selfie.status(from: doc)
            self?.status = status
            self?.message = message
        }.resume()
    }
}

extension Evernote {
    fileprivate func status(from document: HTMLDocument) -> (ServiceStatus, String) {
        guard let mostRecentPost = document.css(".post h3").first?.text else { return (.undetermined, "") }

        if mostRecentPost.hasPrefix("[ok]") {
            return (.good, mostRecentPost)
        } else if mostRecentPost.hasPrefix("[!]") {
            return (.major, mostRecentPost)
        } else {
            return (.maintenance, mostRecentPost)
        }
    }
}
