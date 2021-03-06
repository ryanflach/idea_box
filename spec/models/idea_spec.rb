require 'rails_helper'

RSpec.describe Idea, type: :model do
  it { should validate_presence_of(:title) }
  it { should have_db_column(:body) }
  it { should have_db_column(:quality).with_options(default: :swill) }
  it {
    should define_enum_for(:quality).with([:swill, :plausible, :genius])
  }

  it 'can return ideas by descending created_at date' do
    old_idea = create(:idea)
    new_idea = create(:idea)

    expect(Idea.all_by_newest).to eq([new_idea, old_idea])
  end
end
