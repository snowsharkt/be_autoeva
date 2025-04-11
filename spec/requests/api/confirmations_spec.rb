require 'swagger_helper'

RSpec.describe 'Email Confirmation API', type: :request do
  path '/api/auth/confirmation' do
    post 'Resend confirmation instructions' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :confirmation_params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' }
        },
        required: ['email']
      }

      response '200', 'confirmation instructions sent' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'An email has been sent to your account with confirmation instructions.' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '404', 'user not found' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: ['User not found.']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/auth/confirmation' do
    get 'Confirm email address' do
      tags 'Authentication'
      produces 'application/json'
      parameter name: :confirmation_token, in: :query, type: :string, required: true,
                description: 'Token received in confirmation email'
      parameter name: :redirect_url, in: :query, type: :string, required: false,
                description: 'URL to redirect after confirmation (optional)'

      response '200', 'email confirmed successfully' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'Your email address has been successfully confirmed.' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '422', 'invalid or expired token' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: ['Confirmation token is invalid or has expired. Please request a new one.']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end
end
