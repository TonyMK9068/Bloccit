# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  include Sprockets::Helpers::RailsHelper

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fill => [200, 200]
  
  version :small do
    process :resize_to_fill => [70, 70]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
