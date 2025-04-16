require 'swagger_helper'

RSpec.describe 'Favorites API', type: :request do
  path '/api/favorites' do
    get 'Lists all favorites for current user' do
      tags 'Favorites'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      produces 'application/json'

      response '200', 'favorites found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   created_at: { type: :string, format: :datetime },
                   sale_post: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string },
                       description: { type: :string },
                       price: { type: :number },
                       status: { type: :string },
                       year: { type: :integer },
                       odo: { type: :integer },
                       created_at: { type: :string, format: :datetime },
                       updated_at: { type: :string, format: :datetime }
                     }
                   },
                   user: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       email: { type: :string },
                       first_name: { type: :string },
                       last_name: { type: :string }
                     }
                   }
                 },
                 required: ['id', 'created_at', 'sale_post', 'user']
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

  path '/api/favorites/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Favorite ID'

    delete 'Removes a post from favorites' do
      tags 'Favorites'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true

      response '204', 'favorite removed' do
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

      response '404', 'favorite not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Favorite not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/sale_posts/{sale_post_id}/favorites' do
    parameter name: :sale_post_id, in: :path, type: :integer, description: 'Sale Post ID'

    post 'Adds a post to favorites' do
      tags 'Favorites'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true

      response '201', 'favorite created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 sale_post: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string }
                   }
                 },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string }
                   }
                 }
               },
               required: ['id', 'created_at', 'sale_post', 'user']
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

      response '404', 'sale post not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Sale post not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: ['Sale post has already been favorited']
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end
end
