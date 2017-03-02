class ImageUploader < CarrierWave::Uploader::Base

  # リサイズしたり画像形式を変更するのに必要
  include CarrierWave::RMagick

  # 画像の上限を200pxにする
  process :resize_to_limit => [200, 200]

  # 保存形式をJPGにする
  process :convert => 'jpg'

  # サムネイルを生成する設定
  version :thumb do
    process :resize_to_fill => [40, 40, gravity = ::Magick::CenterGravity]
  end


  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  # jpg,jpeg,gif,pngしか受け付けない
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # 拡張子が同じでないとGIFをJPGとかにコンバートできないので、ファイル名を変更
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end


end
