class PersonnelRecord

  attr_reader :name, :payroll_records

  def initialize(payee_name, records)
    @name = payee_name
    @payroll_records = records.where(payee: @name).order(:start_date)
  end


  def history_by_job_title
    @payroll_records.inject(Hash.new{|h,k| h[k] = [] }) do |hsh, record|
      hsh[record.purpose] << record

      hsh
    end
  end

  def total_amount
    @payroll_records.inject(0){|s, r| s += r.amount}
  end

end



def PersonnelRecord(records)
  p_records = records.personnel
  payees = p_records.pluck(:payee).uniq

  payees.map do |p|
    PersonnelRecord.new(p, p_records)
  end
end

