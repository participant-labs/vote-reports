require 'rails_helper'

RSpec.describe Issue do
  describe ".create" do
    context "with a title and some causes" do
      before do
        @causes = [
          create(:cause, name: 'Gun Rights'),
          create(:cause, name: 'Gun Control')
        ]
      end

      it 'succeeds' do
        expect {
          Issue.create!(name: 'Guns', causes: @causes)
        }.to change(Issue, :count).by(1)
      end
    end
  end
end
