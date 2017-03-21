class DeleteMessages < Message
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def check_delete_way
    find_message

    if @message.delete_way == 'after_hour'
      self.delete_at_time
    else
      self.delete_on_click
    end
  end

  def delete_at_time
    find_message

    if (Time.now - @message.created_at).to_i > 3600
      @message.destroy
    end
  end

  def delete_on_click
    find_message
    @message.destroy
  end

  def find_message
    @message = Message.find_by_id(@id)
  end

end
