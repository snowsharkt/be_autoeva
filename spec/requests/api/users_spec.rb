require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/users/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'User ID'

    get 'Retrieves a user' do
      tags 'Users'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      produces 'application/json'

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string },
                     role: { type: :string },
                     created_at: { type: :string, format: :datetime }
                   },
                   required: ['id', 'email', 'role']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '404', 'user not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'User not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end

    put 'Updates a user' do
      tags 'Users'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string, example: 'John' },
              last_name: { type: :string, example: 'Doe' },
              email: { type: :string, example: 'john.doe@example.com' },
              role: { type: :string, example: 'user', description: 'Only admins can update role' }
            }
          }
        }
      }

      response '200', 'user updated' do
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string },
                     role: { type: :string },
                     created_at: { type: :string, format: :datetime }
                   }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '403', 'not authorized' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Not authorized' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '404', 'user not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'User not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: {
                     type: :array,
                     items: { type: :string }
                   },
                   example: { email: ['has already been taken'] }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/profile' do
    get 'Retrieves current user profile' do
      tags 'Users'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      produces 'application/json'

      response '200', 'profile retrieved' do
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string },
                     role: { type: :string },
                     created_at: { type: :string, format: :datetime }
                   }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: ['Authorized users only.']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/change_password' do
    post 'Changes user password' do
      tags 'Users'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
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
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Current password is incorrect' },
                 errors: {
                   type: :object,
                   additionalProperties: {
                     type: :array,
                     items: { type: :string }
                   },
                   example: {
                     password_confirmation: ["doesn't match Password"]
                   }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end
end
