class ReportSerializer < ActiveModel::Serializer
  attributes :id, :reason, :status, :created_at, :updated_at, :reportable_type

  belongs_to :reporter
  belongs_to :reportable

  def reporter
    {
      id: object.reporter.id,
      email: object.reporter.email,
      name: object.reporter.full_name
    }
  end

  def reportable
    case object.reportable_type
    when 'User'
      {
        id: object.reportable.id,
        email: object.reportable.email,
        name: object.reportable.full_name,
        type: 'User'
      }
    when 'SalePost'
      {
        id: object.reportable.id,
        title: object.reportable.title,
        user_id: object.reportable.user_id,
        type: 'SalePost'
      }
    else
      {}
    end
  end
end
