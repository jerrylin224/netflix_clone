class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  process resize_to_fit: [665, 375]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end