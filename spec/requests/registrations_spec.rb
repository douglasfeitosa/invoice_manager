require 'rails_helper'

RSpec.describe '/registrations', type: :request do
  include Warden::Test::Helpers

  let(:user) { create(:user) }

  describe 'GET /new' do
    context 'when not yet logged in' do
      it 'expects to render template new' do
        get new_registrations_path

        expect(response).to render_template(:new)
      end
    end

    context 'when already logged in' do
      it 'expects to redirect to template index' do
        login_as user, scope: :internal

        get new_registrations_path

        follow_redirect!

        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET /create' do
    context 'when already logged in' do
      it 'expects to redirect to template index' do
        login_as user, scope: :internal

        post registrations_path(email: 'douglasfeitosa@outlook.com')

        follow_redirect!

        expect(response).to render_template(:index)
      end
    end

    context 'when given valid email' do
      before do
        post registrations_path(user: { email: 'douglasfeitosa@outlook.com' })

        follow_redirect!
      end

      it 'expects to render sessions new' do
        expect(response).to render_template('sessions/new')
      end

      it 'expects to have message' do
        expect(response.body).to include('User was created. Check your email.')
      end
    end

    context 'when given email already registered' do
      let!(:user) { create(:user) }

      it 'expects to render sessions index' do
        post registrations_path(user: { email: user.email })

        follow_redirect!

        expect(response).to render_template('registrations/confirm')
      end
    end

    context 'when given invalid email' do
      it 'expects to render sessions new' do
        post registrations_path(user: { email: '' })

        expect(response).to render_template('registrations/new')
      end
    end
  end

  describe 'GET /confirm' do
    context 'when given valid email' do
      let(:user) { create(:user) }

      before do
        get confirm_registrations_path(email: user.email)
      end

      it 'expects to render sessions new' do
        expect(response).to render_template('registrations/confirm')
      end

      it 'expects to have message' do
        expect(response.body).to include("The user #{user.email} has already an account. Do you want generate another token?")
      end
    end

    context 'when given invalid email' do
      before do
        get confirm_registrations_path(email: '')

        follow_redirect!
      end

      it 'expects to render sessions new' do
        expect(response).to render_template('registrations/new')
      end

      it 'expects to have error message' do
        expect(response.body).to include('User not found.')
      end
    end
  end

  describe 'GET /generate' do
    context 'when given valid email' do
      let(:user) { create(:user) }

      before do
        get generate_registrations_path(email: user.email)

        follow_redirect!
      end

      it 'expects to render sessions new' do
        expect(response).to render_template('application/root')
      end

      it 'expects to have message' do
        expect(response.body).to include("An email was sent to #{user.email}.")
      end
    end

    context 'when given invalid email' do
      before do
        get generate_registrations_path(email: '')

        follow_redirect!
      end

      it 'expects to render sessions new' do
        expect(response).to render_template('application/root')
      end

      it 'expects to have error message' do
        expect(response.body).to include('User not found.')
      end
    end
  end
end
