require 'net/http'
require 'tempfile'
require 'uri'

module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Manage-kasi-kari"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def thumbnail_for(object, options={ size: 80 })
    class_name = "thumbnail_#{object.model_name.to_s.downcase}"
    size = options[:size]
    image = object.image.present? ? object.image.to_s : "/images/dummy.png"

    image_tag image,
      alt: object.name , class: class_name,
      width: size, height: size
  end

  def save_to_tempfile(url)
    save_dir = "#{Rails.root}/public/tmp/"
    file_name = "#{SecureRandom.urlsafe_base64}"

    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port) do |http|
      resp = http.get(uri.path)
      file = Tempfile.new(file_name, save_dir, 'wb+')
      file.binmode
      file.write(resp.body)
      file.flush
      file
    end
  end

  def print_time(time)
    time_ago_in_words(time) + "前"
  end
end
