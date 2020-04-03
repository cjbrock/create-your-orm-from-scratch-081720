class Tweet
  attr_accessor :message, :username
  attr_reader :id

  def self.all
    results = DB[:conn].execute('SELECT * FROM tweets')
    results.map{|tweet| Tweet.new(tweet)}

  end

  def initialize(props={})
    @id = props['id']
    @message = props['message']
    @username = props['username']
  end

  def save
    if self.id
      sql = "UPDATE tweets SET username = ?, message = ? WHERE id = ?"
      DB[:conn].execute(sql, self.username, self.message, self.id)
    else
      sql = "INSERT INTO tweets(username, message) VALUES(?, ?)"
      DB[:conn].execute(sql, self.username, self.message)
    end
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM tweets WHERE id = ?"
    tweet = DB[:conn].execute(sql, id).first
    self.new(tweet)
  end


  def self.find_by_username(username)
    sql = "SELECT * FROM tweets WHERE username = ?"
    tweets = DB[:conn].execute(sql, username) 
    tweets.map do |tweet|
      new_tweet = self.new(tweet)
    end
  end

  def delete
    DB[:conn].execute("DELETE FROM tweets WHERE id=?", self.id)
  end

end
