require_relative '../app'
require 'rack/test'
require_relative './spec_helper'


describe 'Home page' do

  context 'GET to /' do
    let(:last_response) { get '/' }

    it 'loads homepage' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
    end

    it 'displays home page content' do
      get '/'
      expect(last_response.body).to include('Hello User!')
    end

    it 'should have a create button' do
      get '/'
      expect(last_response.body).to have_tag(:a, href: '/new', text: 'Create Message')
    end
  end
end

describe 'New message form' do

  context 'GET to /new' do
    let(:last_response) { get '/new' }

    it 'loads form' do
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
    end

    it 'displays a form that POSTs to /new' do
      expect(last_response.body).to have_tag(:form, action: '/new', method: 'post')
    end
  end
end

describe Message do

  it 'should validates_presence_of :name and :password' do
    invalid_msg = Message.new()
    expect(invalid_msg).to_not be_valid

    valid_msg = Message.new(body: 'message', password: 'pass')
    expect(valid_msg).to be_valid
  end

  it "should have all necessary fields" do
    msg = Message.new
    [:body, :password, :delete_way].each do |field|
      expect(msg).to respond_to(field)
    end
  end

  it 'should be instance of Message' do
    msg = Message.new
    expect(msg).to be_instance_of(Message)
  end

  it 'should have correct parameters' do
    msg = Message.create(body:  'message', password: 'pass', delete_way: 'after_hour')

    expect(msg.body).to eq 'message'
    expect(msg.password).to eq 'pass'
    expect(msg.delete_way).to eq 'after_hour'
  end

end

describe DeleteMessages do

 it 'should initialize instance of DeleteMessages class with id of the message' do
    msg = Message.create(body: 'text', password: 'pass', delete_way: 'after_hour')
    del_msg = DeleteMessages.new(msg.id)
    expect(del_msg.id).to eq msg.id
  end

end







