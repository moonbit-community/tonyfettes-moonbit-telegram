using @json {type Json}

///|
/// Build Telegram API success response JSON
fn[T : @json.ToJson] telegram_success(result : T) -> String {
  let response : Map[String, Json] = {
    "ok": @json.to_json(true),
    "result": @json.to_json(result),
  }
  @json.stringify(@json.to_json(response))
}

///|
/// Build Telegram API error response JSON
fn telegram_error(code : Int, description : String) -> String {
  let response : Map[String, Json] = {
    "ok": @json.to_json(false),
    "error_code": @json.to_json(code),
    "description": @json.to_json(description),
  }
  @json.stringify(@json.to_json(response))
}

///|
/// Mock server that handles a single request and responds
async fn run_mock_server(
  server : @http.Server,
  handler : async (@http.Request, &@io.Reader, @http.ServerConnection) -> Unit,
) -> Unit {
  let (conn, _) = server.accept()
  defer conn.close()
  let request = conn.read_request()
  handler(request, conn, conn)
  conn.end_response()
}

// =============================================================================
// Category 1: Success Path Tests
// =============================================================================

///|
async test "integration: get_me success" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      request,
      _body,
      conn,
    ) => {
      guard request.path.contains("getMe") else {
        conn.send_response(404, "Not Found")
        return
      }
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      let user = User::new(id=123L, is_bot=true, first_name="TestBot")
      conn.write(telegram_success(user))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let user = bot.get_me()
    inspect(user.id, content="123")
    inspect(user.is_bot, content="true")
    inspect(user.first_name, content="TestBot")
    @async.sleep(100)
  })
}

///|
async test "integration: send_message success" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    let received_body = StringBuilder::new()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      request,
      body,
      conn,
    ) => {
      guard request.path.contains("sendMessage") else {
        conn.send_response(404, "Not Found")
        return
      }
      // Capture request body
      while body.read_some() is Some(data) {
        received_body.write_string(@encoding/utf8.decode(data))
      }
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      let chat = Chat::new(id=456L, type_=Private)
      let message = Message::new(message_id=1, date=1234567890, chat~)
      conn.write(telegram_success(message))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let message = bot.send_message(chat_id=456L, text="Hello, World!")
    inspect(message.message_id, content="1")
    inspect(message.chat.id, content="456")
    // Verify request body contains required fields
    let body_str = received_body.to_string()
    inspect(body_str.contains("chat_id"), content="true")
    inspect(body_str.contains("456"), content="true")
    inspect(body_str.contains("text"), content="true")
    inspect(body_str.contains("Hello, World!"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: get_updates success" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      request,
      _body,
      conn,
    ) => {
      guard request.path.contains("getUpdates") else {
        conn.send_response(404, "Not Found")
        return
      }
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      let chat = Chat::new(id=789L, type_=Private)
      let message = Message::new(
        message_id=1,
        date=1234567890,
        chat~,
        text="Test message",
      )
      let updates : Array[Update] = [
        Update::new(update_id=100, message~),
        Update::new(update_id=101),
      ]
      conn.write(telegram_success(updates))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let updates = bot.get_updates()
    inspect(updates.length(), content="2")
    inspect(updates[0].update_id, content="100")
    inspect(updates[0].message.unwrap().text, content="Some(\"Test message\")")
    inspect(updates[1].update_id, content="101")
    @async.sleep(100)
  })
}

// =============================================================================
// Category 2: Telegram API Error Tests
// =============================================================================

///|
async test "integration: 401 Unauthorized" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      conn.write(telegram_error(401, "Unauthorized"))
    }))
    let bot = Bot::new(
      token="invalid_token",
      base_url="http://127.0.0.1:\{port}",
    )
    let result : Result[User, Error] = Ok(bot.get_me()) catch { e => Err(e) }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("ApiError"), content="true")
    inspect(e.to_string().contains("401"), content="true")
    inspect(e.to_string().contains("Unauthorized"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: 400 Bad Request" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      conn.write(telegram_error(400, "Bad Request: chat not found"))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let result : Result[Message, Error] = Ok(
      bot.send_message(chat_id=999L, text="Hello"),
    ) catch {
      e => Err(e)
    }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("ApiError"), content="true")
    inspect(e.to_string().contains("400"), content="true")
    inspect(e.to_string().contains("chat not found"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: 429 Too Many Requests" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      conn.write(telegram_error(429, "Too Many Requests: retry after 30"))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let result : Result[User, Error] = Ok(bot.get_me()) catch { e => Err(e) }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("ApiError"), content="true")
    inspect(e.to_string().contains("429"), content="true")
    inspect(e.to_string().contains("Too Many Requests"), content="true")
    @async.sleep(100)
  })
}

// =============================================================================
// Category 3: HTTP Error Tests
// =============================================================================

///|
async test "integration: 500 Internal Server Error" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(500, "Internal Server Error")
      conn.write("Server crashed")
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let result : Result[User, Error] = Ok(bot.get_me()) catch { e => Err(e) }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("HttpError"), content="true")
    inspect(e.to_string().contains("500"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: 502 Bad Gateway" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(502, "Bad Gateway")
      conn.write("Upstream error")
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let result : Result[User, Error] = Ok(bot.get_me()) catch { e => Err(e) }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("HttpError"), content="true")
    inspect(e.to_string().contains("502"), content="true")
    @async.sleep(100)
  })
}

