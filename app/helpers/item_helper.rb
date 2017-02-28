module ItemHelper
  def thumbnail_for(item, options={ size: 80 })
    size = options[:size]
    image_url = item.image.present? ? item.image.to_s : "http://placehold.it/80x80"
    image_tag image_url, 
              alt: item.name , class: "gravatar", 
              width: size, height: size
  end
end
