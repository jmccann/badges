require 'rasem'
require 'rmagick'

def get_hex_color(color, value)
  return color if color =~ /#/
  return color_from_range(value.to_i) if value =~ /(\d+(\.\d+)?)/
  return method(color).call if respond_to?(color, :include_private)
  raise 'Could not determine color'
end

def color_from_range(int) # rubocop:disable MethodLength
  case int
  when 95..100
    brightgreen
  when 90..94
    green
  when 85..89
    yellowgreen
  when 80..84
    yellow
  when 70..79
    orange
  else
    red
  end
end

def svg(subject, value, color = 'green') # rubocop:disable AbcSize, MethodLength
  color = get_hex_color(color, value)

  subject_width = text_width subject
  value_width = text_width value
  width = subject_width + value_width + 20

  img = Rasem::SVGImage.new(width: width, height: 20) do
    l1 = linearGradient('b', x2: '0', y2: '100%') do
      stop('0', '#bbb', '.1')
      stop('1', '#000', '.1')
    end

    mask(id: 'a') do
      rect(0, 0, width, 20, 3, fill: '#fff')
    end

    group(mask: 'url(#a)') do
      path(fill: '#555') do
        moveToA(0, 0)
        hlineTo(subject_width + 10)
        vlineTo(20)
        hlineToA(0)
        close
      end
      path(fill: color) do
        moveToA(subject_width + 10, 0)
        hlineTo(value_width + 10)
        vlineTo(20)
        hlineToA(subject_width + 10)
        close
      end
      path(fill: l1.fill) do
        moveToA(0, 0)
        hlineTo(width)
        vlineTo(20)
        hlineToA(0)
        close
      end
    end

    group(fill: '#fff', 'text-anchor' => 'middle',
          'font-family' => 'DejaVu Sans,Verdana,Geneva,sans-serif',
          'font-size' => 11) do
      text((subject_width / 2) + 5, 15,
           fill: '#010101', 'fill-opacity' => '.3') do
        raw subject
      end
      text((subject_width / 2) + 5, 14, fill: '#fff') do
        raw subject
      end
      text(subject_width + (value_width / 2) + 15, 15,
           fill: '#010101', 'fill-opacity' => '.3') do
        raw value
      end
      text(subject_width + (value_width / 2) + 15, 14, fill: '#fff') do
        raw value
      end
    end
  end
  img.to_s
end

def brightgreen
  '#4C1'
end

def green
  '#97CA00'
end

def yellowgreen
  '#A4A61D'
end

def yellow
  '#DFB317'
end

def orange
  '#FE7D37'
end

def red
  '#E05D44'
end

#
# Determine text width rounded up to next multiple of 10
#
def text_width(text)
  label = Magick::Draw.new
  label.font = 'DejaVu Sans'
  label.text_antialias true
  label.font_size 11
  label.font_style = Magick::NormalStyle
  label.gravity = Magick::CenterGravity
  label.text(0, 0, text)
  metrics = label.get_type_metrics(text)
  metrics.width.to_i.round(-1)
end
