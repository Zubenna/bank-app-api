module Api
  module V1
    class RegistrationsController < ApplicationController
      def index
        users = User.order('created_at ASC')
        render json: { status: 'SUCCESS', message: 'Loaded user list', data: users }, status: :ok
      end

      def create
        user = User.create(user_params)
        if user.save
          render json: { status: 'created', message: 'Saved User', data: user }
        else
          render json: { status: 500, message: 'User not saved', errors: user.errors }
        end
      end

      def update
        user = User.find(params[:id])
        if user.update_attributes(user_params)
          render json: { status: 'SUCCESS', message: 'Updated user', data: user }, status: :ok
        else
          render json: { status: 'ERROR', message: 'User not updated', data: user.errors },
                 status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find(params[:id])
        user.destroy
        render json: { status: 'SUCCESS', message: 'Deleted user', data: user }, status: :ok
      end

      private

      def user_params
        params.permit(:first_name, :last_name, :middle_name, :username, :phone_number, :email, :address,
                      :user_number, :password, :password_confirmation)
      end
    end
  end
end
