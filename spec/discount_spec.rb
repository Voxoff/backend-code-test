require 'spec_helper'
require 'discount'

RSpec.describe Discount do
  describe '#find_by_item' do
    subject { Discount.new(discounts: discount_database) }
    let(:discount_database) {
      {
        apple: :free,
        pear: :some_code,
      }
    }
    let(:item) { :apple }

    it 'retreives code from databse' do
      expect(subject.find_by_item(item)).to eq :free
    end
  end
end
