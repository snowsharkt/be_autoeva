require 'swagger_helper'

RSpec.describe 'Sale Posts API', type: :request do
  path '/api/sale_posts' do
    get 'Lists all sale posts' do
      tags 'Sale Posts'
      produces 'application/json'

      response '200', 'sale posts found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   description: { type: :string },
                   price: { type: :number },
                   status: { type: :string, enum: ['active', 'sold'] },
                   year: { type: :integer },
                   odo: { type: :integer },
                   created_at: { type: :string, format: :datetime },
                   updated_at: { type: :string, format: :datetime },
                   user: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       email: { type: :string }
                     }
                   },
                   brand: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   },
                   model: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   },
                   version: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   },
                   sale_post_images: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         image_url: { type: :string }
                       }
                     }
                   }
                 },
                 required: ['id', 'title', 'status', 'user', 'brand', 'model', 'version']
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end

    post 'Creates a sale post' do
      tags 'Sale Posts'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      consumes 'application/json'
      parameter name: :sale_post_params, in: :body, schema: {
        type: :object,
        properties: {
          sale_post: {
            type: :object,
            properties: {
              title: { type: :string, example: '2020 Toyota Land Cruiser VX' },
              description: { type: :string, example: 'Excellent condition, one owner' },
              price: { type: :number, example: 50000 },
              status: { type: :string, enum: ['active', 'sold'], example: 'active' },
              year: { type: :integer, example: 2020 },
              odo: { type: :integer, example: 15000 },
              brand_id: { type: :integer, example: 1 },
              model_id: { type: :integer, example: 1 },
              version_id: { type: :integer, example: 1 }
            },
            required: ['title', 'status', 'brand_id', 'model_id', 'version_id']
          },
          images: {
            type: :array,
            items: { type: :string },
            example: ['http://example.com/image1.jpg', 'http://example.com/image2.jpg']
          }
        },
        required: ['sale_post']
      }

      response '201', 'sale post created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 description: { type: :string },
                 price: { type: :number },
                 status: { type: :string },
                 year: { type: :integer },
                 odo: { type: :integer },
                 user_id: { type: :integer },
                 brand_id: { type: :integer },
                 model_id: { type: :integer },
                 version_id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime },
                 sale_post_images: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       image_url: { type: :string }
                     }
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

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: {
                     type: :array,
                     items: { type: :string }
                   },
                   example: { title: ['can\'t be blank'] }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/sale_posts/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Sale Post ID'

    get 'Retrieves a sale post' do
      tags 'Sale Posts'
      produces 'application/json'

      response '200', 'sale post found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 description: { type: :string },
                 price: { type: :number },
                 status: { type: :string },
                 year: { type: :integer },
                 odo: { type: :integer },
                 user_id: { type: :integer },
                 brand_id: { type: :integer },
                 model_id: { type: :integer },
                 version_id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string }
                   }
                 },
                 brand: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string }
                   }
                 },
                 model: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string }
                   }
                 },
                 version: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string }
                   }
                 },
                 sale_post_images: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       image_url: { type: :string }
                     }
                   }
                 },
                 comments: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       content: { type: :string },
                       user: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           email: { type: :string }
                         }
                       }
                     }
                   }
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

    put 'Updates a sale post' do
      tags 'Sale Posts'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      consumes 'application/json'
      parameter name: :sale_post_params, in: :body, schema: {
        type: :object,
        properties: {
          sale_post: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Updated Toyota Land Cruiser VX' },
              description: { type: :string, example: 'Updated description' },
              price: { type: :number, example: 48000 },
              status: { type: :string, enum: ['active', 'sold'], example: 'sold' },
              year: { type: :integer, example: 2020 },
              odo: { type: :integer, example: 20000 },
              brand_id: { type: :integer, example: 1 },
              model_id: { type: :integer, example: 1 },
              version_id: { type: :integer, example: 1 }
            }
          },
          images: {
            type: :array,
            items: { type: :string },
            example: ['http://example.com/newimage1.jpg']
          }
        },
        required: ['sale_post']
      }

      response '200', 'sale post updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 description: { type: :string },
                 price: { type: :number },
                 status: { type: :string },
                 year: { type: :integer },
                 odo: { type: :integer },
                 user_id: { type: :integer },
                 brand_id: { type: :integer },
                 model_id: { type: :integer },
                 version_id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime },
                 sale_post_images: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       image_url: { type: :string }
                     }
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

      response '403', 'forbidden' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Unauthorized' }
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
                   additionalProperties: {
                     type: :array,
                     items: { type: :string }
                   },
                   example: { status: ['is not included in the list'] }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end

    delete 'Deletes a sale post' do
      tags 'Sale Posts'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true

      response '200', 'sale post deleted' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Sale post deleted successfully' }
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

      response '403', 'forbidden' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Unauthorized' }
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

      response '422', 'unprocessable entity' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: {
                     type: :array,
                     items: { type: :string }
                   }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/sale_posts/{sale_post_id}/sale_post_images' do
    parameter name: :sale_post_id, in: :path, type: :integer, description: 'Sale Post ID'

    post 'Adds images to a sale post' do
      tags 'Sale Post Images'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      consumes 'application/json'
      parameter name: :image_params, in: :body, schema: {
        type: :object,
        properties: {
          sale_post_image: {
            type: :object,
            properties: {
              image_url: { type: :string, example: 'http://example.com/image.jpg' }
            },
            required: ['image_url']
          }
        },
        required: ['sale_post_image']
      }

      response '201', 'image created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 sale_post_id: { type: :integer },
                 image_url: { type: :string },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime }
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

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: {
                     type: :array,
                     items: { type: :string }
                   },
                   example: { image_url: ['can\'t be blank'] }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end

  path '/api/sale_posts/{sale_post_id}/sale_post_images/{id}' do
    parameter name: :sale_post_id, in: :path, type: :integer, description: 'Sale Post ID'
    parameter name: :id, in: :path, type: :integer, description: 'Sale Post Image ID'

    delete 'Deletes a sale post image' do
      tags 'Sale Post Images'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true

      response '200', 'image deleted' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Image deleted successfully' }
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

      response '404', 'sale post or image not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Sale post image not found' }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end
    end
  end
end
