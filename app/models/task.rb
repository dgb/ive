class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  before_save :update_created_at

  def self.by_days
    desc(:created_at).inject({}){ |hash, task| (hash[task.created_at.at_beginning_of_day] ||= []) << task; hash }
  end

  def update_created_at
    begin
      self[:created_at] = Time.new(*attributes.collect { |k, v| v.to_i if k =~ /created_at\(/ }.compact)
    rescue; end
  end
end
