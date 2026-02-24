///|
/// Runtime loader for tdjson using dlopen/dlsym.

///|
suberror TdjsonError {
  LoadFailed(String)
  SymbolMissing(@dl.DynamicLibraryError)
} derive(Show)

///|
priv struct Tdjson {
  dl : @dl.DynamicLibrary
  create_client_id : FuncRef[() -> Int]
  send : FuncRef[(Int, @c.Pointer[Byte]) -> Unit]
  receive : FuncRef[(Double) -> @c.Pointer[Byte]]
  execute : FuncRef[(@c.Pointer[Byte]) -> @c.Pointer[Byte]]
}

///|
let tdjson : Result[Tdjson, TdjsonError] = try? load()

///|
fn ensure_tdjson() -> Tdjson raise TdjsonError {
  tdjson.unwrap_or_error()
}

///|
fn load_library(paths : Array[String]) -> @dl.DynamicLibrary? {
  for path in paths {
    match @dl.DynamicLibrary::try_open(path) {
      Some(dl) => return Some(dl)
      None => ()
    }
  } nobreak {
    None
  }
}

///|
fn moon_home() -> String raise {
  if @os.getenv("MOON_HOME") is Some(home) {
    return home
  }
  @path.Path(@os.home()).join(".moon").to_string()
}

///|
fn build_paths() -> Array[String] raise {
  let paths = []
  if @platform.macos {
    paths.push("libtdjson.dylib")
    paths.push(
      @path.Path(moon_home()).join("lib").join("libtdjson.dylib").to_string(),
    )
  } else if @platform.linux {
    paths.push("libtdjson.so")
    paths.push(
      @path.Path(moon_home()).join("lib").join("libtdjson.so").to_string(),
    )
  } else if @platform.win32 || @platform.win64 {
    paths.push("tdjson.dll")
    paths.push(
      @path.Path(moon_home()).join("lib").join("tdjson.dll").to_string(),
    )
  }
  paths
}

///|
fn init {
  @os.atexit(() => match tdjson {
    Ok(tdjson) => ignore(try? tdjson.dl.close())
    _ => ()
  })
}

///|
fn load() -> Tdjson raise TdjsonError {
  let paths = build_paths() catch {
    error => raise LoadFailed("Failed to build library paths: \{error}")
  }
  let dl = match load_library(paths) {
    Some(dl) => dl
    None =>
      raise TdjsonError::LoadFailed(
        "Could not load tdjson library, tried paths: \{paths}",
      )
  }
  {
    dl,
    create_client_id: dl.symbol("td_create_client_id").unsafe_into() catch {
      error => raise TdjsonError::SymbolMissing(error)
    },
    send: dl.symbol("td_send").unsafe_into() catch {
      error => raise TdjsonError::SymbolMissing(error)
    },
    receive: dl.symbol("td_receive").unsafe_into() catch {
      error => raise TdjsonError::SymbolMissing(error)
    },
    execute: dl.symbol("td_execute").unsafe_into() catch {
      error => raise TdjsonError::SymbolMissing(error)
    },
  }
}

///|
pub fn create_client_id() -> Int raise TdjsonError {
  let tdjson = ensure_tdjson()
  (tdjson.create_client_id)()
}

///|
pub fn send(client_id : Int, json : Json) -> Unit raise TdjsonError {
  let tdjson = ensure_tdjson()
  let json = json.stringify()
  let bytes = @encoding/utf8.encode(json)
  @c.borrow_bytes(bytes, ptr => (tdjson.send)(client_id, ptr))
}

///|
pub fn receive(timeout : Double) -> String? raise TdjsonError {
  let tdjson = ensure_tdjson()
  let src = (tdjson.receive)(timeout)
  if src.is_null() {
    return None
  }
  let len = @c.strlen(src)
  let dst = Bytes::make(len.to_int(), 0)
  @c.memcpy(dst, src, len)
  Some(@encoding/utf8.decode_lossy(dst))
}

///|
pub fn execute(json : Json) -> String? raise TdjsonError {
  let tdjson = ensure_tdjson()
  let bytes = @encoding/utf8.encode(json.stringify())
  let src = @c.borrow_bytes(bytes, ptr => (tdjson.execute)(ptr))
  if src.is_null() {
    return None
  }
  let len = @c.strlen(src)
  let dst = Bytes::make(len.to_int(), 0)
  @c.memcpy(dst, src, len)
  Some(@encoding/utf8.decode_lossy(dst))
}
