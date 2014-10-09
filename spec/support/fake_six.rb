require 'sinatra/base'

class FakeSIX < Sinatra::Base
  UI  = 'dummy_login'
  PWD = 'dummy_password'
  ISIN = 'LU0866838575'
  LISTING_ID = '1396252,361,402'

  get '/apid/request' do
    public_send(method_name) if respond_to?(method_name)
  end

  def login
    xml_response (valid_credentials? ? 'successful_login' : 'unsuccessful_login')
  end

  def get_hiku_data
    if listing_id.blank?
      xml_response 'hiku_data_without_id'
    elsif listing_id == LISTING_ID
      xml_response 'hiku_data'
    else
      xml_response 'hiku_data_with_invalid_id'
    end
  end

  def get_listing_id
    if isin.blank?
      xml_response 'listing_id_without_isin'
    elsif isin == ISIN
      xml_response 'listing_id'
    else
      xml_response 'listing_id_for_unknown_isin'
    end
  end

private

  def method_name
    request[:method].underscore
  end

  def listing_id
    params[:ik]
  end

  def isin
    params[:k1]
  end

  def valid_credentials?
    params[:ui] == UI && params[:pwd] == PWD
  end

  def xml_response(file_name, response_code = 200)
    content_type :xml
    status response_code

    File.read(File.join(File.dirname(__FILE__), 'fixtures', "#{file_name}.xml"))
  end
end
