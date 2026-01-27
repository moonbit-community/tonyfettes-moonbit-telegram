///|
test "PaidMediaPreview JSON round-trip" {
  let preview = PaidMediaPreview::new(width=640, height=480, duration=30)
  let media : PaidMedia = Preview(preview)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Preview(p) else { fail("Expected Preview variant") }
  inspect(p.width, content="Some(640)")
  inspect(p.height, content="Some(480)")
  inspect(p.duration, content="Some(30)")
}

///|
test "PaidMediaPreview empty JSON round-trip" {
  let preview = PaidMediaPreview::new()
  let media : PaidMedia = Preview(preview)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Preview(p) else { fail("Expected Preview variant") }
  inspect(p.width, content="None")
  inspect(p.height, content="None")
  inspect(p.duration, content="None")
}

///|
test "PaidMediaPhoto JSON round-trip" {
  let photo_size = PhotoSizePlaceholder::new(
    file_id="photo123",
    file_unique_id="unique123",
    width=800,
    height=600,
  )
  let photo = PaidMediaPhoto::new(photo=[photo_size])
  let media : PaidMedia = Photo(photo)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Photo(p) else { fail("Expected Photo variant") }
  inspect(p.photo.length(), content="1")
  inspect(p.photo[0].file_id, content="photo123")
  inspect(p.photo[0].width, content="800")
}

///|
test "PaidMediaVideo JSON round-trip" {
  let video = VideoPlaceholder::new(
    file_id="video456",
    file_unique_id="unique456",
    width=1920,
    height=1080,
    duration=120,
  )
  let video_media = PaidMediaVideo::new(video~)
  let media : PaidMedia = Video(video_media)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Video(v) else { fail("Expected Video variant") }
  inspect(v.video.file_id, content="video456")
  inspect(v.video.width, content="1920")
  inspect(v.video.height, content="1080")
  inspect(v.video.duration, content="120")
}

///|
test "PaidMediaInfo JSON round-trip" {
  let preview = PaidMediaPreview::new(width=320, height=240)
  let video = VideoPlaceholder::new(
    file_id="vid789",
    file_unique_id="uniq789",
    width=1280,
    height=720,
    duration=60,
  )
  let info = PaidMediaInfo::new(star_count=100, paid_media=[
    Preview(preview),
    Video(PaidMediaVideo::new(video~)),
  ])
  let json = @json.to_json(info)
  let parsed : PaidMediaInfo = @json.from_json(json)
  inspect(parsed.star_count, content="100")
  inspect(parsed.paid_media.length(), content="2")
  guard parsed.paid_media[0] is Preview(p) else {
    fail("Expected Preview as first element")
  }
  inspect(p.width, content="Some(320)")
  guard parsed.paid_media[1] is Video(v) else {
    fail("Expected Video as second element")
  }
  inspect(v.video.duration, content="60")
}

///|
test "PhotoSizePlaceholder JSON round-trip" {
  let photo = PhotoSizePlaceholder::new(
    file_id="file123",
    file_unique_id="unique123",
    width=100,
    height=200,
  )
  let json = @json.to_json(photo)
  let parsed : PhotoSizePlaceholder = @json.from_json(json)
  inspect(parsed.file_id, content="file123")
  inspect(parsed.file_unique_id, content="unique123")
  inspect(parsed.width, content="100")
  inspect(parsed.height, content="200")
}

///|
test "VideoPlaceholder JSON round-trip" {
  let video = VideoPlaceholder::new(
    file_id="vidfile",
    file_unique_id="vidunique",
    width=1920,
    height=1080,
    duration=300,
  )
  let json = @json.to_json(video)
  let parsed : VideoPlaceholder = @json.from_json(json)
  inspect(parsed.file_id, content="vidfile")
  inspect(parsed.file_unique_id, content="vidunique")
  inspect(parsed.width, content="1920")
  inspect(parsed.height, content="1080")
  inspect(parsed.duration, content="300")
}
