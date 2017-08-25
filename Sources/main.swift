//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

struct Filter404: HTTPResponseFilter {
  func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
    callback(.continue)
  }

  func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
    if case .notFound = response.status {
      let f = File("./webroot/notFound.html")
      let html: String
      do {
        try f.open(.read)
        html = try f.readString()
        f.close()
      }catch {
        html = "\(error)"
      }
      response.setBody(string: html)
      response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
      callback(.done)
    } else {
      callback(.continue)
    }
  }
}

let server = HTTPServer()
server.setResponseFilters([(Filter404(), .high)])
server.serverPort = 8181
try server.start()
