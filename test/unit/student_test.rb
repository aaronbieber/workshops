require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  context 'Student' do

    should "not validate without a name" do
      @student = Factory.build(:student)
      @student.first_name = ''
      assert !@student.valid?
    end

    should "not validate without an address" do
      @student = Factory.build(:student)
      @student.address1 = ''
      assert !@student.valid?
    end

  end
end
