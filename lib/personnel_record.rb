class PersonnelRecord

  attr_reader :name, :payroll_records

  def initialize(payee_name, records)
    @name = payee_name
    @payroll_records = records.where(payee: @name).order(:start_date)
  end

  def history_by_job_title
    @payroll_records.inject(Hashie::Mash.new{|h,k| h[k] = [] }) do |h, record|
      h[record.purpose] << record

      h
    end
  end

end



def PersonnelRecord(records)
  p_records = records.personnel
  payees = p_records.pluck(:payee).uniq

  payees.map do |p|
    PersonnelRecord.new(p, p_records)
  end
end

