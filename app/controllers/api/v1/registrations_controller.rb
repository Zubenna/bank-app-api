module Api
    module V1
      class RegistrationsController < ApplicationController
        def create
          user = User.create(user_params)
          if user.save
            render json: { status: 'created', message: 'Saved Patient', data: user }
          else
            render json: { status: 500, message: 'Patient not saved', errors: user.errors }
          end
        end
  
        private
  
        def user_params
          params.permit(:full_name, :username, :phone_number, :email, :address, :password, :password_confirmation)
        end
      end
    end
  end
  