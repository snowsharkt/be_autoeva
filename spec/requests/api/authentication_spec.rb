require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/sign_up' do
    post 'Creates a user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            },
            required: %w[email password password_confirmation]
          }
        }
      }

      response '200', 'user created' do
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '422', 'invalid request' do
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/sign_in' do
    post 'Signs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' }
            },
            required: %w[email password]
          }
        }
      }

      response '200', 'user signed in' do
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '401', 'invalid credentials' do
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/current_user' do
    get 'Retrieves current user' do
      tags 'Authentication'
      security [cookie_auth: []]
      produces 'application/json'

      response '200', 'current user retrieved' do
        schema '$ref' => '#/components/schemas/user'
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '401', 'unauthorized' do
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/sign_out' do
    delete 'Signs out current user' do
      tags 'Authentication'
      security [cookie_auth: []]

      response '200', 'signed out successfully' do
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end
end
