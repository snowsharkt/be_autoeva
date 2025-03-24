require 'swagger_helper'

RSpec.describe 'AuthController API', type: :request do
  path "/api/v1/signup" do
    post "Signup" do
      tags "Auth"
      consumes 'application/json'
      produces "application/json"
      parameter name: :params, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            required: %w[email password password_confirmation],
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string, format: :password },
              password_confirmation: { type: :string, format: :password }
            }
          }
        }
      }
      response "200", :success do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     code: { type: :integer, },
                     message: { type: :string, }
                   }
                 },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer, },
                     email: { type: :string, format: :email},
                     first_name: { type: :string, nullable: true },
                     last_name: { type: :string, nullable: true },
                     role: { type: :string },
                     phone_number: { type: :string, nullable: true },
                     full_name: { type: :string}
                   }
                 }
               }
        run_test!
      end

      response "422", :failure do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     code: { type: :integer},
                     message: { type: :string}
                   }
                 }
               }
        run_test!
      end
    end

  end

  path "/api/v1/login" do
    post "Login" do
      tags "Auth"
      consumes 'application/json'
      produces "application/json"
      parameter name: :params, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            required: %w[email password],
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string, format: :password },
            }
          }
        }
      }
      response "200", :success do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     code: { type: :integer, },
                     message: { type: :string, }
                   }
                 },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer, },
                     email: { type: :string, format: :email},
                     first_name: { type: :string, nullable: true },
                     last_name: { type: :string, nullable: true },
                     role: { type: :string },
                     phone_number: { type: :string, nullable: true },
                     full_name: { type: :string}
                   }
                 }
               }
        run_test!
      end
      response "401", :failure do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }
        run_test!
      end
    end
  end
end
