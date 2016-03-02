class BookImgUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process :convert => 'png'

  version :my_resize do
    process :resize_to_fill => [290, 435]
  end

end