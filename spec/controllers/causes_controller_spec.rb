require 'spec_helper'

describe CausesController do
  describe 'GET index' do
    let(:with_many_causes) {
      35.times { create_cause }
    }
    context 'without params' do
      it 'shows the first page of causes' do
        with_many_causes
        get :index
        assigns[:causes].should == Cause.order(:name).page(1)
      end
    end
    context 'with a page' do
      it 'shows that page of causes' do
        with_many_causes
        get :index, page: 2
        assigns[:causes].should == Cause.order(:name).page(2)
      end
    end
  end
end
