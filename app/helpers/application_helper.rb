# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def hsv_to_rgbhex(h, s, v)
    h = (h > 360 ? 360 : 0 ) unless (0..360).member? h
    s = (s > 1 ? 1 : 0 ) unless (0..1).member? s
    v = (v > 1 ? 1 : 0 ) unless (0..1).member? v

    return (0...3).map { (v * 255).round } if s == 0

    h /= 60.0
    f = h - h.floor
    p = v * (1 - s)
    q = v * (1 - s * f)
    t = v * (1 - s * (1 - f))

    case h.floor 
    when 0
      [v,t,p]
    when 1
      [q,v,p]
    when 2
      [p,v,t]
    when 3
      [p,q,v]
    when 4
      [t,p,v]
    else 
      [v,p,q]
    end.map do |c|
      (c * 255).round.to_s(16).rjust(2, "0")
    end.join
  end
end
