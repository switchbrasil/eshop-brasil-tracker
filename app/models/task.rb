class Task < ApplicationRecord
  def self.start(title)
    task = create!(title: title, status: 'running')
    begin
      yield
      task.update!(status: 'done')
    rescue => e
      Sentry.capture_exception(e, level: :fatal, extra: { task: task })
      task.update!(status: 'failed', message: "#{e.class.name} - #{e.message}")
    end
  end
end
