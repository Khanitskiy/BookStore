class BookImgUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process :convert => 'png'

  version :standard do
    process :resize_to_fill => [100, 150, :north]
  end

end