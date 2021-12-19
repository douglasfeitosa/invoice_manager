require 'rails_helper'

RSpec.describe '/sessions', type: :request do
  include Warden::Test::Helpers

  let(:user) { create(:user) }

  describe 'GET /sessions/new' do
    context 'when access login page' do
      it 'expects to render template new' do
        get new_sessions_path

        expect(response).to render_template(:new)
      end

      it 'expects to not have error message' do
        get new_sessions_path

        expect(response.body).not_to include('Invalid token')
      end
    end

    context 'when already logged in' do
      it 'expects to redirect to template index' do
        login_as user

        get new_sessions_path
        follow_redirect!

        expect(response).to render_template(:index)
      end
    end
  end

  describe 'POST /sessions' do
    before do
      post sessions_path, params: { user: { token: token } }
      follow_redirect!
    end

    context 'when token is valid' do
      let(:token) { user.token }

      it 'expects sign in and render template index' do
        expect(response).to render_template(:index)
      end
    end

    context 'when token is invalid' do
      let(:token) { '' }

      it 'expects to render template new' do
        expect(response).to render_template(:new)
      end

      it 'expects to have error message' do
        expect(response.body).to include('Invalid token')
      end
    end
  end

  describe 'DELETE /sessions' do
    context 'when already logged in' do
      before do
        login_as user

        delete sessions_path

        follow_redirect!
      end

      it 'expects to render template new' do
        expect(response).to render_template('application/index')
      end

      it 'expects to have message' do
        expect(response.body).to include('Logged out!')
      end
    end
  end
end