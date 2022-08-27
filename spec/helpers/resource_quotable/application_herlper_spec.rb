# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe ApplicationHelper, type: :helper do
    it { expect(helper.resource_quotable).to eq '<div id="resource_quotable_content"></div>' }

    describe 'delegation' do
      it { expect(helper.respond_to?('dashboard_path')).to be true }
      it { expect(helper.dashboard_path).to eq '/dashboard' }
      it { expect(helper.respond_to?('dashboard_url')).to be true }
      it { expect(helper.dashboard_url).to eq 'http://test.host/dashboard' }
      it { expect(helper.respond_to?('not_defined_path')).to be false }
      it { expect { helper.not_defined_path }.to raise_error(NoMethodError) }
      it { expect(helper.respond_to?('other_method')).to be false }
      it { expect { helper.other_method }.to raise_error(NoMethodError) }
    end
  end
end
