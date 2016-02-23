class RatingScore < ActiveModel::Validator
  def validate(record)
    unless record.rating > 0 && record.rating <= 10
      record.errors[:rating] << "Score must be more than 0 and less than 11"
    end
  end
end