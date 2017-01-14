require 'segment/analytics'

Analytics = Segment::Analytics.new({
    write_key: "#{ENV["segment_key"]}",
    on_error: Proc.new { |status, msg| print msg }
})
