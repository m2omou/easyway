class Warning < ActiveRecord::Base
  mount_uploader :picture, PictureUploader
end
