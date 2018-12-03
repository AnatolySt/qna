class AddPolymorphicAssociationToVotes < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :votes, :votable, polymorphic: true, index: true
  end
end
