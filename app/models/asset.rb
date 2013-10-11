# == Schema Information
#
# Table name: assets
#
#  id                    :integer          not null, primary key
#  description           :string(255)
#  resource_file_name    :string(255)
#  resource_content_type :string(255)
#  resource_file_size    :integer
#  resource_updated_at   :datetime
#  owner_type            :string(255)
#  owner_id              :integer
#

class Asset < ActiveRecord::Base
  has_attached_file :resource,
    :storage => :fog,
    :fog_credentials => {
      provider: "AWS",
      aws_access_key_id: AWS::Key,
      aws_secret_access_key: AWS::Secret,
      region: AWS::Region
    },
    :fog_public => true,
    :fog_directory => AWS::Region,
    :path => ":id.:extension"

    belongs_to :owner, :polymorphic => true
end
