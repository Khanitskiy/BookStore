class RatingScore < ActiveModel::Validator
  def validate(record)
    if record.rating.to_i < 1 || record.rating.to_i > 10
      record.errors[:rating] << 'Score must be more than 0 and less than 11'
    end
  end
end
