require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  path '/api/sale_posts/{sale_post_id}/comments' do
    parameter name: :sale_post_id, in: :path, type: :integer, description: 'Sale Post ID'

    get 'Lists all comments for a sale post' do
      tags 'Comments'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      produces 'application/json'

      response '200', 'comments found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   content: { type: :string },
                   created_at: { type: :string, format: :datetime },
                   updated_at: { type: :string, format: :datetime },
                   user: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       email: { type: :string },
                       name: { type: :string }
                     }
                   },
                   sale_post: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string }
                     }
                   }
                 },
                 required: ['id', 'content', 'created_at', 'updated_at', 'user']
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

      response '404', 'sale post not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Sale post not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end

    post 'Creates a comment on a sale post' do
      tags 'Comments'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      consumes 'application/json'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string }
            },
            required: ['content']
          }
        },
        required: ['comment']
      }

      response '201', 'comment created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 content: { type: :string },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string }
                   }
                 },
                 sale_post: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string }
                   }
                 }
               },
               required: ['id', 'content', 'created_at', 'updated_at', 'user', 'sale_post']
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
                   type: :object,
                   properties: {
                     content: {
                       type: :array,
                       items: { type: :string }
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

  path '/api/comments/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Comment ID'

    get 'Retrieves a specific comment' do
      tags 'Comments'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      produces 'application/json'

      response '200', 'comment found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 content: { type: :string },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string }
                   }
                 },
                 sale_post: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string }
                   }
                 }
               },
               required: ['id', 'content', 'created_at', 'updated_at', 'user', 'sale_post']
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

      response '404', 'comment not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Comment not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end

    patch 'Updates a comment' do
      tags 'Comments'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      consumes 'application/json'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          comment: {
            type: :object,
            properties: {
              content: { type: :string }
            },
            required: ['content']
          }
        },
        required: ['comment']
      }

      response '200', 'comment updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 content: { type: :string },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string }
                   }
                 },
                 sale_post: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string }
                   }
                 }
               },
               required: ['id', 'content', 'created_at', 'updated_at', 'user', 'sale_post']
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

      response '403', 'forbidden' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'You are not authorized to perform this action' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '404', 'comment not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Comment not found' }
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
                   properties: {
                     content: {
                       type: :array,
                       items: { type: :string }
                     }
                   }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end

    delete 'Deletes a comment' do
      tags 'Comments'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true

      response '204', 'comment deleted' do
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

      response '403', 'forbidden' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'You are not authorized to perform this action' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '404', 'comment not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Comment not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end
end
