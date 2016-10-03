require 'rails_helper'

RSpec.describe Idea, type: :model do
  it { should validate_presence_of(:title) }
  it { should have_db_column(:body) }
  it { should have_db_column(:quality).with_options(default: :swill) }
  it do
    should define_enum_for(:quality).with([:swill, :plausible, :genius])
  end
end
