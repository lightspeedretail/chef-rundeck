module RundeckJob
  def validate_job(job)
    raise 'Invalid job. Please remove the id and/or uuid' if job =~ /(id:|uuid:)/
  end
end
