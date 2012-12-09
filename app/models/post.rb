class Post < ActiveRecord::Base
  attr_accessible :text, :title, :content, :discussion, :discussion_id
  belongs_to :discussion
  belongs_to :board
  after_create :update_discussion_last_post_at
  after_destroy :destroy_empty_discussion

  # Paperclip
  has_attached_file :content#, styles: { thumb: "250x250#" }

  validate :has_text_or_content

  def update_discussion_last_post_at
    discussion.last_post_at = Time.now.to_i
    discussion.save
  end

  def has_text_or_content
    if !text? && !content?
      errors.add(:base, 'Post needs text or content.')
    end
  end

  def destroy_empty_discussion
    discussion.destroy if discussion.posts.empty?
  end
end
