class Report < ApplicationRecord
  belongs_to :reporter, class_name: 'User'
  belongs_to :reportable, polymorphic: true

  validates :reason, presence: true
  validates :status, presence: true, inclusion: { in: %w(pending resolved rejected) }
end
