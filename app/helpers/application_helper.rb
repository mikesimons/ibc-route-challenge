# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def hsv_to_rgbhex(h, s, v)
    h = 360 if h > 360
    h = 0 if h < 0
    s = 1.0 if s > 1.0
    s = 0 if s < 0
    v = 1.0 if  v > 1.0
    v = 0 if v < 0

    if s == 0
      r = g = b = v
      return [(r * 255).round, (g * 255).round, (b * 255).round]
    end

    h /= 60.0
    i = h.floor
    f = h - i
    p = v * (1 - s)
    q = v * (1 - s * f)
    t = v * (1 - s * (1 - f))

    case i 
    when 0
      r = v
      g = t
      b = p
    when 1
      r = q
      g = v
      b = p
    when 2
      r = p
      g = v
      b = t
    when 3
      r = p
      g = q
      b = v
    when 4
      r = t
      g = p
      b = v
    else 
      r = v
      g = p
      b = q
    end

    return [r,g,b].map do |c|
      (c * 255).round.to_s(16).rjust(2, "0")
    end.join
  end
end
