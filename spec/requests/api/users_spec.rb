require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/users' do
    get 'Lists all users' do
      tags 'Users'
      security [cookie_auth: []]
      produces 'application/json'

      response '200', 'users found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/user' }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/users/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a user' do
      tags 'Users'
      security [cookie_auth: []]
      produces 'application/json'

      response '200', 'user found' do
        schema '$ref' => '#/components/schemas/user'
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '404', 'user not found' do
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/profile' do
    get 'Retrieves user profile' do
      tags 'Users'
      security [cookie_auth: []]
      produces 'application/json'

      response '200', 'profile retrieved' do
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

  path '/api/change_password' do
    post 'Changes user password' do
      tags 'Users'
      security [cookie_auth: []]
      consumes 'application/json'
      parameter name: :password_params, in: :body, schema: {
        type: :object,
        properties: {
          current_password: { type: :string, example: 'current123' },
          password: { type: :string, example: 'new123' },
          password_confirmation: { type: :string, example: 'new123' }
        },
        required: %w[current_password password password_confirmation]
      }

      response '200', 'password changed' do
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
end
