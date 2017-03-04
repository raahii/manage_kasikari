# == Schema Information
#
# Table name: kasikaris
#
#  id           :integer          not null, primary key
#  item_id      :integer          not null
#  from_user_id :integer          not null
#  to_user_id   :integer          not null
#  start_date   :date             not null
#  end_date     :date             not null
#  done_flag    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class KasikariTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
