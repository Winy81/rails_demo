module DealsHelper

  def type_checked_deal(record)
    if record.has_key?("deal")
      return record["deal"]
    elsif record.has_key?("event")
      return record["event"]
    elsif record.has_key?("shop")
      return record["shop"]
    end
  end

end
