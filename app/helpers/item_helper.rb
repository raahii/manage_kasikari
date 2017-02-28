module ItemHelper
  def thumbnail_for(item, options={ size: 80 })
    size = options[:size]
    image_tag item.image.to_s, 
              alt: item.name , class: "gravatar", 
              width: size, height: size
  end
end