// =============================================================================
// Category 4: Parsing Error Tests
// =============================================================================

///|
async test "integration: InvalidJson - malformed JSON" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      conn.write("{invalid json}")
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let result : Result[User, Error] = Ok(bot.get_me()) catch { e => Err(e) }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("InvalidJson"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: InvalidResponse - missing ok field" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      // Missing "ok" field
      conn.write("{\"result\": {}}")
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let result : Result[User, Error] = Ok(bot.get_me()) catch { e => Err(e) }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("InvalidResponse"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: InvalidResult - wrong result type" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      _request,
      _body,
      conn,
    ) => {
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      // Result is a string instead of User object
      conn.write("{\"ok\": true, \"result\": \"not a user object\"}")
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let result : Result[User, Error] = Ok(bot.get_me()) catch { e => Err(e) }
    guard result is Err(e) else { fail("Expected error") }
    inspect(e.to_string().contains("InvalidResult"), content="true")
    @async.sleep(100)
  })
}

// =============================================================================
// Category 5: Request Validation Tests
// =============================================================================

///|
async test "integration: send_message includes optional fields" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    let received_body = StringBuilder::new()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      request,
      body,
      conn,
    ) => {
      guard request.path.contains("sendMessage") else {
        conn.send_response(404, "Not Found")
        return
      }
      while body.read_some() is Some(data) {
        received_body.write_string(@encoding/utf8.decode(data))
      }
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      let chat = Chat::new(id=456L, type_=Private)
      let message = Message::new(message_id=1, date=1234567890, chat~)
      conn.write(telegram_success(message))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let _ = bot.send_message(
      chat_id=456L,
      text="Hello",
      parse_mode="HTML",
      disable_notification=true,
    )
    let body_str = received_body.to_string()
    // Required fields
    inspect(body_str.contains("chat_id"), content="true")
    inspect(body_str.contains("text"), content="true")
    // Optional fields that were set
    inspect(body_str.contains("parse_mode"), content="true")
    inspect(body_str.contains("HTML"), content="true")
    inspect(body_str.contains("disable_notification"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: send_message excludes unset optional fields" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    let received_body = StringBuilder::new()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      request,
      body,
      conn,
    ) => {
      guard request.path.contains("sendMessage") else {
        conn.send_response(404, "Not Found")
        return
      }
      while body.read_some() is Some(data) {
        received_body.write_string(@encoding/utf8.decode(data))
      }
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      let chat = Chat::new(id=456L, type_=Private)
      let message = Message::new(message_id=1, date=1234567890, chat~)
      conn.write(telegram_success(message))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    // Only required fields
    let _ = bot.send_message(chat_id=456L, text="Hello")
    let body_str = received_body.to_string()
    // Required fields should be present
    inspect(body_str.contains("chat_id"), content="true")
    inspect(body_str.contains("text"), content="true")
    // Optional fields should NOT be present
    inspect(body_str.contains("parse_mode"), content="false")
    inspect(body_str.contains("disable_notification"), content="false")
    inspect(body_str.contains("reply_to_message_id"), content="false")
    inspect(body_str.contains("reply_markup"), content="false")
    @async.sleep(100)
  })
}

///|
async test "integration: get_updates with optional parameters" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    let received_body = StringBuilder::new()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      request,
      body,
      conn,
    ) => {
      guard request.path.contains("getUpdates") else {
        conn.send_response(404, "Not Found")
        return
      }
      while body.read_some() is Some(data) {
        received_body.write_string(@encoding/utf8.decode(data))
      }
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      let updates : Array[Update] = []
      conn.write(telegram_success(updates))
    }))
    let bot = Bot::new(token="test_token", base_url="http://127.0.0.1:\{port}")
    let _ = bot.get_updates(offset=100, limit=10, timeout=30, allowed_updates=[
      "message", "callback_query",
    ])
    let body_str = received_body.to_string()
    inspect(body_str.contains("offset"), content="true")
    inspect(body_str.contains("100"), content="true")
    inspect(body_str.contains("limit"), content="true")
    inspect(body_str.contains("10"), content="true")
    inspect(body_str.contains("timeout"), content="true")
    inspect(body_str.contains("30"), content="true")
    inspect(body_str.contains("allowed_updates"), content="true")
    inspect(body_str.contains("message"), content="true")
    inspect(body_str.contains("callback_query"), content="true")
    @async.sleep(100)
  })
}

///|
async test "integration: URL construction with token" {
  @async.with_task_group(group => {
    let server = @http.Server::new(@socket.Addr::parse("127.0.0.1:0"))
    let port = server.addr().port()
    let received_path = StringBuilder::new()
    group.spawn_bg(no_wait=true, () => run_mock_server(server, (
      request,
      _body,
      conn,
    ) => {
      received_path.write_string(request.path)
      conn.send_response(200, "OK", extra_headers={
        "Content-Type": "application/json",
      })
      let user = User::new(id=123L, is_bot=true, first_name="Bot")
      conn.write(telegram_success(user))
    }))
    let bot = Bot::new(
      token="my_secret_token_123",
      base_url="http://127.0.0.1:\{port}",
    )
    let _ = bot.get_me()
    let path = received_path.to_string()
    // URL should contain /bot<token>/<method>
    inspect(path.contains("/botmy_secret_token_123/"), content="true")
    inspect(path.contains("getMe"), content="true")
    @async.sleep(100)
  })
}
