require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/auth' do
    post 'Registers a new user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' },
          password_confirmation: { type: :string, example: 'password123' },
          first_name: { type: :string, example: 'John' },
          last_name: { type: :string, example: 'Doe' },
          phone_number: { type: :string, example: '1234567890' }
        },
        required: %w[email password password_confirmation first_name last_name phone_number]
      }

      response '200', 'user created' do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'success' },
                 data: { '$ref' => '#/components/schemas/user' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'error' },
                 errors: {
                   type: :object,
                   properties: {
                     full_messages: {
                       type: :array,
                       items: { type: :string },
                       example: ['Email has already been taken']
                     }
                   }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/auth/sign_in' do
    post 'Signs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[email password]
      }

      response '200', 'user signed in' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/user' }
               }
        header 'access-token', schema: { type: :string }, description: 'Authentication token'
        header 'client', schema: { type: :string }, description: 'Client identifier'
        header 'uid', schema: { type: :string }, description: 'User identifier (email)'
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '401', 'invalid credentials' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: ['Invalid login credentials. Please try again.']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/auth/validate_token' do
    get 'Validates authentication token' do
      tags 'Authentication'
      security [bearer_auth: []]
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true

      response '200', 'token is valid' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/user' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '401', 'token is invalid' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: ['Invalid login credentials']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/auth/sign_out' do
    delete 'Signs out current user' do
      tags 'Authentication'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true

      response '200', 'signed out successfully' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true }
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
                   example: ['User was not found or was not logged in.']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end
end
