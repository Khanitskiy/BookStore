class BookImgUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process :convert => 'png'

  version :my_resize do
    process :resize_to_fit => [290, 435]
  end

  version :resize_to_cart do
    process :resize_to_fit => [56, 90]
  end

end