require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  describe "GET #home" do
    xit "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

end
