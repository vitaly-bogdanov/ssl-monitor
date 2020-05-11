class Domain < ApplicationRecord
  after_create_commit :monitoring_start
  validates :name, presence: true, uniqueness: true

  def monitoring_start
    SslMonitorJob.perform_later()
  end
end
