///|
test "BackgroundFillSolid JSON round-trip" {
  let fill = BackgroundFill::Solid(BackgroundFillSolid::new(color=0xFF0000))
  let json = @json.to_json(fill)
  let parsed : BackgroundFill = @json.from_json(json)
  guard parsed is Solid(s) else { fail("Expected Solid variant") }
  inspect(s.color, content="16711680")
}

///|
test "BackgroundFillGradient JSON round-trip" {
  let fill = BackgroundFill::Gradient(
    BackgroundFillGradient::new(
      top_color=0xFF0000,
      bottom_color=0x00FF00,
      rotation_angle=45,
    ),
  )
  let json = @json.to_json(fill)
  let parsed : BackgroundFill = @json.from_json(json)
  guard parsed is Gradient(g) else { fail("Expected Gradient variant") }
  inspect(g.top_color, content="16711680")
  inspect(g.bottom_color, content="65280")
  inspect(g.rotation_angle, content="45")
}

///|
test "BackgroundFillFreeformGradient JSON round-trip" {
  let fill = BackgroundFill::FreeformGradient(
    BackgroundFillFreeformGradient::new(colors=[0xFF0000, 0x00FF00, 0x0000FF]),
  )
  let json = @json.to_json(fill)
  let parsed : BackgroundFill = @json.from_json(json)
  guard parsed is FreeformGradient(fg) else {
    fail("Expected FreeformGradient variant")
  }
  inspect(fg.colors, content="[16711680, 65280, 255]")
}

///|
test "BackgroundTypeFill JSON round-trip" {
  let bg_type = BackgroundType::Fill(
    BackgroundTypeFill::new(
      fill=BackgroundFill::Solid(BackgroundFillSolid::new(color=0xABCDEF)),
      dark_theme_dimming=50,
    ),
  )
  let json = @json.to_json(bg_type)
  let parsed : BackgroundType = @json.from_json(json)
  guard parsed is Fill(f) else { fail("Expected Fill variant") }
  inspect(f.dark_theme_dimming, content="50")
  guard f.fill is Solid(s) else { fail("Expected Solid fill") }
  inspect(s.color, content="11259375")
}

///|
test "BackgroundTypeWallpaper JSON round-trip" {
  let bg_type = BackgroundType::Wallpaper(
    BackgroundTypeWallpaper::new(
      document=DocumentPlaceholder::new(
        file_id="abc123",
        file_unique_id="unique456",
      ),
      dark_theme_dimming=30,
      is_blurred=true,
      is_moving=false,
    ),
  )
  let json = @json.to_json(bg_type)
  let parsed : BackgroundType = @json.from_json(json)
  guard parsed is Wallpaper(w) else { fail("Expected Wallpaper variant") }
  inspect(w.document.file_id, content="abc123")
  inspect(w.dark_theme_dimming, content="30")
  inspect(w.is_blurred, content="Some(true)")
  inspect(w.is_moving, content="Some(false)")
}

///|
test "BackgroundTypeWallpaper JSON round-trip without optional fields" {
  let bg_type = BackgroundType::Wallpaper(
    BackgroundTypeWallpaper::new(
      document=DocumentPlaceholder::new(
        file_id="abc123",
        file_unique_id="unique456",
      ),
      dark_theme_dimming=30,
    ),
  )
  let json = @json.to_json(bg_type)
  let parsed : BackgroundType = @json.from_json(json)
  guard parsed is Wallpaper(w) else { fail("Expected Wallpaper variant") }
  inspect(w.is_blurred, content="None")
  inspect(w.is_moving, content="None")
}

///|
test "BackgroundTypePattern JSON round-trip" {
  let bg_type = BackgroundType::Pattern(
    BackgroundTypePattern::new(
      document=DocumentPlaceholder::new(
        file_id="pattern123",
        file_unique_id="unique789",
      ),
      fill=BackgroundFill::Gradient(
        BackgroundFillGradient::new(
          top_color=0xFFFFFF,
          bottom_color=0x000000,
          rotation_angle=90,
        ),
      ),
      intensity=75,
      is_inverted=true,
    ),
  )
  let json = @json.to_json(bg_type)
  let parsed : BackgroundType = @json.from_json(json)
  guard parsed is Pattern(p) else { fail("Expected Pattern variant") }
  inspect(p.document.file_id, content="pattern123")
  inspect(p.intensity, content="75")
  inspect(p.is_inverted, content="Some(true)")
  inspect(p.is_moving, content="None")
}

///|
test "BackgroundTypeChatTheme JSON round-trip" {
  let bg_type = BackgroundType::ChatTheme(
    BackgroundTypeChatTheme::new(theme_name="dark_mode"),
  )
  let json = @json.to_json(bg_type)
  let parsed : BackgroundType = @json.from_json(json)
  guard parsed is ChatTheme(ct) else { fail("Expected ChatTheme variant") }
  inspect(ct.theme_name, content="dark_mode")
}

///|
test "ChatBackground JSON round-trip" {
  let background = ChatBackground::new(
    type_=BackgroundType::Fill(
      BackgroundTypeFill::new(
        fill=BackgroundFill::Solid(BackgroundFillSolid::new(color=0x123456)),
        dark_theme_dimming=25,
      ),
    ),
  )
  let json = @json.to_json(background)
  let parsed : ChatBackground = @json.from_json(json)
  guard parsed.type_ is Fill(f) else { fail("Expected Fill type") }
  inspect(f.dark_theme_dimming, content="25")
}
