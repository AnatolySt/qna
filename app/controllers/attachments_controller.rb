class AttachmentsController < ApplicationController

  before_action :set_attachment, only: [:destroy]

  authorize_resource

  def destroy
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
    end
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end