require 'rails_helper'

RSpec.describe '/sessions', type: :request do
  include Warden::Test::Helpers

  let(:user) { create(:user) }

  describe 'GET /new' do
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
        login_as user, scope: :internal

        get new_sessions_path
        follow_redirect!

        expect(response).to render_template(:index)
      end
    end
  end

  describe 'POST /create' do
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

  describe 'DELETE /destroy' do
    context 'when already logged in' do
      before do
        login_as user, scope: :internal

        delete sessions_path

        follow_redirect!
      end

      it 'expects to render template new' do
        expect(response).to render_template('application/root')
      end

      it 'expects to have message' do
        expect(response.body).to include('Logged out!')
      end
    end
  end

  describe 'GET /token' do
    context 'when given valid token' do
      let(:user) { create(:user) }

      before do
        get token_sessions_path(token: user.email_token)
      end

      it 'expects to log in' do
        follow_redirect!

        expect(response).to render_template('internal/invoices/index')
      end
    end

    context 'when given invalid token' do
      let(:user) { create(:user) }

      before do
        get token_sessions_path(token: '')
      end

      it 'expects to not log in' do
        follow_redirect!

        expect(response.body).to include('User not found.')
      end
    end
  end
end