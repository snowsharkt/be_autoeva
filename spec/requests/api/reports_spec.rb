require 'swagger_helper'

RSpec.describe 'Reports API', type: :request do
  path '/api/reports' do
    post 'Creates a report' do
      tags 'Reports'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      consumes 'application/json'
      parameter name: :report, in: :body, schema: {
        type: :object,
        properties: {
          report: {
            type: :object,
            properties: {
              reason: { type: :string, example: 'Inappropriate content' },
              reportable_type: { type: :string, enum: ['User', 'SalePost'], example: 'User' },
              reportable_id: { type: :integer, example: 1 }
            },
            required: ['reason', 'reportable_type', 'reportable_id']
          }
        },
        required: ['report']
      }

      response '201', 'report created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 reason: { type: :string },
                 status: { type: :string, enum: ['pending', 'resolved', 'rejected'] },
                 reporter_id: { type: :integer },
                 reportable_type: { type: :string },
                 reportable_id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime }
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
                   example: { reason: ["can't be blank"] }
                 }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '404', 'reportable not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Reportable not found' }
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

    get 'Lists all reports (admin only)' do
      tags 'Reports'
      security [bearer_auth: []]
      parameter name: 'access-token', in: :header, type: :string, required: true
      parameter name: 'client', in: :header, type: :string, required: true
      parameter name: 'uid', in: :header, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number for pagination'
      produces 'application/json'

      response '200', 'reports retrieved' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       reason: { type: :string },
                       status: { type: :string, enum: ['pending', 'resolved', 'rejected'] },
                       reporter: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           email: { type: :string },
                           full_name: { type: :string }
                         }
                       },
                       reportable_type: { type: :string },
                       reportable_id: { type: :integer },
                       created_at: { type: :string, format: :datetime }
                     }
                   }
                 },
                 current_page: { type: :integer },
                 total_pages: { type: :integer }
               }
        run_test! do |response|
          # Empty block - just for documentation
        end
      end

      response '403', 'forbidden' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Not authorized' }
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
end
